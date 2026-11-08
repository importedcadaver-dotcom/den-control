extends Control
## P2 world foundation status screen. Not a playable game or P3 home simulation.
const WorldState = preload("res://scripts/world/world_state.gd")

func _ready() -> void:
    var world = WorldState.new()
    var problems: Array[String] = WorldState.validate_state(world.snapshot())
    var panel := VBoxContainer.new()
    panel.position = Vector2(56, 60)
    panel.custom_minimum_size = Vector2(850, 420)
    panel.add_theme_constant_override("separation", 16)
    add_child(panel)
    var title := Label.new()
    title.text = "UNBEARABLE CONDITIONS"
    title.add_theme_font_size_override("font_size", 34)
    panel.add_child(title)
    var subtitle := Label.new()
    subtitle.text = "P2 — PERSISTENT WORLD FOUNDATION (NOT PLAYABLE YET)"
    subtitle.add_theme_font_size_override("font_size", 20)
    panel.add_child(subtitle)
    var state_label := Label.new()
    state_label.text = "World state valid. First scheduled duty: %s. HM balances remain unconfigured." % world.current_duty() if problems.is_empty() else "WORLD STATE ERROR: " + "; ".join(problems)
    state_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    panel.add_child(state_label)
    var note := Label.new()
    note.text = "Exactly five approved individuals. No old Button/Hazel imports.
Run headless P1 and P2 tests before enabling gameplay."
    panel.add_child(note)
