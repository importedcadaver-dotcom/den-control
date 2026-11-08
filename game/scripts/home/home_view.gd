extends Control
signal request_gate
## A bounded P3 home sandbox: visible quadrupedal bears, needs, actions, and memories.
## Does not advance work shifts, run school or generate named characters.
const HomeSystem = preload("res://scripts/home/home_system.gd")
const SaveStore = preload("res://scripts/world/save_store.gd")
const SAVE_PATH := "user://uc_p4_dev.json"
const VIEW_WIDTH := 960.0
const ROOM_WIDTH := 656.0
const PALETTE := {
    "ink": Color("322b2d"), "wood": Color("765044"), "wood_light": Color("ae7b5c"),
    "stone": Color("465054"), "wall": Color("73685c"), "floor": Color("b48a68"),
    "light": Color("e7c99e"), "paper": Color("ede0bd"), "accent": Color("e4ae70"),
    "mama": Color("765034"), "button": Color("b77b49"), "hazel": Color("a16a3f")
}
var world: RefCounted
var running: bool = true
var selected_label: Label
var statistics_label: Label
var notes_label: Label
var time_label: Label
var message_label: Label
var buttons: Dictionary = {}
var timer: Timer
var last_message: String = "Choose a cub or click one in the room. Actions affect persistent needs and memories."

func setup(ref: RefCounted) -> void:
    world = ref

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_STOP
    _make_ui()
    timer = Timer.new()
    timer.wait_time = 1.4
    timer.autostart = true
    timer.timeout.connect(_on_tick)
    add_child(timer)
    _refresh()

func _make_ui() -> void:
    var title := _label("UNBEARABLE CONDITIONS  /  THE DEN", Vector2(25, 12), Vector2(620, 36), 25)
    title.add_theme_color_override("font_color", Color("f4d6ac"))
    var detail := _label("P4 WORK IN PROGRESS  •  GATE SHIFT TRAINING AVAILABLE", Vector2(26, 43), Vector2(610, 22), 12)
    detail.add_theme_color_override("font_color", Color("e9bda0"))
    time_label = _label("", Vector2(23, 478), Vector2(615, 24), 14)
    message_label = _label("", Vector2(24, 503), Vector2(624, 30), 13)
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
    sidebar.add_child(scroll)
    var stack := VBoxContainer.new()
    stack.custom_minimum_size = Vector2(275, 560)
    stack.add_theme_constant_override("separation", 7)
    scroll.add_child(stack)
    _spacer(stack, 9)
    _stack_label(stack, "MAMA'S CUBS", 23)
    var tabs := HBoxContainer.new()
    stack.add_child(tabs)
    for id in HomeSystem.CUB_IDS:
        var btn := _action_button("Button" if id == HomeSystem.BUTTON else "Hazel", tabs)
        btn.pressed.connect(_select.bind(id))
        buttons[id] = btn
    selected_label = _stack_label(stack, "", 17)
    statistics_label = _stack_label(stack, "", 13)
    statistics_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _stack_label(stack, "MAMA ACTIONS", 16)
    var actions := GridContainer.new()
    actions.columns = 2
    stack.add_child(actions)
    for item in [["Feed", "feed"], ["Cuddle", "cuddle"], ["Play", "play"], ["Wash", "clean"],
                 ["Pick up", "carry"], ["Put down", "put_down"], ["Ask to tidy", "ask_tidy"],
                 ["First aid", "first_aid"], ["Separate", "separate"], ["Play together", "play_together"]]:
        var btn := _action_button(item[0], actions)
        btn.custom_minimum_size = Vector2(128, 32)
        btn.pressed.connect(_act.bind(item[1]))
    _stack_label(stack, "OBSERVATION", 16)
    notes_label = _stack_label(stack, "", 12)
    notes_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    var tools := HBoxContainer.new()
    stack.add_child(tools)
    _action_button("Pause", tools).pressed.connect(_toggle_pause)
    _action_button("Save", tools).pressed.connect(_save)
    _action_button("Load", tools).pressed.connect(_load)
    _stack_label(stack, "WORK / DAY", 16)
    var work_row := HBoxContainer.new()
    stack.add_child(work_row)
    _action_button("Go to gate", work_row).pressed.connect(_go_gate)
    _action_button("Next day", work_row).pressed.connect(_next_day)
    _spacer(stack, 12)

func _go_gate() -> void:
    if world.current_duty() != "gate":
        last_message = "No gate shift today. Next scheduled duty: " + world.current_duty() + "."
    elif world.state["gate"]["complete"]:
        last_message = "Today's gate shift is already completed."
    else:
        request_gate.emit()
    _refresh()

func _next_day() -> void:
    if world.advance_day():
        last_message = "A new day begins. The scheduled duty is " + world.current_duty() + "."
    else:
        last_message = "Cannot advance yet: " + world.last_error
    _refresh()

func _spacer(parent: Node, height: float) -> void:
    var spacer := Control.new()
    spacer.custom_minimum_size = Vector2(1, height)
    parent.add_child(spacer)

