extends RefCounted
## P2 persistent model. This file owns authoritative data; scenes are only views.
## Balance values stay null until approved or explicitly configured by a test.

const CanonLoader = preload("res://scripts/foundation/canon_loader.gd")
const HomeSystem = preload("res://scripts/home/home_system.gd")
const SAVE_VERSION: int = 3
const DUTIES = ["gate", "refuge", "gate", "refuge", "gate", "refuge", "off"]
const PHASES = ["morning", "daytime", "evening"]
const ALLOWED_ENTRIES = ["authorized", "denied", "held"]
const ALLOWED_PAUSES = ["menus", "reading_documents"]

var state: Dictionary = {}
var last_error: String = ""

func _init() -> void:
    reset()

func reset() -> void:
    last_error = ""
    var canonical: Dictionary = CanonLoader.load_characters()
    var people: Dictionary = {}
    for record in canonical.get("characters", []):
        if record is Dictionary:
            people[str(record.get("id", ""))] = record.duplicate(true)
    state = {
        "schema_version": SAVE_VERSION,
        "world_id": "uc.world.main",
        "qa_mode": false,
        "calendar": {"day_index": 0, "phase": "morning"},
        "characters": people,
        "households": {
            "uc.home.mama": {"members": ["uc.family.mama", "uc.family.button", "uc.family.hazel"]},
            "uc.home.grandma": {"members": ["uc.family.grandma"]}
        },
        "guardian_links": {
            "uc.family.button": {"guardian_id": "uc.family.mama", "basis": "biological_parent"},
            "uc.family.hazel": {"guardian_id": "uc.family.mama", "basis": "biological_parent"}
        },
        "temporary_care": {},
        "legal_orders": {},
        "entry_permissions": {},
        "refuge_placements": {},
        "case_records": {},
        "financials": {
            "ledgers": {
                "household": _empty_ledger(),
                "refuge": _empty_ledger()
            },
            "mafia_debt": {"principal_hm": null, "outstanding_hm": null,
                "interest_basis_points": null, "next_due_day": null, "status": "unconfigured"}
        },
        "shift_clock": {"duration_seconds": null, "elapsed_seconds": 0.0,
            "enabled": true, "pause_reasons": [], "running": false},
        "home": HomeSystem.initial_state(),
        "events": [], "next_event_sequence": 1
    }

func _empty_ledger() -> Dictionary:
    return {"opening_balance_hm": null, "balance_hm": null, "transactions": []}

func snapshot() -> Dictionary:
    return state.duplicate(true)

func restore_validated(candidate: Dictionary) -> bool:
    var errors: Array[String] = validate_state(candidate)
    if not errors.is_empty():
        return _fail("Invalid world: " + "; ".join(errors))
    state = candidate.duplicate(true)
    last_error = ""
    return true

func _fail(reason: String) -> bool:
    last_error = reason
    return false

func _record(kind: String, subject_id: String, details: Dictionary) -> int:
    var sequence: int = int(state["next_event_sequence"])
    state["next_event_sequence"] = sequence + 1
    state["events"].append({"sequence": sequence, "day_index": int(state["calendar"]["day_index"]),
        "phase": state["calendar"]["phase"], "type": kind,
        "subject_id": subject_id, "details": details.duplicate(true)})
    return sequence

func has_character(character_id: String) -> bool:
    return state["characters"].has(character_id)

func enable_qa_mode() -> void:
    # QA fixtures are never included in initial canonical game data.
    state["qa_mode"] = true

func register_qa_subject(character_id: String, case_id: String) -> bool:
    if not bool(state["qa_mode"]) or not character_id.begins_with("uc.qa.") or has_character(character_id) or not state["case_records"].has(case_id):
        return _fail("QA-only anonymous subject registration rejected")
    state["characters"][character_id] = {"id": character_id, "display_name": "", "species": "brown_bear", "age_months": null, "qa_fixture": true}
    _record("qa.anonymous_subject", character_id, {"case_id": case_id})
    last_error = ""
    return true

