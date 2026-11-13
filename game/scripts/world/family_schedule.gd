extends RefCounted
## P6 QA-only scheduling abstraction. No teachers, abuse events, or story invented.
## This schedules approved half-day preschool followed by Grandma's usual care.
## A QA half-shift threshold is NOT an approved real-world school timetable.
const MAMA = "uc.family.mama"
const GRANDMA = "uc.family.grandma"
const CHILDREN = ["uc.family.button", "uc.family.hazel"]
const QA_HALF_SHIFT_SECONDS := 600.0
const WINDOWS = ["mama_home", "preschool", "grandma_after_preschool", "unverified"]
const SCHOOL_STATES = ["not_started", "attending", "window_elapsed", "unverified"]
const MAX_HISTORY := 128

static func initial_state() -> Dictionary:
    return {"day_index": 0, "window": "mama_home", "caregiver_id": MAMA,
        "school_status": "not_started", "work_start_seconds": null,
        "children": CHILDREN.duplicate(), "history": [], "qa_timing": true}

static func _change(world: RefCounted, window: String, provider: String, school: String) -> void:
    var routine: Dictionary = world.state["family_schedule"]
    if routine["window"] == window and routine["caregiver_id"] == provider and routine["school_status"] == school:
        return
    routine["window"] = window
    routine["caregiver_id"] = provider
    routine["school_status"] = school
    var record := {"day_index": int(world.state["calendar"]["day_index"]),
        "window": window, "caregiver_id": provider, "school_status": school}
    routine["history"].append(record.duplicate(true))
    while routine["history"].size() > MAX_HISTORY:
        routine["history"].pop_front()
    world._record("family.scheduled_care", "", record)

static func begin_shift(world: RefCounted) -> void:
    var routine: Dictionary = world.state["family_schedule"]
    routine["day_index"] = int(world.state["calendar"]["day_index"])
    routine["work_start_seconds"] = float(world.state["world_time"]["elapsed_seconds"])
    # A named teacher, verified school attendance and Grandma incidents are NOT fabricated.
    _change(world, "preschool", "", "attending")

static func advance(world: RefCounted) -> void:
    var routine: Dictionary = world.state["family_schedule"]
    if routine["window"] != "preschool":
        return
    var started: Variant = routine.get("work_start_seconds", null)
    if started == null:
        return
    var elapsed: float = float(world.state["world_time"]["elapsed_seconds"]) - float(started)
    if elapsed >= QA_HALF_SHIFT_SECONDS:
        _change(world, "grandma_after_preschool", GRANDMA, "window_elapsed")

static func finish_shift(world: RefCounted) -> void:
    var routine: Dictionary = world.state["family_schedule"]
    var school: String = "unverified" if routine["window"] in ["preschool", "unverified"] else str(routine["school_status"])
    routine["work_start_seconds"] = null
    _change(world, "mama_home", MAMA, school)

static func next_day(world: RefCounted) -> void:
    var routine: Dictionary = world.state["family_schedule"]
    routine["day_index"] = int(world.state["calendar"]["day_index"])
    routine["work_start_seconds"] = null
    _change(world, "mama_home", MAMA, "not_started")

static func upgrade_v6(legacy: Dictionary) -> Dictionary:
    var upgraded: Dictionary = legacy.duplicate(true)
    if upgraded.get("schema_version", -1) != 6:
        return {}
    upgraded["schema_version"] = 7
    var routine: Dictionary = initial_state()
    var calendar: Variant = upgraded.get("calendar", {})
    if not calendar is Dictionary:
        return {}
    routine["day_index"] = int(calendar.get("day_index", -1))
    if calendar.get("phase", "") == "daytime":
        # Older save has no attendance evidence: do not forge attendance or caregiver.
        routine["window"] = "unverified"
        routine["caregiver_id"] = ""
        routine["school_status"] = "unverified"
    elif calendar.get("phase", "") == "evening":
        routine["school_status"] = "unverified"
    upgraded["family_schedule"] = routine
    return upgraded

static func validate(value: Variant, world: Dictionary) -> Array[String]:
    var errors: Array[String] = []
    if not value is Dictionary:
        return ["family schedule missing"]
    var routine: Dictionary = value
    var calendar: Variant = world.get("calendar", {})
    if not calendar is Dictionary:
        return ["family schedule without calendar"]
    var day: Variant = routine.get("day_index", null)
    if not _integer(day) or int(day) != int(calendar.get("day_index", -1)):
        errors.append("family schedule day mismatch")
    var window: String = str(routine.get("window", ""))
    var provider: String = str(routine.get("caregiver_id", ""))
    if not WINDOWS.has(window) or not SCHOOL_STATES.has(routine.get("school_status", "")):
        errors.append("invalid family schedule window")
    if window == "mama_home" and provider != MAMA:
        errors.append("Mama-at-home provider mismatch")
    if window == "grandma_after_preschool" and (provider != GRANDMA or routine.get("school_status", "") != "window_elapsed"):
        errors.append("Grandma coverage mismatch")
    if window in ["preschool", "unverified"] and provider != "":
        errors.append("unapproved preschool caregiver")
    if window == "preschool" and routine.get("school_status", "") != "attending":
        errors.append("invalid preschool attendance state")
    if window in ["preschool", "grandma_after_preschool"] and calendar.get("phase", "") != "daytime":
        errors.append("school supervision outside daytime")
    if calendar.get("phase", "") in ["morning", "evening"] and window != "mama_home":
        errors.append("family not at home outside work shift")
    var start: Variant = routine.get("work_start_seconds", null)
    if window in ["preschool", "grandma_after_preschool"] and start == null:
        errors.append("work clock origin absent")
    if start != null and (not (start is float or start is int) or not is_finite(float(start)) or float(start) < 0.0):
        errors.append("invalid family work clock")
    if routine.get("children", null) != CHILDREN or routine.get("qa_timing", null) != true:
        errors.append("invalid family schedule identities/provenance")
    var history: Variant = routine.get("history", null)
    if not history is Array or history.size() > MAX_HISTORY:
        errors.append("invalid family schedule history")
    else:
        for item in history:
            if not item is Dictionary or not WINDOWS.has(item.get("window", "")) or not SCHOOL_STATES.has(item.get("school_status", "")) or not _integer(item.get("day_index", null)) or int(item.get("day_index", 0)) > int(calendar.get("day_index", -1)):
                errors.append("malformed family schedule transition")
    return errors

static func _integer(value: Variant) -> bool:
    return (value is int or (value is float and is_finite(value) and value == floorf(value))) and int(value) >= 0
