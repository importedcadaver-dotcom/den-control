extends RefCounted
## P4 gate training system. Uses anonymous QA subjects, NOT new fictional canon NPCs.
## Training regulations are explicitly provisional and do not establish Honeyhold law.

const FIXTURE_PATH := "res://data/qa/gate_training_cases.json"
const STATUS_VALUES := ["authorized", "held", "denied"]
const ASK_VALUES := ["purpose", "papers"]
const VERIFY_VALUES := ["registry", "guardian"]
const VIEW_VALUES := ["summary", "pass", "identification", "guardian", "rules"]
const REASON_VALUES := ["valid_pass", "expired_pass", "identity_unverified", "guardian_unverified", "registry_exception"]
const QA_SHIFT_SECONDS := 1200 # Provisional engineering duration, NOT approved shift length.
const MAX_CASES := 12

static func initial_state() -> Dictionary:
    return {"started": false, "complete": false, "shift_day": -1,
        "queue": [], "cursor": 0, "decisions": [], "asked": [], "verified": [],
        "view": "summary", "last_feedback": "", "skipped": [], "fixture_version": 1,
        "history": [], "fixture_snapshot": [], "fixture_digest": ""}

static func read_fixture() -> Dictionary:
    if not FileAccess.file_exists(FIXTURE_PATH):
        return {}
    var file := FileAccess.open(FIXTURE_PATH, FileAccess.READ)
    if file == null:
        return {}
    var parser := JSON.new()
    if parser.parse(file.get_as_text()) != OK or not parser.data is Dictionary:
        return {}
    return parser.data

static func begin(world: RefCounted) -> bool:
    var gate: Dictionary = world.state["gate"]
    var day: int = int(world.state["calendar"]["day_index"])
    if world.current_duty() != "gate" or not ["morning", "daytime"].has(world.state["calendar"]["phase"]):
        return world._fail("Not a scheduled gate shift")
    if bool(gate["started"]) and (not gate["complete"] or int(gate["shift_day"]) >= day):
        return world._fail("Gate shift already active or completed today")
    var fixture: Dictionary = read_fixture()
    if int(fixture.get("fixture_version", -1)) != 1 or not fixture.get("cases", null) is Array:
        return world._fail("Invalid P4 fixture")
    var cases: Array = fixture["cases"]
    if cases.is_empty() or cases.size() > MAX_CASES:
        return world._fail("Invalid QA case count")
    var used: Dictionary = {}
    for entry in cases:
        if not entry is Dictionary or str(entry.get("code", "")).is_empty() or used.has(entry.get("code", "")):
            return world._fail("Malformed or repeated QA case")
        used[entry["code"]] = true
    if not world.state["shift_clock"]["enabled"] is bool:
        return world._fail("Invalid shift configuration")
    var before: Dictionary = world.snapshot()
    var next_gate: Dictionary = initial_state()
    next_gate["history"] = gate["history"].duplicate(true)
    if bool(gate["started"]):
        var archived: Dictionary = gate.duplicate(true)
        archived.erase("history")
        next_gate["history"].append(archived)
    next_gate["fixture_snapshot"] = cases.duplicate(true)
    next_gate["fixture_digest"] = JSON.stringify(cases).sha256_text()
    world.state["gate"] = next_gate
    if not _apply_begin(world, cases, day):
        var reason: String = world.last_error
        world.state = before
        return world._fail(reason)
    if not world.validate_state(world.snapshot()).is_empty():
        world.state = before
        return world._fail("Shift initialization validation failed")
    world.last_error = ""
    return true

