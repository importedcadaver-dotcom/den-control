extends Control
## P5 visible, playable QA refuge. No new named residents or approved prices.
signal request_home
const RefugeSystem = preload("res://scripts/refuge/refuge_system.gd")
const SaveStore = preload("res://scripts/world/save_store.gd")
const SAVE_PATH := "user://uc_p4_dev.json"

var world: RefCounted
var clock: Timer
var pulses: int = 0
var admission_options: OptionButton
var resident_options: OptionButton
var overview: Label
var details: Label
var report: Label
var finish_button: Button
var home_button: Button
var last_message: String = "QA facility: choose authorized visitors, reserve beds and care for residents."

func setup(world_ref: RefCounted) -> void:
    world = world_ref

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _build()
    clock = Timer.new()
    clock.wait_time = 1.0
    clock.timeout.connect(_pulse)
    add_child(clock)
    clock.start()
    _refresh()

func _label(parent: Node, value: String, size: int = 13) -> Label:
    var text := Label.new()
    text.text = value
    text.add_theme_font_size_override("font_size", size)
    text.add_theme_color_override("font_color", Color("e9d0a7"))
    text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    parent.add_child(text)
    return text

func _button(parent: Node, title: String, callback: Callable) -> Button:
    var b := Button.new()
    b.text = title
    b.custom_minimum_size = Vector2(122, 32)
    b.add_theme_font_size_override("font_size", 12)
    parent.add_child(b)
    b.pressed.connect(callback)
    return b

func _build() -> void:
    var heading := Label.new()
    heading.text = "UNBEARABLE CONDITIONS  /  BRIARWOOD REFUGE"
    heading.position = Vector2(23, 9)
    heading.add_theme_font_size_override("font_size", 22)
    heading.add_theme_color_override("font_color", Color("f3d6ae"))
    add_child(heading)
    var notice := Label.new()
    notice.text = "P6 QA TRAINING REFUGE  ·  PROVISIONAL COSTS / CAPACITY  ·  NOT CANON"
    notice.position = Vector2(24, 43)
    notice.add_theme_font_size_override("font_size", 11)
    add_child(notice)
    overview = Label.new()
    overview.position = Vector2(22, 362)
    overview.size = Vector2(632, 44)
    overview.add_theme_font_size_override("font_size", 14)
    overview.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    add_child(overview)
    details = Label.new()
    details.position = Vector2(22, 414)
    details.size = Vector2(632, 34)
    details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    add_child(details)
    report = Label.new()
    report.position = Vector2(23, 475)
    report.size = Vector2(625, 58)
    report.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    report.add_theme_color_override("font_color", Color("f0d4a9"))
    add_child(report)
    var side := PanelContainer.new()
    side.position = Vector2(668, 0)
    side.size = Vector2(292, 540)
    side.custom_minimum_size = Vector2(292, 540)
    var style := StyleBoxFlat.new()
    style.bg_color = Color("292c32")
    style.border_color = Color("9e7862")
    style.border_width_left = 3
    side.add_theme_stylebox_override("panel", style)
    add_child(side)
    var scroll := ScrollContainer.new()
    scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    side.add_child(scroll)
    var stack := VBoxContainer.new()
    stack.custom_minimum_size = Vector2(270, 850)
    stack.add_theme_constant_override("separation", 8)
    scroll.add_child(stack)
    _label(stack, "PUBLIC FACILITY", 21)
    _label(stack, "ADMIT AUTHORIZED QA VISITOR", 12)
    admission_options = OptionButton.new()
    stack.add_child(admission_options)
    _button(stack, "Reserve bed / Admit", _admit)
    _label(stack, "SELECT REFUGE RESIDENT", 12)
    resident_options = OptionButton.new()
    stack.add_child(resident_options)
    var care_grid := GridContainer.new()
    care_grid.columns = 2
    stack.add_child(care_grid)
    for pair in [["Feed", "feed"], ["Comfort", "comfort"], ["Let rest", "rest"], ["Treat", "treat"]]:
        _button(care_grid, pair[0], _care.bind(pair[1]))
    _label(stack, "PUBLIC SUPPLIES AND BEDS", 13)
    _button(stack, "Seed QA budget 80 HM", _seed_budget)
    var buy_grid := GridContainer.new()
    buy_grid.columns = 2
    stack.add_child(buy_grid)
    for item in ["food", "medicine", "blankets", "bed"]:
        _button(buy_grid, "Buy " + item + " · " + str(RefugeSystem.QA_COSTS[item]) + " HM", _buy.bind(item))
    _label(stack, "WORK SHIFT", 13)
    finish_button = _button(stack, "Finish refuge shift", _finish)
    home_button = _button(stack, "Return to Mama", _home)
    _button(stack, "Save world", _save)
    _button(stack, "Load world", _load)
    _label(stack, "All applicants are anonymous test records. City entry does not automatically reserve a bed. No purchases use Mama's household money.", 11)

func _chosen(options: OptionButton) -> Dictionary:
    if options.item_count == 0 or options.selected < 0:
        return {}
    var metadata: Variant = options.get_item_metadata(options.selected)
    return metadata if metadata is Dictionary else {}

func _seed_budget() -> void:
    last_message = "Provisional public QA budget seeded." if world.configure_opening_balance("refuge", 80) else "Budget not changed: " + world.last_error
    _refresh()

func _admit() -> void:
    var item: Dictionary = _chosen(admission_options)
    last_message = "QA resident placed in an available bed." if not item.is_empty() and world.admit_refuge_subject(str(item["subject_id"]), str(item["case_id"])) else "Admission refused: " + world.last_error
    _refresh()

