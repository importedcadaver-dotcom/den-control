extends SceneTree
## Live scene integration smoke: home -> gate desk -> decision -> return home.
const Main = preload("res://scripts/main.gd")
const GateView = preload("res://scripts/gate/gate_view.gd")
const HomeView = preload("res://scripts/home/home_view.gd")

var checks: int = 0
var failed: Array[String] = []

func expect(condition: bool, label: String) -> void:
    checks += 1
    if not condition:
        failed.append(label)
        push_error(label)

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var root: Node = get_root()
    var main := Main.new()
    root.add_child(main)
    await process_frame
    expect(main.active_view is HomeView, "P3 home scene visible on boot")
    expect(main.world.state["calendar"]["phase"] == "morning", "day begins at home")
    main._show_gate()
    await process_frame
    expect(main.active_view is GateView, "P4 gate desk opens from home")
    if not main.active_view is GateView:
        print("P4 UI: aborted because gate did not load")
        quit(1)
        return
    var gate: Control = main.active_view
    expect(gate.case_label.text.find("APPLICANT 1 / 6") >= 0, "visible case header")
    expect(gate.document_label.text.find("APPLICANT WINDOW") >= 0, "visible applicant interface")
    expect(gate.decision_reason.item_count == 5, "specific reasons selectable")
    gate._inspect("pass")
    expect(main.world.state["shift_clock"]["pause_reasons"].has("reading_documents"), "paper reading pauses timer in UI")
    expect(gate.document_label.text.find("TEMPORARY ENTRY PASS") >= 0, "paper content visible")
    gate._inspect("rules")
    expect(gate.document_label.text.find("NOT FINAL HONEYHOLD LAW") >= 0, "QA rulebook is clearly provisional")
    gate._inspect("summary")
    expect(main.world.state["shift_clock"]["pause_reasons"].is_empty(), "closing papers resumes clock")
    gate._ask("purpose")
    expect(gate.feedback_label.text.find("Routine delivery") >= 0, "question response appears")
    gate._decide("authorized")
    expect(main.world.state["gate"]["cursor"] == 1, "stamp decision advances to next applicant")
    expect(main.world.state["entry_permissions"].size() == 1, "UI uses same world legal state")
    gate._end_early()
    expect(main.world.state["gate"]["complete"], "end early records omitted cases")
    expect(gate.return_button.disabled == false, "return-home UI now enabled")
    gate._go_home()
    await process_frame
    expect(main.active_view is HomeView, "return to existing P3 family home")
    expect(main.world.state["calendar"]["phase"] == "evening", "evening follows completed workday")
    expect(main.world.state["home"]["cubs"].size() == 2, "same two cubs persist across scene switch")
    expect(main.world.state["entry_permissions"].size() == 1, "entry decision survives scene switch")
    print("P4 UI: ", checks, " checks, ", failed.size(), " failures")
    quit(0 if failed.is_empty() else 1)
