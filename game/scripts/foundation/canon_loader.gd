extends RefCounted
## P1 data contracts. Gameplay and persistence belong in P2.

const CAST_PATH = "res://data/canon/characters.json"
const SCHEDULE_PATH = "res://data/canon/work_schedule.json"
const EXPECTED_IDS = ["uc.family.mama", "uc.family.button", "uc.family.hazel", "uc.family.grandma", "uc.royal.ursula"]
const FORBIDDEN_SOURCE_IDS = ["button", "hazel"]

static func load_document(path: String) -> Variant:
    if not FileAccess.file_exists(path):
        return null
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return null
    return JSON.parse_string(file.get_as_text())

static func load_characters() -> Dictionary:
    var parsed: Variant = load_document(CAST_PATH)
    if parsed is Dictionary:
        return parsed
    return {}

static func load_schedule() -> Dictionary:
    var parsed: Variant = load_document(SCHEDULE_PATH)
    if parsed is Dictionary:
        return parsed
    return {}

static func validate_characters(document: Dictionary) -> Array[String]:
    var errors: Array[String] = []
    if int(document.get("schema_version", -1)) != 1:
        errors.append("bad schema version")
    var records: Variant = document.get("characters", null)
    if not records is Array:
        errors.append("characters is not an array")
        return errors
    var seen: Dictionary = {}
    for record in records:
        if not record is Dictionary:
            errors.append("record is not a dictionary")
            continue
        var record_id := str(record.get("id", ""))
        if seen.has(record_id):
            errors.append("duplicate stable ID")
        seen[record_id] = true
        if not record_id.begins_with("uc.") or record_id in FORBIDDEN_SOURCE_IDS:
            errors.append("legacy or unscoped ID")
    for expected in EXPECTED_IDS:
        if not seen.has(expected):
            errors.append("missing approved ID " + expected)
    if seen.size() != EXPECTED_IDS.size():
        errors.append("unapproved additional characters")
    return errors

static func validate_schedule(document: Dictionary) -> Array[String]:
    var errors: Array[String] = []
    if int(document.get("schema_version", -1)) != 1:
        errors.append("bad schedule version")
    var expected := ["gate", "refuge", "gate", "refuge", "gate", "refuge", "off"]
    if document.get("work_rotation", []) != expected:
        errors.append("incorrect approved seven-day rotation")
    return errors
