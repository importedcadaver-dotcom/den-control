extends Control
## P4 inspection workbench. Anonymous QA applicants and provisional rules only.
## UI never owns legal decisions; all actions go through the persistent WorldState.
signal request_home
const GateSystem = preload("res://scripts/gate/gate_system.gd")
const SaveStore = preload("res://scripts/world/save_store.gd")
const SAVE_PATH := "user://uc_p4_dev.json"
const PAPER := Color("e8d8b4")
const INK := Color("302f34")
const GOLD := Color("cda46f")
const STONE := Color("4a545c")

var world: RefCounted
var clock_timer: Timer
var case_label: Label
var clock_label: Label
var document_label: RichTextLabel
var message_label: Label
var feedback_label: RichTextLabel
var decision_reason: OptionButton
var decision_buttons: Array[Button] = []
var inspect_buttons: Array[Button] = []
var early_button: Button
var return_button: Button
var timer_button: Button
var last_message: String = "Open a document and compare it with the QA rulebook. No per-visitor deadline."

func setup(world_ref: RefCounted) -> void:
    world = world_ref

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _build_ui()
    clock_timer = Timer.new()
    clock_timer.wait_time = 1.0
    clock_timer.timeout.connect(_tick)
    add_child(clock_timer)
    clock_timer.start()
    _refresh()

func _make_label(parent: Node, value: String, font_size: int = 13, wrap: bool = false) -> Label:
    var label := Label.new()
    label.text = value
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", Color("f0dfbe"))
    if wrap:
        label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    parent.add_child(label)
    return label

func _action(parent: Node, text_value: String, handler: Callable) -> Button:
    var button := Button.new()
    button.text = text_value
    button.custom_minimum_size = Vector2(112, 31)
    button.add_theme_font_size_override("font_size", 12)
    parent.add_child(button)
    button.pressed.connect(handler)
    return button