static func _apply_begin(world: RefCounted, cases: Array, day: int) -> bool:
    if world.state["calendar"]["phase"] == "morning" and not world.change_phase("daytime"):
        return false
    world.enable_qa_mode()
    var queue: Array = []
    for i in range(cases.size()):
        var record: Dictionary = cases[i].duplicate(true)
        var case_id := "uc.qa.gate.%d.%02d" % [day, i + 1]
        var subject_id := "uc.qa.visitor.%d.%02d" % [day, i + 1]
        var participants: Array = [subject_id]
        if bool(record.get("accompanied_minor", false)):
            participants.append(subject_id + ".cub")
        if not world.register_case(case_id, {"fixture_code": record["code"], "qa": true, "participant_ids": participants.duplicate(true)}):
            return false
        for participant in participants:
            if not world.register_qa_subject(participant, case_id):
                return false
        if str(record["subject"]).find("red panda") >= 0:
            world.state["characters"][subject_id]["species"] = "red_panda"
        elif str(record["subject"]).find("cat") >= 0:
            world.state["characters"][subject_id]["species"] = "domestic_cat"
        if participants.size() > 1:
            world.state["characters"][participants[1]]["age_months"] = 6
            world.state["characters"][participants[1]]["qa_minor"] = true
            # Accompaniment does not confer guardianship; verification is separate.
        record["case_id"] = case_id
        record["subject_id"] = subject_id
        record["participant_ids"] = participants
        queue.append(record)
    var gate: Dictionary = world.state["gate"]
    gate["started"] = true
    gate["shift_day"] = day
    gate["queue"] = queue
    gate["last_feedback"] = "Anonymous training cases; no canonical Honeyhold laws or citizens."
    if world.state["shift_clock"]["duration_seconds"] == null:
        if not world.configure_shift_duration(QA_SHIFT_SECONDS):
            return false
    if not world.start_shift():
        return false
    world._record("gate.training_open", "", {"case_count": queue.size(), "day_index": day, "qa_fixture": true})
    return true

static func current(world: RefCounted) -> Dictionary:
    var gate: Dictionary = world.state["gate"]
    if not gate["started"] or gate["complete"]:
        return {}
    var position: int = int(gate["cursor"])
    if position < 0 or position >= gate["queue"].size():
        return {}
    return gate["queue"][position]

static func inspection_view(world: RefCounted, name: String) -> bool:
    if not VIEW_VALUES.has(name) or not bool(world.state["gate"]["started"]):
        return world._fail("Unknown inspection view")
    if not world.pause_shift("reading_documents", name != "summary"):
        return false
    world.state["gate"]["view"] = name
    world.last_error = ""
    return true

static func ask(world: RefCounted, question: String) -> bool:
    var ticket: Dictionary = current(world)
    if ticket.is_empty() or not ASK_VALUES.has(question):
        return world._fail("Unknown question or no current applicant")
    var gate: Dictionary = world.state["gate"]
    if not gate["asked"].has(question):
        gate["asked"].append(question)
    gate["last_feedback"] = str(ticket["questions"].get(question, "No answer in this training case."))
    world._record("gate.question", str(ticket["subject_id"]), {"case_id": ticket["case_id"], "question": question})
    world.last_error = ""
    return true

static func verify(world: RefCounted, source: String) -> bool:
    var ticket: Dictionary = current(world)
    if ticket.is_empty() or not VERIFY_VALUES.has(source):
        return world._fail("Unknown verification source or no current applicant")
    var gate: Dictionary = world.state["gate"]
    if not gate["verified"].has(source):
        gate["verified"].append(source)
    gate["last_feedback"] = str(ticket["registry_response"] if source == "registry" else ticket["guardian_response"])
    world._record("gate.verification", str(ticket["subject_id"]), {"case_id": ticket["case_id"], "source": source})
    world.last_error = ""
    return true

static func decide(world: RefCounted, status: String, reason: String) -> bool:
    var ticket: Dictionary = current(world)
    if ticket.is_empty() or not STATUS_VALUES.has(status) or not REASON_VALUES.has(reason):
        return world._fail("A valid status, reason and current applicant are required")
    var gate: Dictionary = world.state["gate"]
    var required_check: String = str(ticket.get("requires_check", ""))
    # Special requests and contested identification must be checked before a final decision.
    # Routine obvious denials can be decided directly from the visible paperwork.
    if status != "held" and required_check != "" and not gate["verified"].has(required_check):
        return world._fail("Verify the " + required_check + " before closing this investigative case")
    var subject_id: String = str(ticket["subject_id"])
    var case_id: String = str(ticket["case_id"])
    for participant in ticket.get("participant_ids", [subject_id]):
        if not world.has_character(participant) or world.state["characters"][participant].get("registered_case_id", "") != case_id:
            return world._fail("Participant does not belong to this case")
    for participant in ticket.get("participant_ids", [subject_id]):
        if not world.record_entry_decision(participant, status, case_id):
            return false
    var correct: bool = status == ticket["expected_status"] and reason == ticket["expected_reason"]
    var outcome: Dictionary = {"case_id": case_id, "subject_id": subject_id,
        "status": status, "reason": reason, "matches_training_rule": correct,
        "asked": gate["asked"].duplicate(true), "verified": gate["verified"].duplicate(true),
        "participant_ids": ticket.get("participant_ids", [subject_id]).duplicate(true)}
    gate["decisions"].append(outcome)
    world.state["case_records"][case_id]["gate_training_result"] = outcome.duplicate(true)
    gate["last_feedback"] = ("Training audit: supported decision and reason. " if correct else "Training audit: review the relevant rule and evidence. ") + ("Entry permission updated; refuge placement and guardianship unchanged.")
    gate["cursor"] = int(gate["cursor"]) + 1
    gate["asked"] = []
    gate["verified"] = []
    inspection_view(world, "summary")
    world._record("gate.decision", subject_id, {"case_id": case_id, "status": status, "reason": reason, "training_match": correct})
    world.last_error = ""
    if int(gate["cursor"]) >= gate["queue"].size():
        return finish(world, false)
    return true

