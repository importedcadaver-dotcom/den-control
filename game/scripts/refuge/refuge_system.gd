extends RefCounted
## P5 public refuge operations. QA people and all prices are provisional test data.
## Gate entry, refuge placement and guardianship remain independent.

const QA_SHIFT_SECONDS := 1200
const QA_CAPACITY := 3
const QA_COSTS := {"food": 5, "medicine": 8, "blankets": 4, "bed": 15}
const ACTIONS := ["feed", "comfort", "rest", "treat"]

static func initial_state() -> Dictionary:
    return {"started": false, "complete": false, "shift_day": -1,
        "capacity": QA_CAPACITY, "bed_count": 1, "residents": {},
        "supplies": {"food": 0, "medicine": 0, "blankets": 0},
        "care_log": [], "history": [], "qa_only": true,
        "last_feedback": "Training facility, not an approved Honeyhold budget or resident list."}

static func eligible(world: RefCounted) -> Array:
    var choices: Array = []
    for subject in world.state["entry_permissions"].keys():
        var entry: Dictionary = world.state["entry_permissions"][subject]
        var person: Dictionary = world.state["characters"].get(subject, {})
        if entry.get("status", "") == "authorized" and person.get("qa_fixture", false) == true and person.get("registered_case_id", "") == entry.get("case_id", "") and not world.state["refuge_placements"].get(subject, {}).get("status", "") == "placed":
            choices.append({"subject_id": subject, "case_id": entry["case_id"]})
    choices.sort_custom(func(a, b): return str(a["subject_id"]) < str(b["subject_id"]))
    return choices

static func begin(world: RefCounted) -> bool:
    var r: Dictionary = world.state["refuge"]
    var day: int = int(world.state["calendar"]["day_index"])
    if world.current_duty() != "refuge" or not ["morning", "daytime"].has(world.state["calendar"]["phase"]):
        return world._fail("Not a scheduled refuge shift")
    if r["started"] and (not r["complete"] or int(r["shift_day"]) >= day):
        return world._fail("Refuge shift already started today")
    # Preflight before mutating permanent legal or financial records.
    var snapshot: Dictionary = world.snapshot()
    if r["started"]:
        var old: Dictionary = r.duplicate(true)
        old.erase("history")
        r["history"].append(old)
    r["started"] = true
    r["complete"] = false
    r["shift_day"] = day
    r["last_feedback"] = "Briarwood QA operations: care and supply costs are provisional."
    if world.state["calendar"]["phase"] == "morning":
        world.change_phase("daytime")
    if world.state["shift_clock"]["duration_seconds"] == null:
        if not world.configure_shift_duration(QA_SHIFT_SECONDS):
            world.state = snapshot
            return false
    if not world.start_shift():
        var reason: String = world.last_error
        world.state = snapshot
        return world._fail(reason)
    world._record("refuge.shift_open", "", {"day_index": day, "qa_only": true})
    if not world.validate_state(world.snapshot()).is_empty():
        world.state = snapshot
        return world._fail("Refuge initialization failed validation")
    return true

static func admit(world: RefCounted, subject: String, case_id: String) -> bool:
    var r: Dictionary = world.state["refuge"]
    if not r["started"] or r["complete"] or world.current_duty() != "refuge" or world.state["calendar"]["phase"] != "daytime":
        return world._fail("No active refuge shift")
    var person: Dictionary = world.state["characters"].get(subject, {})
    var entry: Dictionary = world.state["entry_permissions"].get(subject, {})
    if not world.state["qa_mode"] or person.get("qa_fixture", false) != true:
        return world._fail("Training residents require explicit QA provenance")
    if person.get("registered_case_id", "") != case_id or entry.get("case_id", "") != case_id or entry.get("status", "") != "authorized":
        return world._fail("A matching authorized applicant case is required")
    if not world.state["case_records"].has(case_id) or r["residents"].has(subject):
        return world._fail("No matching case or resident already placed")
    if r["residents"].size() >= int(r["bed_count"]) or r["residents"].size() >= int(r["capacity"]):
        return world._fail("No spare refuge bed; buy a bed using public funds")
    if not world.place_in_refuge(subject, case_id):
        return false
    var bed: int = r["residents"].size() + 1
    r["residents"][subject] = {"id": subject, "case_id": case_id, "bed": bed,
        "hunger": 48, "energy": 55, "comfort": 46, "health": 90,
        "intent": "settling", "x": 0.15 + float(bed) * 0.2, "care_count": 0}
    world._record("refuge.admitted", subject, {"case_id": case_id, "bed": bed, "qa_only": true})
    world.last_error = ""
    return true

