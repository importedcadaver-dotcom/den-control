extends SceneTree
## Run with Godot: godot --headless --path game --script res://tests/test_p1.gd
const CanonLoader = preload("res://scripts/foundation/canon_loader.gd")
var checks: int = 0
var failures: Array[String] = []

func check(condition: bool, description: String) -> void:
    checks += 1
    if not condition:
        failures.append(description)
        push_error(description)

func _initialize() -> void:
    var canonical: Dictionary = CanonLoader.load_characters()
    check(CanonLoader.validate_characters(canonical).is_empty(), "canonical character contract validates")
    var ids: Dictionary = {}
    for character in canonical.get("characters", []):
        ids[str(character.get("id", ""))] = character
    check(not ids.has("button") and not ids.has("hazel"), "legacy IDs are absent")
    check(ids.has("uc.family.button") and ids.has("uc.family.hazel"), "new sibling IDs exist")
    if ids.has("uc.family.button") and ids.has("uc.family.hazel"):
        check(ids["uc.family.button"].get("littermate_id") == "uc.family.hazel", "Button links to Hazel")
        check(ids["uc.family.hazel"].get("littermate_id") == "uc.family.button", "Hazel links to Button")
    var schedule: Dictionary = CanonLoader.load_schedule()
    check(CanonLoader.validate_schedule(schedule).is_empty(), "approved rotation validates")
    check(canonical.get("characters", []).size() == 5, "no unapproved named characters")
    print("P1 Godot checks: ", checks, " failures: ", failures.size())
    quit(0 if failures.is_empty() else 1)