func current_duty() -> String:
    return DUTIES[int(state["calendar"]["day_index"]) % 7]

func change_phase(next_phase: String) -> bool:
    var previous: String = str(state["calendar"]["phase"])
    if (previous == "morning" and next_phase != "daytime") or (previous == "daytime" and next_phase != "evening") or previous == "evening":
        return _fail("Invalid phase transition")
    state["calendar"]["phase"] = next_phase
    state["shift_clock"]["running"] = false
    _record("calendar.phase", "", {"from": previous, "to": next_phase})
    last_error = ""
    return true

func advance_day() -> bool:
    if state["calendar"]["phase"] != "evening":
        return _fail("Day can advance only after evening")
    state["calendar"]["day_index"] = int(state["calendar"]["day_index"]) + 1
    state["calendar"]["phase"] = "morning"
    state["shift_clock"]["elapsed_seconds"] = 0.0
    state["shift_clock"]["running"] = false
    state["shift_clock"]["pause_reasons"] = []
    # Character ages are anchored to starting months + elapsed calendar days.
    # Exact month-length and development transitions are separate approved decisions.
    _record("calendar.new_day", "", {"duty": current_duty()})
    last_error = ""
    return true

func configure_shift_duration(seconds: int) -> bool:
    if seconds <= 0:
        return _fail("Shift duration must be positive")
    state["shift_clock"]["duration_seconds"] = seconds
    state["shift_clock"]["elapsed_seconds"] = 0.0
    _record("clock.configured", "", {"seconds": seconds, "provisional": true})
    last_error = ""
    return true

func set_shift_timer_enabled(enabled: bool) -> void:
    state["shift_clock"]["enabled"] = enabled
    _record("clock.setting", "", {"enabled": enabled})

func start_shift() -> bool:
    if state["calendar"]["phase"] != "daytime" or current_duty() == "off":
        return _fail("No work shift scheduled")
    if state["shift_clock"]["duration_seconds"] == null and bool(state["shift_clock"]["enabled"]):
        return _fail("No shift duration configured")
    state["shift_clock"]["running"] = true
    state["shift_clock"]["elapsed_seconds"] = 0.0
    _record("clock.start", "", {"duty": current_duty()})
    last_error = ""
    return true

func pause_shift(reason: String, paused: bool) -> bool:
    if not reason in ALLOWED_PAUSES:
        return _fail("Unknown pause reason")
    var reasons: Array = state["shift_clock"]["pause_reasons"]
    if paused and not reasons.has(reason):
        reasons.append(reason)
    if not paused:
        reasons.erase(reason)
    last_error = ""
    return true

func tick_shift(seconds: float) -> bool:
    if seconds < 0:
        return _fail("Negative clock step")
    var clock: Dictionary = state["shift_clock"]
    if not bool(clock["running"]) or not bool(clock["enabled"]) or not clock["pause_reasons"].is_empty():
        return true
    var duration: Variant = clock["duration_seconds"]
    if duration == null:
        return _fail("Unconfigured shift clock")
    clock["elapsed_seconds"] = minf(float(duration), float(clock["elapsed_seconds"]) + seconds)
    if float(clock["elapsed_seconds"]) >= float(duration):
        clock["running"] = false
        _record("clock.complete", "", {"duty": current_duty()})
    return true

func register_case(case_id: String, facts: Dictionary) -> bool:
    if case_id.is_empty() or state["case_records"].has(case_id):
        return _fail("Case ID missing or duplicated")
    state["case_records"][case_id] = {"facts": facts.duplicate(true), "created_day": state["calendar"]["day_index"]}
    _record("case.registered", "", {"case_id": case_id})
    last_error = ""
    return true