func _buy(item: String) -> void:
    last_message = "Public money spent on " + item + "." if world.buy_refuge_supply(item) else "Purchase refused: " + world.last_error
    _refresh()

func _care(action: String) -> void:
    var item: Dictionary = _chosen(resident_options)
    last_message = "Resident care: " + action + "." if not item.is_empty() and world.care_refuge_subject(str(item["subject_id"]), action) else "Care refused: " + world.last_error
    _refresh()

func _finish() -> void:
    last_message = "Refuge day complete." if world.finish_refuge() else "Unable to finish: " + world.last_error
    _refresh()

func _home() -> void:
    if world.state["refuge"]["complete"]:
        request_home.emit()
    else:
        last_message = "Complete the shift before returning home."
        _refresh()

func _save() -> void:
    var result: Dictionary = SaveStore.save_document(SAVE_PATH, world.snapshot())
    last_message = "World saved with residents and public budget." if result.get("ok", false) else "Save failed: " + str(result.get("error", ""))
    _refresh()

func _load() -> void:
    var result: Dictionary = SaveStore.load_into(SAVE_PATH, world)
    last_message = "World restored." if result.get("ok", false) else "Load failed: " + str(result.get("error", ""))
    _refresh()

func _pulse() -> void:
    if world == null or not bool(world.state["refuge"]["started"]) or bool(world.state["refuge"]["complete"]):
        return
    world.tick_shift(1.0)
    pulses += 1
    if pulses % 8 == 0:
        world.tick_refuge(1)
    _refresh()

func _refresh() -> void:
    if world == null or overview == null:
        return
    var r: Dictionary = world.state["refuge"]
    var ledger: Dictionary = world.state["financials"]["ledgers"]["refuge"]
    var money: String = "UNSET — seed QA budget to purchase" if ledger["balance_hm"] == null else str(ledger["balance_hm"]) + " HM"
    overview.text = "Day %d · Beds %d/%d occupied · Capacity %d\nPublic budget: %s" % [int(world.state["calendar"]["day_index"]) + 1, r["residents"].size(), r["bed_count"], r["capacity"], money]
    details.text = "Food: %d    Medicine: %d    Blankets: %d    Care actions: %d" % [r["supplies"]["food"], r["supplies"]["medicine"], r["supplies"]["blankets"], r["care_log"].size()]
    report.text = last_message
    var previous: Dictionary = _chosen(resident_options)
    var previous_id: String = str(previous.get("subject_id", ""))
    admission_options.clear()
    for person in world.eligible_refuge_subjects():
        admission_options.add_item(str(person["subject_id"]))
        admission_options.set_item_metadata(admission_options.item_count - 1, person)
    resident_options.clear()
    var selected_index: int = 0
    for subject in r["residents"].keys():
        var person: Dictionary = r["residents"][subject]
        resident_options.add_item(str(subject) + " (bed " + str(person["bed"]) + ")")
        resident_options.set_item_metadata(resident_options.item_count - 1, {"subject_id": subject})
        if str(subject) == previous_id:
            selected_index = resident_options.item_count - 1
    if resident_options.item_count > 0:
        resident_options.select(selected_index)
        var chosen: Dictionary = r["residents"][str(_chosen(resident_options).get("subject_id", ""))]
        report.text += "\nSelected: H %d · E %d · C %d · Health %d · %s" % [chosen["hunger"], chosen["energy"], chosen["comfort"], chosen["health"], chosen["intent"]]
    finish_button.disabled = r["complete"]
    home_button.disabled = not r["complete"]
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(0, 0, 960, 540), Color("292c31"))
    draw_rect(Rect2(0, 66, 656, 292), Color("68645e"))
    for y in range(75, 345, 32):
        draw_rect(Rect2(0, y, 656, 3), Color("807468"))
    draw_rect(Rect2(0, 300, 656, 55), Color("a48067"))
    draw_rect(Rect2(27, 112, 250, 143), Color("8b7564"))
    draw_rect(Rect2(36, 120, 230, 127), Color("d6b99a"))
    # Beds are furniture assets, never implied citizen slots.
    if world == null or not world.state.has("refuge"):
        return
    var r: Dictionary = world.state["refuge"]
    for i in range(int(r["bed_count"])):
        var x: float = 46 + i * 188
        draw_rect(Rect2(x, 280, 152, 51), Color("6c5043"))
        draw_rect(Rect2(x+8, 283, 136, 37), Color("c8ac86"))
        draw_rect(Rect2(x+16, 286, 39, 22), Color("e2cfb5"))
    for subject in r["residents"].keys():
        var person: Dictionary = r["residents"][subject]
        _animal(Vector2(95 + 188 * (int(person["bed"]) - 1), 274), 0.85, Color("ad8060"))
    draw_rect(Rect2(18, 97, 15, 251), Color("51443c"))
    draw_rect(Rect2(640, 97, 12, 251), Color("51443c"))

func _animal(base: Vector2, size_factor: float, fur: Color) -> void:
    var f: float = size_factor
    draw_rect(Rect2(base + Vector2(-43, -27) * f, Vector2(80, 36) * f), fur)
    draw_rect(Rect2(base + Vector2(17, -41) * f, Vector2(36, 43) * f), fur.lightened(0.1))
    for dx in [-37, -17, 12, 31]:
        draw_rect(Rect2(base + Vector2(dx, 6) * f, Vector2(11, 23) * f), fur.darkened(0.18))
    draw_rect(Rect2(base + Vector2(31, -17) * f, Vector2(27, 14) * f), fur.lightened(0.2))
    draw_rect(Rect2(base + Vector2(47, -29) * f, Vector2(5, 5) * f), Color("29262a"))