static func finish(world: RefCounted, allow_early: bool = false) -> bool:
    var gate: Dictionary = world.state["gate"]
    if not bool(gate["started"]) or bool(gate["complete"]):
        return world._fail("No active gate shift")
    if not allow_early and int(gate["cursor"]) < gate["queue"].size():
        return world._fail("Pending visitors remain; finish cases or end the shift early")
    var skipped: Array = []
    for index in range(int(gate["cursor"]), gate["queue"].size()):
        skipped.append(str(gate["queue"][index]["case_id"]))
    gate["skipped"] = skipped
    gate["complete"] = true
    inspection_view(world, "summary")
    world.state["shift_clock"]["running"] = false
    world._record("gate.shift_complete", "", {"decided": gate["decisions"].size(), "skipped": skipped.size(), "day_index": gate["shift_day"]})
    if world.state["calendar"]["phase"] == "daytime":
        world.change_phase("evening")
    gate["last_feedback"] = "Gate shift complete: %d decisions; %d unfinished training arrivals." % [gate["decisions"].size(), skipped.size()]
    world.last_error = ""
    return true

static func validate(value: Variant, world: Dictionary) -> Array[String]:
    var errors: Array[String] = []
    if not value is Dictionary:
        errors.append("missing P4 gate state")
        return errors
    var gate: Dictionary = value
    for field in ["started", "complete"]:
        if not gate.get(field, null) is bool:
            errors.append("gate flag invalid: " + field)
    for field in ["queue", "decisions", "asked", "verified", "skipped"]:
        if not gate.get(field, null) is Array:
            errors.append("gate list invalid: " + field)
    if not gate.get("queue", null) is Array or not gate.get("decisions", null) is Array:
        return errors
    var queue: Array = gate["queue"]
    var decisions: Array = gate["decisions"]
    if not gate.get("history", null) is Array or not gate.get("fixture_snapshot", null) is Array:
        errors.append("missing archived history or evidence")
        return errors
    var seen_days: Dictionary = {}
    for previous in gate["history"]:
        if not previous is Dictionary or not bool(previous.get("complete", false)) or seen_days.has(previous.get("shift_day", -1)):
            errors.append("invalid archived gate shift")
            continue
        seen_days[previous["shift_day"]] = true
        if previous.get("shift_day", -1) >= gate.get("shift_day", -1) or previous.get("fixture_digest", "") != JSON.stringify(previous.get("fixture_snapshot", [])).sha256_text():
            errors.append("archived gate date or evidence modified")
        if previous.get("cursor", -1) != previous.get("decisions", []).size():
            errors.append("archived gate cursor mismatch")
    if gate.get("started", false) and gate.get("fixture_digest", "") != JSON.stringify(gate["fixture_snapshot"]).sha256_text():
        errors.append("historical QA evidence digest mismatch")
    if queue.size() > MAX_CASES or not _whole(gate.get("cursor")) or not _whole(gate.get("shift_day")):
        errors.append("gate cursor or day malformed")
        return errors
    var cursor: int = int(gate["cursor"])
    if cursor < 0 or cursor > queue.size() or cursor != decisions.size():
        errors.append("gate cursor/decisions out of sync")
    if not VIEW_VALUES.has(gate.get("view", "")) or not gate.get("last_feedback", null) is String or int(gate.get("fixture_version", -1)) != 1:
        errors.append("gate view/feedback/version invalid")
    for key in ["asked", "verified"]:
        if gate.get(key) is Array:
            var allowed: Array = ASK_VALUES if key == "asked" else VERIFY_VALUES
            for item in gate[key]:
                if not allowed.has(item):
                    errors.append("invalid gate inquiry code")
    if not gate.get("started", false):
        if not queue.is_empty() or cursor != 0 or not decisions.is_empty() or gate.get("complete", false):
            errors.append("gate not started but contains results")
        return errors
    if gate.get("shift_day", -1) < 0 or gate.get("shift_day", -1) > world.get("calendar", {}).get("day_index", -1):
        errors.append("invalid gate shift day")
    if not world.get("qa_mode", false):
        errors.append("anonymous training gate without QA provenance")
    var source_cases: Array = gate["fixture_snapshot"]
    if source_cases.size() != queue.size():
        errors.append("QA fixture count modified")
    var seen: Dictionary = {}
    for i in range(queue.size()):
        var ticket: Variant = queue[i]
        if not ticket is Dictionary:
            errors.append("malformed gate ticket")
            continue
        if i < source_cases.size():
            var original: Dictionary = source_cases[i]
            for attribute in original.keys():
                if ticket.get(attribute, null) != original[attribute]:
                    errors.append("QA source case altered: " + str(attribute))
        var case_id: String = str(ticket.get("case_id", ""))
        var subject: String = str(ticket.get("subject_id", ""))
        if seen.has(case_id) or not case_id.begins_with("uc.qa.gate."):
            errors.append("duplicate or invalid gate case id")
        seen[case_id] = true
        if not world.get("characters", {}).has(subject) or not world.get("case_records", {}).has(case_id):
            errors.append("gate ticket missing persistent identity/case")
        var participants: Variant = ticket.get("participant_ids", null)
        if not participants is Array or participants.is_empty() or participants[0] != subject:
            errors.append("case participants missing")
        else:
            for person_id in participants:
                if not world.get("characters", {}).has(person_id) or world["characters"][person_id].get("registered_case_id", "") != case_id:
                    errors.append("participant-case membership mismatch")
        if not ["routine", "investigation"].has(ticket.get("type", "")) or not STATUS_VALUES.has(ticket.get("expected_status", "")) or not REASON_VALUES.has(ticket.get("expected_reason", "")):
            errors.append("invalid training case definition")
        if i < decisions.size():
            var result: Variant = decisions[i]
            if not result is Dictionary:
                errors.append("malformed gate decision")
                continue
            if result.get("subject_id", "") != subject or result.get("case_id", "") != case_id or not STATUS_VALUES.has(result.get("status", "")) or not REASON_VALUES.has(result.get("reason", "")):
                errors.append("gate decision identity/status mismatch")
            var legal: Variant = world.get("entry_permissions", {}).get(subject, null)
            if not legal is Dictionary or legal.get("status", "") != result.get("status", "") or legal.get("case_id", "") != case_id:
                errors.append("gate decision not synchronized with entry status")
            if result.get("matches_training_rule", null) != (result.get("status") == ticket.get("expected_status") and result.get("reason") == ticket.get("expected_reason")):
                errors.append("QA training audit result tampered")
            if not result.get("verified", null) is Array or not result.get("asked", null) is Array:
                errors.append("malformed case inquiries")
            elif result.get("status", "") != "held" and ticket.get("requires_check", "") != "" and not result["verified"].has(ticket["requires_check"]):
                errors.append("decision lacks required verification")
            var stored: Variant = world.get("case_records", {}).get(case_id, {}).get("gate_training_result", null)
            if not stored is Dictionary or JSON.stringify(stored) != JSON.stringify(result):
                errors.append("case training result mismatch")
            if participants is Array:
                if result.get("participant_ids", []) != participants:
                    errors.append("decision participants mismatch")
                for person_id in participants:
                    var person_entry: Variant = world.get("entry_permissions", {}).get(person_id, null)
                    if not person_entry is Dictionary or person_entry.get("status", "") != result.get("status", "") or person_entry.get("case_id", "") != case_id:
                        errors.append("party entry outcome mismatch")
    if gate.get("complete", false):
        if not gate.get("asked", []).is_empty() or not gate.get("verified", []).is_empty():
            errors.append("completed gate has pending inquiries")
        if world.get("calendar", {}).get("phase", "") == "daytime" and int(gate.get("shift_day", -1)) == int(world.get("calendar", {}).get("day_index", -1)):
            errors.append("completed gate remained in daytime")
        if gate.get("skipped", []) is Array:
            var actual_skipped: Array = []
            for pending in range(cursor, queue.size()):
                if queue[pending] is Dictionary:
                    actual_skipped.append(str(queue[pending].get("case_id", "")))
            if gate["skipped"] != actual_skipped:
                errors.append("skipped queue mismatch")
    return errors

static func _whole(value: Variant) -> bool:
    return (value is int and value >= -1) or (value is float and is_finite(value) and value >= -1 and value == floorf(value))
