extends SceneTree
## Run with Godot 4.7.2: godot --headless --path game --script res://tests/test_p3.gd
const WorldState = preload("res://scripts/world/world_state.gd")
const HomeSystem = preload("res://scripts/home/home_system.gd")
const SaveStore = preload("res://scripts/world/save_store.gd")

var checks: int = 0
var failures: Array[String] = []

func expect(condition: bool, title: String) -> void:
    checks += 1
    if not condition:
        failures.append(title)
        push_error(title)

func _initialize() -> void:
    var world := WorldState.new()
    var home: Dictionary = world.state["home"]
    var button: Dictionary = home["cubs"][HomeSystem.BUTTON]
    var hazel: Dictionary = home["cubs"][HomeSystem.HAZEL]
    expect(WorldState.validate_state(world.snapshot()).is_empty(), "P3 initial save valid")
    expect(world.state["characters"].size() == 5, "only five approved characters")
    expect(home["cubs"].size() == 2, "exactly two approved cubs")
    expect(not home["cubs"].has("button") and not home["cubs"].has("hazel"), "legacy IDs excluded")
    expect(int(home["sibling"]["bond"]) == 0, "unapproved initial hatred not invented")
    expect(world.current_duty() == "gate", "P3 preserves original work rotation")
    expect(world.state["calendar"]["phase"] == "morning", "home begins in morning")
    expect(not world.select_home_cub("button"), "old ID selection rejected")
    expect(world.select_home_cub(HomeSystem.HAZEL), "Hazel is selectable")
    expect(world.select_home_cub(HomeSystem.BUTTON), "Button is selectable")
    expect(not world.act_with_cub("uc.family.grandma", "cuddle"), "no unauthorized cub interaction")
    expect(not world.act_with_cub(HomeSystem.BUTTON, "money_cheat"), "unsupported action rejected")
    var before_food: int = int(home["pantry_portions"])
    var before_hunger: int = int(button["hunger"])
    expect(world.act_with_cub(HomeSystem.BUTTON, "feed"), "feed Button")
    expect(int(home["pantry_portions"]) == before_food - 1, "feed consumes finite food")
    expect(int(button["hunger"]) < before_hunger, "feed reduces hunger")
    for i in range(before_food - 1):
        expect(world.act_with_cub(HomeSystem.BUTTON, "feed"), "each remaining meal consumes food")
    var event_count: int = world.state["events"].size()
    expect(not world.act_with_cub(HomeSystem.BUTTON, "feed"), "empty pantry prevents free feeding")
    expect(world.state["events"].size() == event_count, "failed feed records no false care event")
    expect(world.act_with_cub(HomeSystem.BUTTON, "carry"), "carry Button")
    expect(home["holding_id"] == HomeSystem.BUTTON and bool(button["carried"]), "carried state synchronized")
    expect(not world.act_with_cub(HomeSystem.HAZEL, "carry"), "cannot hold both cubs at once")
    expect(world.act_with_cub(HomeSystem.BUTTON, "put_down"), "put down Button")
    expect(home["holding_id"] == "" and not bool(button["carried"]), "release clears both flags")
    expect(not world.act_with_cub(HomeSystem.BUTTON, "first_aid"), "no false injury treatment")
    expect(world.act_with_cub(HomeSystem.HAZEL, "ask_tidy"), "Hazel receives request")
    expect(hazel["intention"] == "avoid", "Hazel may refuse an order")
    expect(hazel["memories"].size() > 0, "Hazel remembers refusal")
    expect(world.act_with_cub(HomeSystem.BUTTON, "ask_tidy"), "Button receives request")
    expect(button["intention"] == "play_indoors", "Button responds with indoor-oriented help")
    var old_comfort: int = int(button["comfort"])
    expect(world.act_with_cub(HomeSystem.BUTTON, "cuddle"), "Mama can comfort Button")
    expect(int(button["comfort"]) >= old_comfort, "cuddling improves comfort")
    var day: int = int(world.state["calendar"]["day_index"])
    var phase: String = str(world.state["calendar"]["phase"])
    expect(world.tick_home(20), "20 autonomous behavior steps")
    expect(home["sim_steps"] == 20, "autonomous ticks recorded")
    expect(button["intention"] != hazel["intention"], "different cub traits produce distinct intentions")
    expect(button["memories"].size() >= 2 and hazel["memories"].size() >= 1, "home memories remain")
    expect(WorldState.validate_state(world.snapshot()).is_empty(), "world validates after autonomy")
    expect(world.state["calendar"]["day_index"] == day and world.state["calendar"]["phase"] == phase, "home ticks do not skip work or school phases")
    var snap: Dictionary = world.snapshot()
    var unapproved: Dictionary = snap.duplicate(true)
    unapproved["home"]["cubs"]["uc.family.other"] = {}
    expect(not world.restore_validated(unapproved), "unapproved home character rejected")
    var bad_need: Dictionary = snap.duplicate(true)
    bad_need["home"]["cubs"][HomeSystem.BUTTON]["hunger"] = 10000
    expect(not world.restore_validated(bad_need), "out-of-range need rejected")
    var bad_memory: Dictionary = snap.duplicate(true)
    bad_memory["home"]["cubs"][HomeSystem.BUTTON]["memories"].append("corrupt")
    expect(not world.restore_validated(bad_memory), "malformed memory rejected")
    var wrong_carry: Dictionary = snap.duplicate(true)
    wrong_carry["home"]["holding_id"] = HomeSystem.BUTTON
    expect(not world.restore_validated(wrong_carry), "inconsistent carried-state rejected")
    expect(world.snapshot() == snap, "failed restore leaves active world unchanged")
    # Controlled test setup: force two distressed, resentful siblings into proximity.
    home["sim_steps"] = 5
    home["sibling"]["resentment"] = 90
    home["sibling"]["conflicts"] = 2
    button["x"] = 0.43
    hazel["x"] = 0.43
    button["stress"] = 83
    hazel["stress"] = 85
    button["curiosity"] = 55
    hazel["curiosity"] = 55
    var before_bond: int = int(home["sibling"]["bond"])
    var before_health: int = int(button["health"])
    expect(world.tick_home(), "autonomous conflict tick")
    expect(int(home["sibling"]["conflicts"]) == 3, "sibling conflict emerges from conditions")
    expect(int(home["sibling"]["bond"]) < before_bond, "relationship can deteriorate")
    expect(int(button["health"]) < before_health and bool(button["hurt"]), "physical injury persists")
    expect(world.state["events"].back()["type"] == "home.sibling_conflict", "conflict persists in event history")
    expect(not world.act_with_cub(HomeSystem.BUTTON, "play_together") or home["sibling"]["bond"] < 0, "no automatic happy reconciliation")
    expect(world.act_with_cub(HomeSystem.BUTTON, "separate"), "Mama can intervene to separate")
    expect(world.act_with_cub(HomeSystem.BUTTON, "first_aid"), "Mama can treat a hurt cub")
    expect(not bool(button["hurt"]), "treated injury flag clears")
    # Recovery requires actual conditions; do not force forgiveness.
    home["sibling"]["resentment"] = 25
    button["stress"] = 25
    hazel["stress"] = 25
    var after_conflict_bond: int = int(home["sibling"]["bond"])
    expect(world.act_with_cub(HomeSystem.BUTTON, "play_together"), "cooperative play is possible")
    expect(int(home["sibling"]["bond"]) == after_conflict_bond + 5, "reconciliation is incremental, not magical")
    expect(WorldState.validate_state(world.snapshot()).is_empty(), "conflict and recovery state validates")

    var path := "user://uc_p3_home_test_save.json"
    DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
    DirAccess.remove_absolute(ProjectSettings.globalize_path(path + ".bak"))
    var saved_snapshot: Dictionary = world.snapshot()
    expect(bool(SaveStore.save_document(path, saved_snapshot).get("ok", false)), "P3 home save succeeds")
    expect(world.tick_home(2), "post-save home simulation advances")
    expect(bool(SaveStore.load_into(path, world).get("ok", false)), "P3 save reload succeeds")
    var loaded_snapshot: Dictionary = world.snapshot()
    if loaded_snapshot != saved_snapshot:
        for key in saved_snapshot.keys():
            if loaded_snapshot.get(key) != saved_snapshot[key]:
                print("P3 ROUNDTRIP DIFFERENCE ", key, ": prior=", JSON.stringify(saved_snapshot[key]).substr(0, 320), " after=", JSON.stringify(loaded_snapshot.get(key)).substr(0, 320))
    expect(loaded_snapshot == saved_snapshot, "home relationship, memories and positions round-trip")
    var invalid: Dictionary = saved_snapshot.duplicate(true)
    invalid["home"]["sibling"]["bond"] = -150
    expect(not world.restore_validated(invalid), "invalid sibling bond rejected")
    expect(world.snapshot() == saved_snapshot, "failed P3 restore preserves valid game")
    print("P3 HEADLESS: ", checks, " checks, ", failures.size(), " failures")
    quit(0 if failures.is_empty() else 1)
