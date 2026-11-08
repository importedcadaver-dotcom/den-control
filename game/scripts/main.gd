extends Control
## P1 development shell. This is NOT the first playable milestone.
const CanonLoader = preload("res://scripts/foundation/canon_loader.gd")

func _ready() -> void:
    var records: Dictionary = CanonLoader.load_characters()
    var problems: Array[String] = CanonLoader.validate_characters(records)
    var panel := VBoxContainer.new()
    panel.position = Vector2(64, 68)
    panel.custom_minimum_size = Vector2(820, 380)
    panel.add_theme_constant_override("separation", 18)
    add_child(panel)
    var title := Label.new()
    title.text = "UNBEARABLE CONDITIONS"
    title.add_theme_font_size_override("font_size", 34)
    panel.add_child(title)
    var message := Label.new()
    message.text = "P1 FOUNDATION ONLY — NOT A PLAYABLE BUILD"
    message.add_theme_font_size_override("font_size", 20)
    panel.add_child(message)
    var state := Label.new()
    if problems.is_empty():
        state.text = "Canonical character records validated. Next: P2 world persistence."
    else:
        state.text = "CANON VALIDATION FAILED: " + ", ".join(problems)
    state.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    panel.add_child(state)
    var note := Label.new()
    note.text = "Legacy Button and Hazel never load here. No placeholder named NPCs."
    panel.add_child(note)
