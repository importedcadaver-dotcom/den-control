extends RefCounted
## P2 versioned save files. Validation occurs before mutating an active session.
const WorldState = preload("res://scripts/world/world_state.gd")

static func load_document(path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        return {"ok": false, "error": "save not found"}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {"ok": false, "error": "save could not be opened"}
    var parser := JSON.new()
    if parser.parse(file.get_as_text()) != OK:
        return {"ok": false, "error": "invalid JSON document"}
    var parsed: Variant = parser.data
    if not parsed is Dictionary:
        return {"ok": false, "error": "invalid JSON object"}
    if parsed.get("schema_version", -1) == 6:
        parsed = WorldState.upgrade_dev_v6(parsed)
        if parsed.is_empty():
            return {"ok": false, "error": "developer save upgrade failed"}
    var problems: Array[String] = WorldState.validate_state(parsed)
    if not problems.is_empty():
        return {"ok": false, "error": "; ".join(problems)}
    return {"ok": true, "state": parsed.duplicate(true)}

static func save_document(path: String, snapshot: Dictionary) -> Dictionary:
    var problems: Array[String] = WorldState.validate_state(snapshot)
    if not problems.is_empty():
        return {"ok": false, "error": "invalid new state: " + "; ".join(problems)}
    if FileAccess.file_exists(path):
        var old: Dictionary = load_document(path)
        if not bool(old.get("ok", false)):
            return {"ok": false, "error": "existing save invalid; refusing overwrite"}
    var temp_path := path + ".tmp"
    var stream := FileAccess.open(temp_path, FileAccess.WRITE)
    if stream == null:
        return {"ok": false, "error": "unable to open temporary file"}
    stream.store_string(JSON.stringify(snapshot, "  ", true))
    stream.flush()
    stream.close()
    var check: Dictionary = load_document(temp_path)
    if not bool(check.get("ok", false)):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(temp_path))
        return {"ok": false, "error": "temporary save verification failed"}
    var absolute_target: String = ProjectSettings.globalize_path(path)
    if FileAccess.file_exists(path):
        var copied: Error = DirAccess.copy_absolute(absolute_target, ProjectSettings.globalize_path(path + ".bak"))
        if copied != OK:
            DirAccess.remove_absolute(ProjectSettings.globalize_path(temp_path))
            return {"ok": false, "error": "backup failed"}
    var renamed: Error = DirAccess.rename_absolute(ProjectSettings.globalize_path(temp_path), absolute_target)
    if renamed != OK:
        DirAccess.remove_absolute(ProjectSettings.globalize_path(temp_path))
        return {"ok": false, "error": "atomic save replacement failed"}
    return {"ok": true, "path": path}

static func load_into(path: String, active_world: RefCounted) -> Dictionary:
    var loaded: Dictionary = load_document(path)
    if not bool(loaded.get("ok", false)):
        return loaded
    if not active_world.restore_validated(loaded["state"]):
        return {"ok": false, "error": "loaded state rejected"}
    return {"ok": true}
