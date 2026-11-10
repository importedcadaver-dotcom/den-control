extends SceneTree
const WorldState = preload("res://scripts/world/world_state.gd")
const SaveStore = preload("res://scripts/world/save_store.gd")
var checks := 0
var failures: Array[String] = []
func expect(ok: bool, description: String) -> void:
    checks += 1
    if not ok:
        failures.append(description)
        push_error(description)
func _initialize() -> void:
    var w = WorldState.new()
    expect(WorldState.validate_state(w.snapshot()).is_empty(), "initial P4.1 state valid")
    expect(w.begin_gate(), "first gate day opens")
    var first: Dictionary = w.state["gate"]
    var ticket: Dictionary = first["queue"][3]
    var party: Array = ticket["participant_ids"]
    expect(party.size() == 2 and party[0] != party[1], "adult and cub separate IDs")
    expect(w.has_character(party[1]), "cub is independent record")
    expect(w.state["characters"][party[1]]["registered_case_id"] == ticket["case_id"], "case membership")
    expect(not w.state["guardian_links"].has(party[1]), "no invented guardian")
    var adult: String = first["queue"][0]["subject_id"]
    expect(w.decide_gate("authorized", "valid_pass"), "authorized first arrival")
    expect(not w.place_in_refuge(adult, first["queue"][1]["case_id"]), "unrelated case blocked")
    expect(w.state["refuge_placements"].is_empty(), "no unauthorized placement")
    expect(w.decide_gate("denied", "expired_pass"), "expired pass denied")
    expect(w.decide_gate("held", "identity_unverified"), "unverified evidence may be held")
    expect(first["decisions"][2]["verified"].is_empty(), "hold did not forge verification")
    expect(w.decide_gate("held", "guardian_unverified"), "minor-care case held")
    expect(w.state["entry_permissions"][party[1]]["status"] == "held", "cub individual status")
    var altered: Dictionary = w.snapshot()
    altered["case_records"][ticket["case_id"]]["gate_training_result"]["status"] = "authorized"
    expect(not WorldState.validate_state(altered).is_empty(), "copied outcome tampering rejected")
    altered = w.snapshot()
    altered["gate"]["fixture_snapshot"][0]["expected_status"] = "denied"
    expect(not WorldState.validate_state(altered).is_empty(), "QA historical evidence tampering rejected")
    expect(w.finish_gate(true), "early end archives unfinished cases")
    expect(w.advance_day(), "advance to refuge duty")
    expect(w.current_duty() == "refuge", "next day refuge")
    expect(w.change_phase("daytime"), "refuge daytime")
    expect(w.change_phase("evening"), "refuge evening")
    expect(w.advance_day(), "advance to next gate day")
    expect(w.current_duty() == "gate", "third day gate")
    expect(w.begin_gate(), "second gate shift starts")
    var current: Dictionary = w.state["gate"]
    expect(current["history"].size() == 1, "previous gate shift archived")
    expect(current["history"][0]["shift_day"] == 0, "archive date preserved")
    expect(current["queue"][0]["case_id"] != first["queue"][0]["case_id"], "new case IDs")
    expect(w.state["case_records"].has(first["queue"][0]["case_id"]), "old case persisted")
    var steps: int = int(w.state["home"]["sim_steps"])
    expect(w.tick_shift(91.0), "advance world simulation during shift")
    expect(int(w.state["home"]["sim_steps"]) > steps, "cub simulation continues offscreen")
    expect(w.pause_shift("reading_documents", true), "document pause")
    steps = int(w.state["home"]["sim_steps"])
    expect(w.tick_shift(91.0) and int(w.state["home"]["sim_steps"]) == steps, "reading pauses world simulation")
    expect(w.pause_shift("reading_documents", false), "document resumed")
    expect(WorldState.validate_state(w.snapshot()).is_empty(), "multiple shifts state valid")
    var path := "user://uc_p41_test.json"
    DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
    expect(bool(SaveStore.save_document(path, w.snapshot()).get("ok", false)), "save multiple shifts")
    var loaded = WorldState.new()
    expect(bool(SaveStore.load_into(path, loaded).get("ok", false)), "restore multiple shifts")
    expect(loaded.state["gate"]["history"].size() == 1, "archive survived save")
    print("P4.1 HEADLESS: ", checks, " checks, ", failures.size(), " failures")
    quit(0 if failures.is_empty() else 1)
