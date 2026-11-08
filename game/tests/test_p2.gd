extends SceneTree
## Run: godot --headless --path game --script res://tests/test_p2.gd
const WorldState = preload("res://scripts/world/world_state.gd")
const SaveStore = preload("res://scripts/world/save_store.gd")

var checks := 0
var failures: Array[String] = []

func expect(test: bool, label: String) -> void:
    checks += 1
    if not test:
        failures.append(label)
        push_error(label)

func _initialize() -> void:
    var world = WorldState.new()
    var initial: Dictionary = world.snapshot()
    expect(WorldState.validate_state(initial).is_empty(), "valid initial world")
    expect(initial["characters"].size() == 5, "only approved people initialized")
    expect(not initial["characters"].has("button") and not initial["characters"].has("hazel"), "legacy IDs excluded")
    expect(world.current_duty() == "gate", "first duty is gate")
    expect(not world.advance_day(), "cannot skip directly to next day")
    expect(world.change_phase("daytime"), "enter daytime")
    expect(not world.start_shift(), "no imaginary shift duration")
    expect(world.configure_shift_duration(600), "test-only shift duration")
    expect(world.start_shift(), "start configured gate shift")
    expect(world.pause_shift("reading_documents", true), "pause during reading")
    expect(world.tick_shift(50.0) and float(world.state["shift_clock"]["elapsed_seconds"]) == 0.0, "reading pauses timer")
    expect(world.pause_shift("reading_documents", false), "unpause reading")
    expect(world.tick_shift(10.0) and float(world.state["shift_clock"]["elapsed_seconds"]) == 10.0, "shift advances")
    world.set_shift_timer_enabled(false)
    expect(world.tick_shift(50.0) and float(world.state["shift_clock"]["elapsed_seconds"]) == 10.0, "disabled timer does not advance")
    expect(world.change_phase("evening"), "evening after work")
    expect(world.advance_day(), "advance at evening")
    expect(world.current_duty() == "refuge", "day two is refuge")
    expect(int(world.state["characters"]["uc.family.button"]["age_months"]) == 6, "age anchor not arbitrarily rounded")

    expect(world.register_case("qa.case1", {"purpose": "test fixture"}), "case registered")
    world.enable_qa_mode()
    expect(world.register_qa_subject("uc.qa.visitor_a", "qa.case1"), "anonymous test subject registered")
    expect(not world.place_in_refuge("uc.qa.visitor_a", "qa.case1"), "cannot place without entry authorization")
    expect(world.record_entry_decision("uc.qa.visitor_a", "authorized", "qa.case1"), "entry authorization")
    expect(world.place_in_refuge("uc.qa.visitor_a", "qa.case1"), "separate refuge placement")
    expect(not world.record_entry_decision("uc.qa.visitor_a", "denied", "qa.case1"), "cannot deny while resident placed")
    expect(world.state["guardian_links"]["uc.family.button"]["guardian_id"] == "uc.family.mama", "placement did not change guardian")
    expect(not world.change_guardian("uc.family.button", "uc.family.grandma", {"id":"qa.order", "scope":"case_followup", "approved":true}), "generic case followup cannot change guardian")
    expect(world.change_guardian("uc.family.button", "uc.family.grandma", {"id":"qa.order", "scope":"guardianship", "approved":true}), "explicit guardianship order")
    expect(world.state["guardian_links"]["uc.family.button"]["guardian_id"] == "uc.family.grandma", "guardian changed only by order")
    expect(not world.change_guardian("uc.family.button", "uc.family.mama", {"id":"qa.order", "scope":"guardianship", "approved":true}), "order cannot be replayed")
    expect(world.assign_temporary_care("uc.family.hazel", "uc.family.grandma", "qa.schedule"), "care assigned separately")
    expect(world.state["guardian_links"]["uc.family.hazel"]["guardian_id"] == "uc.family.mama", "temporary care does not change guardianship")

    expect(world.state["financials"]["ledgers"]["household"]["balance_hm"] == null, "no invented money")
    expect(world.state["financials"]["mafia_debt"]["outstanding_hm"] == null, "no invented debt principal")
    expect(world.configure_opening_balance("household", 200), "configure test household money")
    expect(world.configure_opening_balance("refuge", 500), "configure test refuge money")
    expect(world.post_hm("household", -15, "qa food"), "household expense")
    expect(world.state["financials"]["ledgers"]["refuge"]["balance_hm"] == 500, "refuge unaffected by household expense")
    expect(not world.post_hm("household", -10000, "qa overdraft"), "overdraft rejected")
    expect(world.configure_debt(100, 0, 7), "provisional test debt")
    expect(world.repay_debt(20), "debt paid from household only")
    expect(world.state["financials"]["mafia_debt"]["outstanding_hm"] == 80, "debt reduced")
    expect(world.state["financials"]["ledgers"]["refuge"]["balance_hm"] == 500, "debt never uses public funds")
    expect(WorldState.validate_state(world.snapshot()).is_empty(), "post-action world reconciles")

    var save_path := "user://uc_p2_test_save.json"
    DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
    DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path + ".bak"))
    var first: Dictionary = SaveStore.save_document(save_path, world.snapshot())
    expect(bool(first.get("ok", false)), "first save committed")
    expect(world.post_hm("refuge", -5, "qa supplies"), "second transaction")
    var second: Dictionary = SaveStore.save_document(save_path, world.snapshot())
    expect(bool(second.get("ok", false)), "second save committed")
    expect(FileAccess.file_exists(save_path + ".bak"), "previous save backed up")
    var before: Dictionary = world.snapshot()
    var broken := FileAccess.open(save_path, FileAccess.WRITE)
    broken.store_string("{not valid JSON")
    broken.close()
    expect(not bool(SaveStore.load_into(save_path, world).get("ok", false)), "corrupt save rejected")
    expect(world.snapshot() == before, "failed load did not modify active world")
    var recovered: Dictionary = SaveStore.load_into(save_path + ".bak", world)
    expect(bool(recovered.get("ok", false)), "backup restored")
    expect(world.state["financials"]["ledgers"]["refuge"]["balance_hm"] == 500, "backup has prior balance")
    var tampered: Dictionary = world.snapshot()
    tampered["financials"]["ledgers"]["household"]["balance_hm"] = 999999
    expect(not world.restore_validated(tampered), "tampered balance rejected")
    var invalid_entry: Dictionary = world.snapshot()
    invalid_entry["entry_permissions"]["uc.qa.visitor_a"] = "malformed entry"
    expect(not WorldState.validate_state(invalid_entry).is_empty(), "malformed nested entry rejected without crashing")
    var fractional_day: Dictionary = world.snapshot()
    fractional_day["calendar"]["day_index"] = 1.5
    expect(not WorldState.validate_state(fractional_day).is_empty(), "fractional calendar day rejected")
    var fake_clock: Dictionary = world.snapshot()
    fake_clock["shift_clock"]["duration_seconds"] = -1
    expect(not WorldState.validate_state(fake_clock).is_empty(), "invalid shift duration rejected")
    expect(not bool(SaveStore.load_document("user://missing_p2_file.json").get("ok", false)), "missing save rejected")
    print("P2 HEADLESS: ", checks, " checks, ", failures.size(), " failures")
    quit(0 if failures.is_empty() else 1)