func _label(value: String, at: Vector2, minimum: Vector2, font_size: int) -> Label:
    var label := Label.new()
    label.text = value
    label.position = at
    label.custom_minimum_size = minimum
    label.size = minimum
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", Color("f6e1c0"))
    add_child(label)
    return label

func _stack_label(parent: Node, message: String, size: int) -> Label:
    var label := Label.new()
    label.text = message
    label.custom_minimum_size = Vector2(262, 22)
    label.add_theme_font_size_override("font_size", size)
    label.add_theme_color_override("font_color", Color("f3e1c3"))
    parent.add_child(label)
    return label

func _action_button(text: String, parent: Node) -> Button:
    var button := Button.new()
    button.text = text
    button.custom_minimum_size = Vector2(81, 33)
    button.add_theme_font_size_override("font_size", 13)
    parent.add_child(button)
    return button

func _select(id: String) -> void:
    if world.select_home_cub(id):
        last_message = "Selected " + ("Button" if id == HomeSystem.BUTTON else "Hazel") + "."
        _refresh()

func _act(action: String) -> void:
    var id: String = str(world.state["home"]["selected_id"])
    if world.act_with_cub(id, action):
        var last: Dictionary = world.state["events"].back()
        last_message = str(last["details"].get("description", action))
    else:
        last_message = "Cannot do that: " + str(world.last_error)
    _refresh()

func _on_tick() -> void:
    if not running or world == null:
        return
    var previous_count: int = world.state["events"].size()
    world.tick_home()
    if world.state["events"].size() > previous_count:
        var latest: Dictionary = world.state["events"].back()
        if str(latest["type"]).begins_with("home.sibling"):
            last_message = "The cubs are arguing. Their feelings and memories have changed."
    _refresh()

func _toggle_pause() -> void:
    running = not running
    last_message = "Autonomous cubs: " + ("RUNNING" if running else "PAUSED")
    _refresh()

func _save() -> void:
    var result: Dictionary = SaveStore.save_document(SAVE_PATH, world.snapshot())
    last_message = "Saved persistent P3 home state." if result.get("ok", false) else "Save failed: " + str(result.get("error", ""))
    _refresh()

func _load() -> void:
    var result: Dictionary = SaveStore.load_into(SAVE_PATH, world)
    last_message = "Loaded home state and memories." if result.get("ok", false) else "Load failed: " + str(result.get("error", ""))
    _refresh()

func _refresh() -> void:
    if world == null or selected_label == null:
        return
    var home: Dictionary = world.state["home"]
    var id: String = str(home["selected_id"])
    var cub: Dictionary = home["cubs"][id]
    var name := "BUTTON" if id == HomeSystem.BUTTON else "HAZEL"
    selected_label.text = name + "  /  6 MONTHS"
    statistics_label.text = "Hunger: %d   Energy: %d\nComfort: %d   Curiosity: %d\nStress: %d     Health: %d\nTrust in Mama: %d\nNow: %s" % [int(cub["hunger"]), int(cub["energy"]), int(cub["comfort"]), int(cub["curiosity"]), int(cub["stress"]), int(cub["health"]), int(cub["trust_mama"]), str(cub["intention"]).replace("_", " ")]
    var sibling: Dictionary = home["sibling"]
    var latest_memory: String = "No memories yet."
    if not cub["memories"].is_empty():
        latest_memory = str(cub["memories"].back().get("detail", ""))
    notes_label.text = "Sibling bond: %d\nResentment: %d\nFights: %d\nPantry (demo): %d portions\nMemories: %d\nLast remembered: %s" % [int(sibling["bond"]), int(sibling["resentment"]), int(sibling["conflicts"]), int(home["pantry_portions"]), cub["memories"].size(), latest_memory]
    time_label.text = "DAY %d · %s  |  HOME TICKS %d  |  AUTO %s" % [int(world.state["calendar"]["day_index"]) + 1, str(world.state["calendar"]["phase"]).to_upper(), int(home["sim_steps"]), "ON" if running else "PAUSED"]
    message_label.text = last_message
    queue_redraw()

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var position: Vector2 = event.position
        for id in HomeSystem.CUB_IDS:
            var cub: Dictionary = world.state["home"]["cubs"][id]
            var target := _cub_position(cub, id)
            if position.distance_to(target + Vector2(0, -12)) < 62:
                _select(id)
                accept_event()
                return