func record_entry_decision(character_id: String, status: String, case_id: String) -> bool:
    if not has_character(character_id) or not status in ALLOWED_ENTRIES or not state["case_records"].has(case_id):
        return _fail("Invalid character, status or case")
    if state["refuge_placements"].get(character_id, {}).get("status", "") == "placed" and status != "authorized":
        return _fail("Existing refuge placement requires a separate legal release procedure")
    state["entry_permissions"][character_id] = {"status": status, "case_id": case_id}
    _record("legal.entry", character_id, {"status": status, "case_id": case_id})
    last_error = ""
    return true

func place_in_refuge(character_id: String, case_id: String) -> bool:
    var entry: Dictionary = state["entry_permissions"].get(character_id, {})
    if not has_character(character_id) or entry.get("status", "") != "authorized" or not state["case_records"].has(case_id):
        return _fail("Refuge placement requires separate authorized entry and a case")
    state["refuge_placements"][character_id] = {"status": "placed", "refuge_id": "uc.refuge.briarwood", "case_id": case_id}
    _record("refuge.placed", character_id, {"case_id": case_id})
    last_error = ""
    return true

func release_from_refuge(character_id: String, case_id: String) -> bool:
    var placement: Dictionary = state["refuge_placements"].get(character_id, {})
    if placement.get("status", "") != "placed" or not state["case_records"].has(case_id):
        return _fail("No active placement or case")
    placement["status"] = "released"
    placement["release_case_id"] = case_id
    _record("refuge.released", character_id, {"case_id": case_id})
    last_error = ""
    return true

func change_guardian(child_id: String, guardian_id: String, order: Dictionary) -> bool:
    # No generic follow-up can change guardianship. Requires a specifically scoped order.
    var order_id: String = str(order.get("id", ""))
    if not has_character(child_id) or not has_character(guardian_id) or child_id == guardian_id:
        return _fail("Invalid child or guardian")
    if order_id.is_empty() or state["legal_orders"].has(order_id) or order.get("scope", "") != "guardianship" or order.get("approved", false) != true:
        return _fail("A unique approved guardianship order is required")
    var old: Dictionary = state["guardian_links"].get(child_id, {})
    state["legal_orders"][order_id] = order.duplicate(true)
    state["guardian_links"][child_id] = {"guardian_id": guardian_id, "basis": "recorded_order", "order_id": order_id}
    _record("legal.guardian_changed", child_id, {"from": old.get("guardian_id", ""), "to": guardian_id, "order_id": order_id})
    last_error = ""
    return true

func assign_temporary_care(child_id: String, caretaker_id: String, reason: String) -> bool:
    if not has_character(child_id) or not has_character(caretaker_id) or reason.is_empty():
        return _fail("Invalid temporary care assignment")
    state["temporary_care"][child_id] = {"caretaker_id": caretaker_id, "reason": reason}
    _record("care.temporary_assigned", child_id, {"caretaker_id": caretaker_id, "reason": reason})
    last_error = ""
    return true

func configure_opening_balance(ledger_id: String, amount_hm: int) -> bool:
    var ledgers: Dictionary = state["financials"]["ledgers"]
    if not ledgers.has(ledger_id) or amount_hm < 0 or ledgers[ledger_id]["opening_balance_hm"] != null:
        return _fail("Ledger invalid, negative or already initialized")
    ledgers[ledger_id]["opening_balance_hm"] = amount_hm
    ledgers[ledger_id]["balance_hm"] = amount_hm
    _record("finance.opening_balance", ledger_id, {"amount_hm": amount_hm, "provisional": true})
    last_error = ""
    return true

