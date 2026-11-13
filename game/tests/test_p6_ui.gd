extends SceneTree
## P6 UI proof: real home/gate/refuge transitions and family schedule in one WorldState.
const Main = preload("res://scripts/main.gd")
const HomeView = preload("res://scripts/home/home_view.gd")
const GateView = preload("res://scripts/gate/gate_view.gd")
const RefugeView = preload("res://scripts/refuge/refuge_view.gd")
var checks: int = 0
var failures: Array[String] = []
func expect(ok: bool, label: String) -> void:
    checks += 1
    if not ok:
        failures.append(label)
        push_error(label)
func _initialize() -> void:
    call_deferred("_run")
func _run() -> void:
    var main = Main.new()
    get_root().add_child(main)
    await process_frame
    expect(main.active_view is HomeView, "home visible first")
    expect(main.active_view.notes_label.text.find("Care schedule (QA)") >= 0, "family schedule visible")
    main._show_gate()
    await process_frame
    expect(main.active_view is GateView, "gate UI opened")
    expect(main.world.state["family_schedule"]["window"] == "preschool", "school schedule starts with gate")
    var gate: Control = main.active_view
    gate._decide("authorized")
    expect(main.world.state["entry_permissions"].size() == 1, "UI gate authorization persisted")
    gate._end_early()
    gate._go_home()
    await process_frame
    expect(main.active_view is HomeView, "home after gate")
    expect(main.world.state["family_schedule"]["window"] == "mama_home", "Mama home after work")
    expect(main.world.advance_day(), "refuge day follows")
    main._show_refuge()
    await process_frame
    expect(main.active_view is RefugeView, "refuge UI opened")
    var refuge: Control = main.active_view
    refuge._admit()
    expect(main.world.state["refuge"]["residents"].size() == 1, "resident admitted in UI")
    refuge._seed_budget()
    refuge._buy("food")
    refuge._care("feed")
    expect(main.world.state["refuge"]["supplies"]["food"] == 2, "one unit food consumed")
    refuge._finish()
    refuge._home()
    await process_frame
    expect(main.active_view is HomeView, "home after refuge")
    expect(main.active_view.notes_label.text.find("Care schedule (QA)") >= 0, "schedule visible on return")
    expect(main.world.state["guardian_links"]["uc.family.button"]["guardian_id"] == "uc.family.mama", "no custody substitution")
    expect(main.world.state["financials"]["ledgers"]["household"]["balance_hm"] == null, "private funds unaffected")
    print("P6 UI: ", checks, " checks, ", failures.size(), " failures")
    quit(0 if failures.is_empty() else 1)