static func _active_operations(world: RefCounted) -> bool:
    var r: Dictionary = world.state["refuge"]
    var calendar: Dictionary = world.state["calendar"]
    return bool(r["started"]) and not bool(r["complete"]) and int(r["shift_day"]) == int(calendar["day_index"]) and calendar["phase"] == "daytime" and world.current_duty() == "refuge" and bool(world.state["shift_clock"]["running"])

static func purchase(world: RefCounted, item: String) -> bool:
    var r: Dictionary = world.state["refuge"]
    if not _active_operations(world) or not QA_COSTS.has(item):
        return world._fail("Cannot purchase outside active refuge operations")
    if item == "bed" and int(r["bed_count"]) >= int(r["capacity"]):
        return world._fail("At QA bed capacity")
    if not world.post_hm("refuge", -int(QA_COSTS[item]), "QA refuge purchase: " + item):
        return false
    if item == "bed":
        r["bed_count"] = int(r["bed_count"]) + 1
    else:
        r["supplies"][item] = int(r["supplies"][item]) + (3 if item == "food" else 2)
    world._record("refuge.purchase", "", {"item": item, "hm": QA_COSTS[item], "qa_only": true})
    world.last_error = ""
    return true

static func care(world: RefCounted, subject: String, action: String) -> bool:
    var r: Dictionary = world.state["refuge"]
    if not _active_operations(world) or not r["residents"].has(subject) or not ACTIONS.has(action):
        return world._fail("Invalid resident care action")
    var resident: Dictionary = r["residents"][subject]
    match action:
        "feed":
            if int(r["supplies"]["food"]) < 1:
                return world._fail("No food stock; cannot provide free meals")
            r["supplies"]["food"] = int(r["supplies"]["food"]) - 1
            resident["hunger"] = maxi(0, int(resident["hunger"]) - 28)
            resident["intent"] = "eating"
        "comfort":
            resident["comfort"] = mini(100, int(resident["comfort"]) + 12)
            resident["intent"] = "comforted"
        "rest":
            resident["energy"] = mini(100, int(resident["energy"]) + 17)
            resident["intent"] = "resting"
        "treat":
            if int(r["supplies"]["medicine"]) < 1 or int(resident["health"]) >= 100:
                return world._fail("Medicine unavailable or not needed")
            r["supplies"]["medicine"] = int(r["supplies"]["medicine"]) - 1
            resident["health"] = mini(100, int(resident["health"]) + 10)
            resident["intent"] = "treated"
    resident["care_count"] = int(resident["care_count"]) + 1
    r["care_log"].append({"subject_id": subject, "action": action, "day": world.state["calendar"]["day_index"]})
    world._record("refuge.care", subject, {"action": action, "qa_only": true})
    world.last_error = ""
    return true

static func tick(world: RefCounted, steps: int = 1) -> bool:
    var r: Dictionary = world.state["refuge"]
    if not _active_operations(world) or steps < 1 or steps > 32:
        return world._fail("Cannot advance refuge residents")
    for step in range(steps):
        for subject in r["residents"].keys():
            var person: Dictionary = r["residents"][subject]
            person["hunger"] = mini(100, int(person["hunger"]) + 1)
            person["energy"] = maxi(0, int(person["energy"]) - 1)
            person["comfort"] = maxi(0, int(person["comfort"]) - 1)
            if int(person["hunger"]) > 75:
                person["intent"] = "seeking_food"
            elif int(person["energy"]) < 28:
                person["intent"] = "sleeping"
                person["energy"] = mini(100, int(person["energy"]) + 5)
            else:
                person["intent"] = "exploring"
                person["x"] = clampf(float(person["x"]) + 0.015, 0.1, 0.85)
    return true