func post_hm(ledger_id: String, delta_hm: int, reason: String) -> bool:
    var ledgers: Dictionary = state["financials"]["ledgers"]
    if not ledgers.has(ledger_id) or delta_hm == 0 or reason.is_empty():
        return _fail("Invalid transaction")
    var ledger: Dictionary = ledgers[ledger_id]
    if ledger["balance_hm"] == null or int(ledger["balance_hm"]) + delta_hm < 0:
        return _fail("Ledger unconfigured or insufficient funds")
    var balance: int = int(ledger["balance_hm"]) + delta_hm
    var event_id: int = _record("finance.transaction", ledger_id, {"delta_hm": delta_hm, "reason": reason})
    ledger["balance_hm"] = balance
    ledger["transactions"].append({"event_id": event_id, "delta_hm": delta_hm, "balance_after_hm": balance, "reason": reason})
    last_error = ""
    return true

func configure_debt(principal_hm: int, interest_basis_points: int, due_day: int) -> bool:
    var debt: Dictionary = state["financials"]["mafia_debt"]
    if debt["status"] != "unconfigured" or principal_hm <= 0 or interest_basis_points < 0 or due_day < 0:
        return _fail("Invalid debt terms")
    debt["principal_hm"] = principal_hm
    debt["outstanding_hm"] = principal_hm
    debt["interest_basis_points"] = interest_basis_points
    debt["next_due_day"] = due_day
    debt["status"] = "active"
    _record("debt.configured", "", {"principal_hm": principal_hm, "provisional": true})
    last_error = ""
    return true

func repay_debt(amount_hm: int) -> bool:
    var debt: Dictionary = state["financials"]["mafia_debt"]
    if debt["status"] != "active" or amount_hm <= 0 or amount_hm > int(debt["outstanding_hm"]):
        return _fail("Invalid debt payment")
    if not post_hm("household", -amount_hm, "Debt repayment"):
        return false
    debt["outstanding_hm"] = int(debt["outstanding_hm"]) - amount_hm
    if int(debt["outstanding_hm"]) == 0:
        debt["status"] = "paid"
    _record("debt.payment", "", {"amount_hm": amount_hm})
    return true

func select_home_cub(cub_id: String) -> bool:
    if not HomeSystem.select(state["home"], cub_id):
        return _fail("Unknown approved cub")
    last_error = ""
    return true

func act_with_cub(cub_id: String, action: String) -> bool:
    var result: Dictionary = HomeSystem.interact(state["home"], cub_id, action)
    if not bool(result.get("ok", false)):
        return _fail(str(result.get("reason", "Invalid home interaction")))
    _record(str(result.get("event", "home.action")), cub_id, {"action": action, "description": str(result.get("description", ""))})
    last_error = ""
    return true

func tick_home(steps: int = 1) -> bool:
    if steps < 1 or steps > 32:
        return _fail("Invalid home step count")
    var events: Array[Dictionary] = HomeSystem.step(state["home"], steps)
    for event in events:
        _record(str(event["kind"]), str(event["subject_id"]), event["details"])
    last_error = ""
    return true

