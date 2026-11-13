extends SceneTree
## Engine-driven QA: primary navigation/decisions are visible at 960x540.
const Main = preload("res://scripts/main.gd")
const HomeView = preload("res://scripts/home/home_view.gd")
const GateView = preload("res://scripts/gate/gate_view.gd")
var checks: int = 0
var failed: Array[String] = []
func expect(ok: bool, label: String) -> void:
    checks += 1
    if not ok:
        failed.append(label)
        push_error(label)
func _initialize() -> void:
    call_deferred("_run")
func _find_button(node: Node, title: String) -> Button:
    if node is Button and node.text == title:
        return node
    for item in node.get_children():
        var found: Button = _find_button(item, title)
        if found != null:
            return found
    return null
func _run() -> void:
    var main := Main.new()
    get_root().add_child(main)
    await process_frame
    expect(main.active_view is HomeView, "home boot")
    var go_gate: Button = _find_button(main.active_view, "Go to gate")
    expect(go_gate != null, "home gate button present")
    if go_gate != null:
        expect(go_gate.get_global_rect().position.y < 130.0, "work button visible without scrolling")
    expect(main.active_view.notes_label.text.find("Care schedule (QA)") >= 0, "home schedule retained")
    main._show_gate()
    await process_frame
    expect(main.active_view is GateView, "gate view")
    if not main.active_view is GateView:
        quit(1)
        return
    var gate: Control = main.active_view
    expect(gate.document_label is RichTextLabel, "document text constrained to scrollable paper")
    expect(gate.document_label.size.y <= 290.0, "paper text surface bounded")
    expect(gate.feedback_label is RichTextLabel, "case response is clipped and scrollable")
    expect(gate.feedback_label.size.x <= 270.0, "response width bounded to sidebar")
    expect(gate.decision_buttons.size() == 3, "three distinct decision actions")
    for button in gate.decision_buttons:
        expect(button.get_global_rect().position.y > 400.0, "decision is pinned to bottom")
        expect(button.get_global_rect().end.y <= 540.0, "decision button visible in viewport")
    expect(gate.decision_reason.get_global_rect().end.y <= 540.0, "reason selector visible")
    print("P6 LAYOUT: ", checks, " checks, ", failed.size(), " failures")
    quit(0 if failed.is_empty() else 1)
