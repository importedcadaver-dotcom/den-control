extends Control
## P4 single-world shell: home and an anonymous QA gate shift. P5 refuge not built.
const WorldState = preload("res://scripts/world/world_state.gd")
const HomeView = preload("res://scripts/home/home_view.gd")
const GateView = preload("res://scripts/gate/gate_view.gd")
var world: RefCounted
var active_view: Control

func _ready() -> void:
    world = WorldState.new()
    var problems: Array[String] = WorldState.validate_state(world.snapshot())
    if not problems.is_empty():
        push_error("World state failed validation: " + "; ".join(problems))
        return
    _show_home()

func _swap(next: Control) -> void:
    if active_view != null:
        remove_child(active_view)
        active_view.queue_free()
    active_view = next
    active_view.setup(world)
    add_child(active_view)

func _show_home() -> void:
    var home := HomeView.new()
    home.request_gate.connect(_show_gate)
    _swap(home)

func _show_gate() -> void:
    if (not world.state["gate"]["started"] or int(world.state["gate"]["shift_day"]) != int(world.state["calendar"]["day_index"])) and not world.begin_gate():
        push_warning("Gate unavailable: " + world.last_error)
        return
    var gate := GateView.new()
    gate.request_home.connect(_show_home)
    _swap(gate)