static func validate_state(candidate: Dictionary) -> Array[String]:
    var errors: Array[String] = []
    if int(candidate.get("schema_version", -1)) != SAVE_VERSION:
        errors.append("unsupported save version")
    var characters: Variant = candidate.get("characters", null)
    if not characters is Dictionary:
        errors.append("characters must be a dictionary")
        return errors
    var expected: Array = CanonLoader.EXPECTED_IDS
    if characters.size() < expected.size():
        errors.append("missing canonical characters")
    for id in expected:
        if not characters.has(id):
            errors.append("missing approved character " + id)
    var baseline: Dictionary = CanonLoader.load_characters()
    var canonical_by_id: Dictionary = {}
    for record in baseline.get("characters", []):
        canonical_by_id[str(record.get("id", ""))] = record
    if not candidate.get("qa_mode", false) is bool:
        errors.append("invalid QA mode")
    for id in characters.keys():
        var person: Variant = characters[id]
        if not person is Dictionary:
            errors.append("invalid character record")
            continue
        if not expected.has(id):
            if not bool(candidate.get("qa_mode", false)) or not str(id).begins_with("uc.qa.") or person.get("qa_fixture", false) != true or person.get("display_name", "") != "":
                errors.append("unapproved additional character")
            continue
        if person.get("id", "") != id or person.get("display_name", "") != canonical_by_id[id].get("display_name", "") or person.get("species", "") != canonical_by_id[id].get("species", ""):
            errors.append("character identity changed")
        for fixed_field in ["mother_id", "littermate_id", "coronation_age_months"]:
            if canonical_by_id[id].has(fixed_field) and person.get(fixed_field, null) != canonical_by_id[id][fixed_field]:
                errors.append("canonical relation changed")
    var home_errors: Array[String] = HomeSystem.valid(candidate.get("home", null))
    for home_error in home_errors:
        errors.append("home: " + home_error)
    var calendar: Variant = candidate.get("calendar", null)
    if not calendar is Dictionary or not _is_whole_number(calendar.get("day_index", -1)) or int(calendar.get("day_index", -1)) < 0 or not PHASES.has(calendar.get("phase", "")):
        errors.append("invalid calendar")
    var households: Variant = candidate.get("households", null)
    if not households is Dictionary:
        errors.append("invalid households")
    else:
        for household_id in households.keys():
            var h: Variant = households[household_id]
            if not h is Dictionary or not h.get("members", null) is Array:
                errors.append("invalid household")
                continue
            for member_id in h["members"]:
                if not characters.has(member_id):
                    errors.append("unknown household member")
    var guardians: Variant = candidate.get("guardian_links", null)
    if not guardians is Dictionary:
        errors.append("invalid guardians")
    else:
        for child_id in guardians.keys():
            var link: Variant = guardians[child_id]
            if not characters.has(child_id) or not link is Dictionary or not characters.has(link.get("guardian_id", "")):
                errors.append("invalid guardianship link")
    for key in ["entry_permissions", "refuge_placements", "temporary_care"]:
        var records: Variant = candidate.get(key, null)
        if not records is Dictionary:
            errors.append("invalid " + key)
            continue
        for id in records.keys():
            if not characters.has(id) or not records[id] is Dictionary:
                errors.append("unrecognized subject in " + key)
    var cases: Variant = candidate.get("case_records", null)
    if not cases is Dictionary:
        errors.append("invalid cases")
    var orders: Variant = candidate.get("legal_orders", null)
    if not orders is Dictionary:
        errors.append("invalid legal orders")
    else:
        for order_id in orders.keys():
            var order: Variant = orders[order_id]
            if not order is Dictionary or order.get("id", "") != order_id or order.get("scope", "") != "guardianship" or order.get("approved", false) != true:
                errors.append("unapproved legal order")
    if guardians is Dictionary and orders is Dictionary:
        for child_id in guardians.keys():
            var link: Variant = guardians[child_id]
            if link is Dictionary and link.get("basis", "") == "recorded_order" and not orders.has(link.get("order_id", "")):
                errors.append("guardian order missing")
    if cases is Dictionary:
        var entries: Variant = candidate.get("entry_permissions", {})
        if entries is Dictionary:
            for subject in entries.keys():
                var entry: Variant = entries[subject]
                if entry is Dictionary and (not ALLOWED_ENTRIES.has(entry.get("status", "")) or not cases.has(entry.get("case_id", ""))):
                    errors.append("illegal entry decision")
        var placements: Variant = candidate.get("refuge_placements", {})
        if placements is Dictionary:
            for subject in placements.keys():
                var place: Variant = placements[subject]
                if place is Dictionary and (not ["placed", "released"].has(place.get("status", "")) or not cases.has(place.get("case_id", ""))):
                    errors.append("invalid refuge placement")
                # A placement is a distinct decision and requires authorized entry.
                if entries is Dictionary:
                    var matching_entry: Variant = entries.get(subject, null)
                    if not matching_entry is Dictionary or matching_entry.get("status", "") != "authorized":
                        errors.append("refuge placement lacks entry clearance")
    var financials: Variant = candidate.get("financials", null)
    if not financials is Dictionary or not financials.get("ledgers", null) is Dictionary:
        errors.append("invalid finances")
    else:
        var ledgers: Dictionary = financials["ledgers"]
        if ledgers.size() != 2 or not ledgers.has("household") or not ledgers.has("refuge"):
            errors.append("missing or extra finance ledger")
        for lid in ["household", "refuge"]:
            var ledger: Variant = ledgers.get(lid, null)
            if not ledger is Dictionary or not ledger.get("transactions", null) is Array:
                errors.append("invalid finance ledger " + lid)
                continue
            var opened: Variant = ledger.get("opening_balance_hm", null)
            var current: Variant = ledger.get("balance_hm", null)
            if opened == null:
                if current != null or not ledger["transactions"].is_empty():
                    errors.append("unconfigured ledger used")
            elif not _is_whole_number(opened) or int(opened) < 0:
                errors.append("invalid opening balance")
            else:
                var computed: int = int(opened)
                for tx in ledger["transactions"]:
                    if not tx is Dictionary or not _is_whole_number(tx.get("delta_hm", null)):
                        errors.append("invalid transaction")
                        continue
                    computed += int(tx["delta_hm"])
                    if computed < 0 or tx.get("balance_after_hm", null) != computed:
                        errors.append("ledger reconciliation failed")
                if not _is_whole_number(current) or int(current) != computed:
                    errors.append("ledger balance mismatch")
        var debt: Variant = financials.get("mafia_debt", null)
        if not debt is Dictionary or not ["unconfigured", "active", "paid"].has(debt.get("status", "")):
            errors.append("invalid debt record")
        elif debt["status"] == "unconfigured" and (debt.get("outstanding_hm", null) != null or debt.get("principal_hm", null) != null):
            errors.append("invented debt amount")
        elif debt["status"] != "unconfigured":
            if debt["status"] == "paid" and debt.get("outstanding_hm", null) != 0:
                errors.append("paid debt remains outstanding")
            if not _is_whole_number(debt.get("outstanding_hm", null)) or not _is_whole_number(debt.get("principal_hm", null)):
                errors.append("invalid debt amounts")
            elif int(debt["outstanding_hm"]) < 0 or int(debt["outstanding_hm"]) > int(debt["principal_hm"]):
                errors.append("invalid debt balance")
    var events: Variant = candidate.get("events", null)
    if not events is Array:
        errors.append("invalid event history")
    else:
        var expected_seq: int = 1
        for event in events:
            if not event is Dictionary or event.get("sequence", null) != expected_seq:
                errors.append("event order invalid")
                break
            expected_seq += 1
        if candidate.get("next_event_sequence", 0) != expected_seq:
            errors.append("next event sequence mismatch")
    var clock: Variant = candidate.get("shift_clock", null)
    if not clock is Dictionary or not clock.get("pause_reasons", null) is Array:
        errors.append("invalid shift clock")
    else:
        for pause in clock["pause_reasons"]:
            if not ALLOWED_PAUSES.has(pause):
                errors.append("unknown shift clock pause")
        if not clock.get("enabled", null) is bool or not clock.get("running", null) is bool:
            errors.append("invalid clock flags")
        var duration: Variant = clock.get("duration_seconds", null)
        var elapsed: Variant = clock.get("elapsed_seconds", null)
        if duration != null and (not _is_whole_number(duration) or int(duration) <= 0):
            errors.append("invalid shift duration")
        if not (elapsed is float or elapsed is int) or not is_finite(float(elapsed)) or float(elapsed) < 0.0:
            errors.append("invalid clock elapsed")
    return errors

static func _is_whole_number(value: Variant) -> bool:
    if value is int:
        return true
    if value is float:
        return is_finite(value) and value == floorf(value)
    return false
