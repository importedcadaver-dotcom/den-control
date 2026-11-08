extends Control
## P3 home simulation: limited interactive slice, NOT the two-day production milestone.
const WorldState = preload("res://scripts/world/world_state.gd")
const HomeView = preload("res://scripts/home/home_view.gd")
var world: RefCounted

func _ready() -> void:
    world = WorldState.new()
    var problems: Array[String] = WorldState.validate_state(world.snapshot())
    if not problems.is_empty():
        push_error("World state failed validation: " + "; ".join(problems))
        return
    var home := HomeView.new()
    home.setup(world)
    add_child(home)