func _draw() -> void:
    # All colors and shapes are authored as one pixel-grid art language.
    draw_rect(Rect2(0, 0, 960, 540), Color("282a2f"))
    draw_rect(Rect2(0, 60, ROOM_WIDTH, 404), PALETTE["wall"])
    for idx in range(8):
        draw_rect(Rect2(0, 70 + idx * 38, ROOM_WIDTH, 3), Color("645a51"))
    draw_rect(Rect2(0, 292, ROOM_WIDTH, 174), PALETTE["floor"])
    for i in range(14):
        draw_rect(Rect2(i * 49, 297, 2, 165), Color("917055"))
    # Stone window over the mountain settlement: no fabricated district names.
    draw_rect(Rect2(400, 92, 178, 128), Color("554940"))
    draw_rect(Rect2(410, 101, 158, 108), Color("313d4b"))
    draw_rect(Rect2(414, 176, 150, 29), Color("4d585a"))
    for x in range(420, 562, 18):
        draw_rect(Rect2(x, 160 - (x % 3) * 7, 12, 38), Color("a17e65"))
        draw_rect(Rect2(x+3, 172, 4, 8), Color("e9b86e"))
    # A bed, familiar objects and a cozy den floor, designed for four-legged bears.
    draw_rect(Rect2(32, 196, 218, 108), Color("5c413a"))
    draw_rect(Rect2(38, 202, 206, 91), Color("af8b79"))
    for i in range(6):
        draw_rect(Rect2(38 + i * 33, 213, 28, 65), Color("c5a69a") if i % 2 == 0 else Color("e1c4a8"))
    draw_rect(Rect2(48, 211, 68, 27), Color("f1dbc4"))
    draw_rect(Rect2(278, 368, 210, 62), Color("7e6554"))
    draw_rect(Rect2(288, 377, 190, 45), Color("a77e67"))
    draw_rect(Rect2(520, 333, 55, 24), Color("6d5746"))
    draw_rect(Rect2(536, 315, 26, 19), Color("e5c07e"))
    # Cub play block, recognizably domestic and accessible.
    draw_rect(Rect2(314, 342, 22, 24), Color("c89557"))
    draw_rect(Rect2(337, 338, 19, 28), Color("6f8d8b"))
    _bear(Vector2(135, 371), 2.55, PALETTE["mama"], false, false, false)
    var home: Dictionary = world.state["home"] if world != null else {}
    if home.has("cubs"):
        for id in HomeSystem.CUB_IDS:
            var cub: Dictionary = home["cubs"][id]
            var selected: bool = id == home["selected_id"]
            var distressed: bool = int(cub["stress"]) > 52 or int(cub["comfort"]) < 38
            var color: Color = PALETTE["button"] if id == HomeSystem.BUTTON else PALETTE["hazel"]
            var origin := _cub_position(cub, id)
            _bear(origin, 1.27, color, distressed, bool(cub["hurt"]), selected)
            if selected:
                draw_rect(Rect2(origin.x-35, origin.y-58, 68, 3), Color("f5d894"))

func _cub_position(cub: Dictionary, id: String) -> Vector2:
    if bool(cub.get("carried", false)):
        return Vector2(163, 314)
    return Vector2(76 + float(cub["x"]) * 565, 405 if id == HomeSystem.BUTTON else 447)

func _oval(origin: Vector2, rx: int, ry: int, color: Color, pixel: int = 4) -> void:
    for dy in range(-ry, ry + 1, pixel):
        for dx in range(-rx, rx + 1, pixel):
            if float(dx * dx) / float(rx * rx) + float(dy * dy) / float(ry * ry) <= 1.0:
                draw_rect(Rect2(origin.x + dx, origin.y + dy, pixel, pixel), color)

func _bear(origin: Vector2, scale_factor: float, coat: Color, tears: bool, injury: bool, selected: bool) -> void:
    # A side-profile quadruped: all four paws remain on the ground, never bipedal.
    var p := maxf(1.0, scale_factor)
    var dark: Color = coat.darkened(0.25)
    var shine: Color = coat.lightened(0.16)
    _oval(origin + Vector2(-5*p, -16*p), int(25*p), int(15*p), dark, 4)
    _oval(origin + Vector2(-4*p, -18*p), int(24*p), int(13*p), coat, 4)
    for leg in [-22, -9, 7, 17]:
        draw_rect(Rect2(origin.x + leg*p, origin.y - 14*p, 7*p, 18*p), dark)
        draw_rect(Rect2(origin.x + leg*p-2, origin.y + 3*p, 11*p, 4*p), coat)
    _oval(origin + Vector2(21*p, -21*p), int(13*p), int(12*p), coat, 3)
    _oval(origin + Vector2(17*p, -32*p), int(5*p), int(5*p), dark, 3)
    _oval(origin + Vector2(28*p, -33*p), int(5*p), int(5*p), dark, 3)
    _oval(origin + Vector2(30*p, -17*p), int(10*p), int(7*p), shine, 3)
    draw_rect(Rect2(origin.x+26*p, origin.y-19*p, 3*p, 3*p), PALETTE["ink"])
    draw_rect(Rect2(origin.x+29*p, origin.y-26*p, 3*p, 3*p), PALETTE["ink"])
    draw_rect(Rect2(origin.x-22*p, origin.y-21*p, 8*p, 5*p), shine)
    if tears:
        draw_rect(Rect2(origin.x + 29*p, origin.y - 22*p, 3*p, 6*p), Color("88c4de"))
    if injury:
        draw_rect(Rect2(origin.x + 15*p, origin.y - 19*p, 4*p, 4*p), Color("a96262"))
    if selected:
        draw_rect(Rect2(origin.x-25*p, origin.y+7*p, 58*p, 2), Color("f7db92"))