static func finish(world: RefCounted) -> bool:
    var r: Dictionary = world.state["refuge"]
    if not r["started"] or r["complete"]:
        return world._fail("No active refuge shift")
    r["complete"] = true
    world.state["shift_clock"]["running"] = false
    world._record("refuge.shift_complete", "", {"day_index": r["shift_day"], "residents": r["residents"].size()})
    if world.state["calendar"]["phase"] == "daytime":
        world.change_phase("evening")
    world.last_error = ""
    return true

static func validate(value: Variant, world: Dictionary) -> Array[String]:
    var errors: Array[String] = []
    if not value is Dictionary:
        return ["missing refuge state"]
    var r: Dictionary = value
    if not r.get("started", null) is bool or not r.get("complete", null) is bool or r.get("qa_only", null) != true:
        errors.append("invalid refuge flags")
    if not _whole(r.get("capacity", null)) or not _whole(r.get("bed_count", null)) or int(r.get("capacity", -1)) != QA_CAPACITY or int(r.get("bed_count", -1)) < 1 or int(r.get("bed_count", -1)) > QA_CAPACITY:
        errors.append("invalid refuge bed capacity")
    if not r.get("residents", null) is Dictionary or not r.get("supplies", null) is Dictionary or not r.get("care_log", null) is Array:
        errors.append("missing refuge tables")
        return errors
    if not r.get("history", null) is Array:
        errors.append("invalid refuge archive")
        return errors
    if not r.get("last_feedback", null) is String or not _whole(r.get("shift_day", null), true):
        errors.append("invalid refuge shift metadata")
    for key in ["food", "medicine", "blankets"]:
        if not _whole(r["supplies"].get(key, null)):
            errors.append("invalid supply count")
    if r["residents"].size() > int(r["bed_count"]) or r["residents"].size() > QA_CAPACITY:
        errors.append("over-capacity refuge")
    var used_beds: Dictionary = {}
    for subject in r["residents"].keys():
        var patient: Variant = r["residents"][subject]
        var entry: Dictionary = world.get("entry_permissions", {}).get(subject, {})
        var place: Dictionary = world.get("refuge_placements", {}).get(subject, {})
        var identity: Dictionary = world.get("characters", {}).get(subject, {})
        if not patient is Dictionary:
            errors.append("malformed resident")
            continue
        if identity.get("qa_fixture", false) != true or patient.get("id", "") != subject:
            errors.append("non-QA or mismatched identity")
        if entry.get("status", "") != "authorized" or entry.get("case_id", "") != patient.get("case_id", "") or identity.get("registered_case_id", "") != patient.get("case_id", ""):
            errors.append("resident entry/case mismatch")
        if place.get("status", "") != "placed" or place.get("case_id", "") != patient.get("case_id", ""):
            errors.append("resident placement mismatch")
        var bed: Variant = patient.get("bed", null)
        if not _whole(bed) or int(bed) < 1 or int(bed) > int(r["bed_count"]) or used_beds.has(bed):
            errors.append("resident bed collision")
        used_beds[bed] = true
        for field in ["hunger", "energy", "comfort", "health"]:
            if not _whole(patient.get(field, null)) or int(patient.get(field, 0)) > 100:
                errors.append("invalid resident need")
        if not patient.get("intent", null) is String or not _whole(patient.get("care_count", null)):
            errors.append("invalid resident activity")
        if not (patient.get("x", null) is float or patient.get("x", null) is int) or not is_finite(float(patient.get("x", -1))) or float(patient.get("x", -1)) < 0.0 or float(patient.get("x", -1)) > 1.0:
            errors.append("invalid resident position")
    for action in r["care_log"]:
        if not action is Dictionary or not r["residents"].has(action.get("subject_id", "")) or not ACTIONS.has(action.get("action", "")):
            errors.append("invalid care record")
    if r["started"] and (int(r["shift_day"]) < 0 or int(r["shift_day"]) > int(world.get("calendar", {}).get("day_index", -1))):
        errors.append("invalid refuge day")
    if not r["started"] and (r["complete"] or not r["residents"].is_empty()):
        errors.append("unopened refuge has residents")
    return errors

static func _whole(value: Variant, allow_negative_one: bool = false) -> bool:
    if not (value is int or value is float) or not is_finite(float(value)) or float(value) != floorf(float(value)):
        return false
    return int(value) >= (-1 if allow_negative_one else 0)