func _build_ui() -> void:
    var main_title := Label.new()
    main_title.text = "UNBEARABLE CONDITIONS  /  GATE INSPECTION"
    main_title.position = Vector2(22, 10)
    main_title.add_theme_font_size_override("font_size", 22)
    main_title.add_theme_color_override("font_color", Color("f4d6ac"))
    add_child(main_title)
    var notice := Label.new()
    notice.text = "P6 QA TRAINING CASES  •  ANONYMOUS FIXTURES  •  NOT FINAL CANON"
    notice.position = Vector2(23, 43)
    notice.add_theme_font_size_override("font_size", 11)
    notice.add_theme_color_override("font_color", Color("f7be9a"))
    add_child(notice)
    # RichTextLabel confines long laws and case notes to the physical paper area.
    document_label = RichTextLabel.new()
    document_label.position = Vector2(260, 123)
    document_label.size = Vector2(359, 276)
    document_label.bbcode_enabled = false
    document_label.fit_content = false
    document_label.scroll_active = true
    document_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    document_label.add_theme_color_override("default_color", INK)
    document_label.add_theme_font_size_override("normal_font_size", 16)
    add_child(document_label)
    message_label = Label.new()
    message_label.position = Vector2(22, 465)
    message_label.size = Vector2(632, 60)
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    message_label.add_theme_color_override("font_color", Color("f4d8ae"))
    message_label.add_theme_font_size_override("font_size", 13)
    add_child(message_label)
    var sidebar := PanelContainer.new()
    sidebar.position = Vector2(668, 0)
    sidebar.custom_minimum_size = Vector2(292, 540)
    sidebar.size = Vector2(292, 540)
    var style := StyleBoxFlat.new()
    style.bg_color = Color("292c32")
    style.border_color = Color("9e7862")
    style.border_width_left = 3
    sidebar.add_theme_stylebox_override("panel", style)
    add_child(sidebar)
    var scroll := ScrollContainer.new()
    scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    scroll.offset_bottom = -124  # Pin entry decisions; do not bury them below scroll.
    sidebar.add_child(scroll)
    var stack := VBoxContainer.new()
    stack.custom_minimum_size = Vector2(271, 800)
    stack.add_theme_constant_override("separation", 7)
    scroll.add_child(stack)
    _make_label(stack, "GATE DESK  ·  DAY 1", 21)
    case_label = _make_label(stack, "", 14, true)
    clock_label = _make_label(stack, "", 13)
    _make_label(stack, "INSPECT DOCUMENTS", 15)
    var pages := GridContainer.new()
    pages.columns = 2
    stack.add_child(pages)
    for option in [["Entry pass", "pass"], ["Identity", "identification"], ["Guardian", "guardian"], ["QA rules", "rules"], ["Close papers", "summary"]]:
        var btn := _action(pages, option[0], _inspect.bind(option[1]))
        inspect_buttons.append(btn)
    _make_label(stack, "QUESTION / VERIFY", 15)
    var inquiries := GridContainer.new()
    inquiries.columns = 2
    stack.add_child(inquiries)
    _action(inquiries, "Ask purpose", _ask.bind("purpose"))
    _action(inquiries, "Ask papers", _ask.bind("papers"))
    _action(inquiries, "Call registry", _verify.bind("registry"))
    _action(inquiries, "Check guardian", _verify.bind("guardian"))
    # A bounded scrollable response prevents long registry replies clipping the window.
    feedback_label = RichTextLabel.new()
    feedback_label.custom_minimum_size = Vector2(260, 68)
    feedback_label.fit_content = false
    feedback_label.scroll_active = true
    feedback_label.bbcode_enabled = false
    feedback_label.add_theme_color_override("default_color", Color("f0dfbe"))
    feedback_label.add_theme_font_size_override("normal_font_size", 12)
    stack.add_child(feedback_label)
    _make_label(stack, "SHIFT / SAVE", 15)
    var controls := GridContainer.new()
    controls.columns = 2
    stack.add_child(controls)
    timer_button = _action(controls, "Timer ON", _toggle_timer)
    _action(controls, "Save state", _save)
    _action(controls, "Load state", _load)
    early_button = _action(controls, "End early", _end_early)
    return_button = _action(stack, "Return to Mama's den", _go_home)
    var foot := _make_label(stack, "Training only; verdicts persist. No wages or named visitors are fabricated.", 11, true)
    foot.add_theme_color_override("font_color", Color("bfb0a4"))
    # Fixed bottom strip is always visible, including at 960x540.
    var decision_panel := PanelContainer.new()
    decision_panel.position = Vector2(670, 416)
    decision_panel.size = Vector2(288, 122)
    var pinned_style := StyleBoxFlat.new()
    pinned_style.bg_color = Color("34363b")
    pinned_style.border_color = Color("a68668")
    pinned_style.border_width_top = 2
    decision_panel.add_theme_stylebox_override("panel", pinned_style)
    add_child(decision_panel)
    var pinned := VBoxContainer.new()
    pinned.custom_minimum_size = Vector2(282, 116)
    pinned.add_theme_constant_override("separation", 3)
    decision_panel.add_child(pinned)
    _make_label(pinned, "ENTRY DECISION + REASON (NOT REFUGE)", 11)
    decision_reason = OptionButton.new()
    decision_reason.custom_minimum_size = Vector2(274, 28)
    pinned.add_child(decision_reason)
    var fixture: Dictionary = GateSystem.read_fixture()
    for entry in fixture.get("reasons", []):
        decision_reason.add_item(str(entry.get("label", "Unknown reason")))
        decision_reason.set_item_metadata(decision_reason.item_count - 1, str(entry.get("code", "")))
    var decisions := HBoxContainer.new()
    decisions.add_theme_constant_override("separation", 4)
    pinned.add_child(decisions)
    for pair in [["AUTHORIZE", "authorized"], ["HOLD", "held"], ["DENY", "denied"]]:
        var decision_button := _action(decisions, pair[0], _decide.bind(pair[1]))
        decision_button.custom_minimum_size = Vector2(87, 30)
        decision_buttons.append(decision_button)

func _ticket() -> Dictionary:
    return GateSystem.current(world)

func _inspect(mode: String) -> void:
    if not world.show_gate_document(mode):
        last_message = world.last_error
    else:
        last_message = "Document closed. Shift clock resumed." if mode == "summary" else "Reading " + mode.replace("_", " ") + ". Shift clock paused."
    _refresh()

func _ask(question: String) -> void:
    last_message = "Question recorded." if world.ask_gate(question) else world.last_error
    _refresh()

func _verify(source: String) -> void:
    last_message = "Verification returned." if world.verify_gate(source) else world.last_error
    _refresh()

func _decide(status: String) -> void:
    if decision_reason.item_count == 0:
        last_message = "No available reason; QA fixtures failed to load."
        return
    var reason: String = str(decision_reason.get_item_metadata(decision_reason.selected))
    if not world.decide_gate(status, reason):
        last_message = "Decision rejected: " + world.last_error
    else:
        last_message = "Recorded " + status.to_upper() + " with reason: " + reason.replace("_", " ") + "."
    _refresh()

func _toggle_timer() -> void:
    var enabled: bool = not bool(world.state["shift_clock"]["enabled"])
    world.set_shift_timer_enabled(enabled)
    last_message = "Shift timer " + ("enabled" if enabled else "disabled") + " in Settings."
    _refresh()

