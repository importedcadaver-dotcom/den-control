extends SceneTree
## Godot UI smoke: home -> gate -> home -> refuge -> home with one persistent world.
const Main = preload("res://scripts/main.gd")
const HomeView = preload("res://scripts/home/home_view.gd")
const RefugeView = preload("res://scripts/refuge/refuge_view.gd")
var checks := 0
var failures: Array[String] = []

func expect(ok: bool, label: String) -> void:
    checks += 1
    if not ok:
        failures.append(label)
        push_error(label)

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var main := Main.new()
    get_root().add_child(main)
    await process_frame
    expect(main.active_view is HomeView, "home scene on boot")
    main._show_gate()
    await process_frame
    expect(main.world.state["gate"]["started"], "first gate day started")
    expect(main.world.decide_gate("authorized", "valid_pass"), "one applicant cleared")
    expect(main.world.finish_gate(true), "gate ended with remaining cases pending")
    main._show_home()
    await process_frame
    expect(main.active_view is HomeView, "back to Mama")
    expect(main.world.advance_day(), "advance to refuge day")
    main._show_refuge()
    await process_frame
    expect(main.active_view is RefugeView, "refuge view opens")
    if not main.active_view is RefugeView:
        quit(1)
        return
    var view: Control = main.active_view
    expect(view.admission_options.item_count >= 1, "authorized gate applicant selectable")
    view._seed_budget()
    expect(main.world.state["financials"]["ledgers"]["refuge"]["balance_hm"] == 80, "public QA budget explicitly seeded")
    view._admit()
    expect(main.world.state["refuge"]["residents"].size() == 1, "UI admits resident with bed")
    view._buy("food")
    expect(main.world.state["refuge"]["supplies"]["food"] == 3, "food purchased")
    view._care("feed")
    expect(main.world.state["refuge"]["supplies"]["food"] == 2, "food used for care")
    view._finish()
    expect(main.world.state["refuge"]["complete"], "refuge finished")
    view._home()
    await process_frame
    expect(main.active_view is HomeView, "home after refuge")
    expect(main.world.state["calendar"]["phase"] == "evening", "shared evening calendar")
    expect(main.world.state["refuge"]["residents"].size() == 1, "resident persists across scenes")
    expect(main.world.state["guardian_links"]["uc.family.button"]["guardian_id"] == "uc.family.mama", "canonical parent unchanged")
    print("P5 UI: ", checks, " checks, ", failures.size(), " failures")
    quit(0 if failures.is_empty() else 1)