func _end_early() -> void:
    last_message = "Shift closed with unfinished arrivals recorded." if world.finish_gate(true) else world.last_error
    _refresh()

func _go_home() -> void:
    if world.state["gate"]["complete"]:
        request_home.emit()
    else:
        last_message = "Finish the gate shift before returning. Pending applicants will otherwise be left unprocessed."
        _refresh()

func _save() -> void:
    var result: Dictionary = SaveStore.save_document(SAVE_PATH, world.snapshot())
    last_message = "World saved: home, cases, legal outcomes and shift state." if result.get("ok", false) else "Save failed: " + str(result.get("error", ""))
    _refresh()

func _load() -> void:
    var result: Dictionary = SaveStore.load_into(SAVE_PATH, world)
    last_message = "World loaded: all decisions restored." if result.get("ok", false) else "Load failed: " + str(result.get("error", ""))
    _refresh()

func _tick() -> void:
    if world == null or not bool(world.state["gate"]["started"]) or bool(world.state["gate"]["complete"]):
        return
    var was_running: bool = bool(world.state["shift_clock"]["running"])
    world.tick_shift(1.0)
    if was_running and not bool(world.state["shift_clock"]["running"]) and bool(world.state["shift_clock"]["enabled"]):
        world.finish_gate(true)
        last_message = "Shift clock expired. Remaining anonymous QA cases were marked unprocessed."
    _refresh()

func _document(ticket: Dictionary, mode: String) -> String:
    if ticket.is_empty():
        return "SHIFT FINISHED\n\nAll processed cases remain in the legal record.\n\nReturn home, save or inspect the summary."
    match mode:
        "pass":
            return "TEMPORARY ENTRY PASS\n\nPass ID: %s\nPrinted name: %s\nValid through test day: %d\nPurpose: %s\n\nQA pass format. Compare to ID and rulebook." % [ticket["pass_id"], ticket["pass_name"], int(ticket["pass_valid_until_day"]), ticket["purpose"]]
        "identification":
            return "IDENTITY RECORD\n\nPrinted name: %s\nSpecies: %s\n\nCompare BOTH portrait tiles below with the traveler through the window. Check fields on the separate pass." % [ticket["identity_name"], ticket["subject"]]
        "guardian":
            return "ACCOMPANIED MINOR CHECK\n\nCub with applicant: %s\nDocument: %s\n\nA gate entry decision does not establish custody or residence in Briarwood." % ["yes" if ticket["accompanied_minor"] else "no", ticket["guardian_document"]]
        "rules":
            var rules: Array = GateSystem.read_fixture().get("training_rules", [])
            return "QA TRAINING RULEBOOK\n(NOT FINAL HONEYHOLD LAW)\n\n" + "\n".join(rules)
        _:
            return "APPLICANT WINDOW\n\n%s\nPurpose: %s\n\n1. Inspect pass and identity.\n2. Ask questions or call a record source.\n3. Choose a cited reason.\n4. Authorize, hold, or deny.\n\nYour decision changes ENTRY permission only." % [ticket["subject"], ticket["purpose"]]

func _refresh() -> void:
    if world == null or case_label == null:
        return
    var gate: Dictionary = world.state["gate"]
    var ticket: Dictionary = _ticket()
    var clock: Dictionary = world.state["shift_clock"]
    case_label.text = ("SHIFT COMPLETE  ·  %d resolved\n%d remaining unprocessed" % [gate["decisions"].size(), gate["skipped"].size()]) if gate["complete"] else ("APPLICANT %d / %d  ·  %s\n%s" % [int(gate["cursor"]) + 1, gate["queue"].size(), str(ticket.get("type", "")).to_upper(), str(ticket.get("subject", ""))])
    clock_label.text = "SHIFT: UNLIMITED" if not clock["enabled"] else "SHIFT: %02d:%02d %s" % [int(maxi(0, int(clock["duration_seconds"] if clock["duration_seconds"] != null else 0) - int(clock["elapsed_seconds"])) / 60), maxi(0, int(clock["duration_seconds"] if clock["duration_seconds"] != null else 0) - int(clock["elapsed_seconds"])) % 60, "PAUSED" if not clock["pause_reasons"].is_empty() else ""]
    document_label.text = _document(ticket, str(gate["view"]))
    feedback_label.text = "RESPONSE: " + str(gate["last_feedback"])
    message_label.text = last_message
    timer_button.text = "Timer ON" if clock["enabled"] else "Timer OFF"
    for button in decision_buttons:
        button.disabled = gate["complete"]
    for button in inspect_buttons:
        button.disabled = gate["complete"]
    decision_reason.disabled = gate["complete"]
    early_button.disabled = gate["complete"]
    return_button.disabled = not gate["complete"]
    queue_redraw()

func _draw_animal(center: Vector2, small: bool, species: String) -> void:
    # Quadrupedal side view; no human clothing or standing pose. Low-resolution blocks.
    var coat := Color("977054")
    if species.find("red panda") >= 0:
        coat = Color("ba704c")
    if species.find("cat") >= 0:
        coat = Color("a9a5a0")
    var factor: float = 0.82 if small else 1.0
    draw_rect(Rect2(center + Vector2(-55, -25) * factor, Vector2(85, 53) * factor), coat)
    draw_rect(Rect2(center + Vector2(12, -46) * factor, Vector2(51, 58) * factor), coat.lightened(0.09))
    draw_rect(Rect2(center + Vector2(43, -10) * factor, Vector2(32, 19) * factor), coat.lightened(0.23))
    for dx in [-43, -15, 19, 40]:
        draw_rect(Rect2(center + Vector2(dx, 22) * factor, Vector2(13, 22) * factor), coat.darkened(0.14))
    draw_rect(Rect2(center + Vector2(21, -47) * factor, Vector2(15, 15) * factor), coat)
    draw_rect(Rect2(center + Vector2(51, -45) * factor, Vector2(12, 15) * factor), coat)
    draw_rect(Rect2(center + Vector2(49, -26) * factor, Vector2(6, 6) * factor), Color("28262a"))
    draw_rect(Rect2(center + Vector2(69, -6) * factor, Vector2(8, 7) * factor), Color("28262a"))

func _draw() -> void:
    draw_rect(Rect2(0, 0, 960, 540), Color("282c32"))
    draw_rect(Rect2(0, 68, 656, 393), Color("665951"))
    for i in range(11):
        draw_rect(Rect2(0, 77 + i * 35, 656, 2), Color("74665b"))
    # Booth window, visitor in quadrupedal stance.
    draw_rect(Rect2(17, 95, 214, 244), STONE)
    draw_rect(Rect2(24, 102, 200, 226), Color("404b54"))
    draw_rect(Rect2(29, 278, 192, 46), Color("524c48"))
    var ticket: Dictionary = _ticket() if world != null else {}
    if not ticket.is_empty():
        _draw_animal(Vector2(88, 223), false, str(ticket.get("subject", "")))
        if bool(ticket.get("accompanied_minor", false)):
            _draw_animal(Vector2(159, 277), true, "anonymous brown bear cub")
    # Wooden inspection desk, paper tray, tangible stamp block.
    draw_rect(Rect2(0, 405, 657, 58), Color("886147"))
    for x in range(0, 650, 63):
        draw_rect(Rect2(x, 413, 3, 45), Color("664936"))
    draw_rect(Rect2(249, 107, 382, 304), Color("876a51"))
    draw_rect(Rect2(255, 112, 371, 293), PAPER)
    draw_rect(Rect2(251, 112, 4, 293), Color("c7b48c"))
    draw_rect(Rect2(620, 112, 6, 293), Color("beab84"))
    draw_rect(Rect2(50, 372, 87, 33), Color("b77d57"))
    draw_rect(Rect2(59, 360, 68, 17), Color("71493a"))
    draw_rect(Rect2(174, 370, 52, 36), Color("4a413c"))
    draw_rect(Rect2(182, 361, 36, 12), GOLD)
    if not ticket.is_empty() and world.state["gate"]["view"] == "identification":
        # Distinct on-paper photo samples, not a text flag that solves the puzzle.
        _photo_tile(Vector2(289, 293), true)
        _photo_tile(Vector2(482, 293), bool(ticket["photo_matches"]))

func _photo_tile(origin: Vector2, matches: bool) -> void:
    draw_rect(Rect2(origin, Vector2(98, 92)), Color("bda789"))
    draw_rect(Rect2(origin + Vector2(4, 4), Vector2(90, 84)), Color("65707a"))
    var fur: Color = Color("ad8868") if matches else Color("d1b8a0")
    draw_rect(Rect2(origin + Vector2(23, 23), Vector2(52, 45)), fur)
    draw_rect(Rect2(origin + Vector2(25, 13), Vector2(18, 16)), fur)
    draw_rect(Rect2(origin + Vector2(55, 13), Vector2(17, 16)), fur)
    draw_rect(Rect2(origin + Vector2(36, 37), Vector2(6, 6)), Color("29272b"))
    draw_rect(Rect2(origin + Vector2(60, 37), Vector2(6, 6)), Color("29272b"))
    draw_rect(Rect2(origin + Vector2(44, 50), Vector2(14, 10)), Color("6e5145"))
