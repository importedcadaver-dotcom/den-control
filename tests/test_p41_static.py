from pathlib import Path
GAME = Path(__file__).resolve().parents[1] / "game"
def src(path):
    return (GAME / path).read_text(encoding="utf-8")
def test_date_scoped_gate():
    g = src("scripts/gate/gate_system.gd")
    assert '"history"' in g and 'archived.erase("history")' in g
def test_independent_party_and_case():
    g = src("scripts/gate/gate_system.gd")
    w = src("scripts/world/world_state.gd")
    assert 'participants.append(subject_id + ".cub")' in g
    assert '"registered_case_id": case_id' in w
    assert 'entry.get("case_id", "") != case_id' in w
def test_fixture_snapshots_and_copied_decision():
    g = src("scripts/gate/gate_system.gd")
    assert '"fixture_snapshot"' in g and '"fixture_digest"' in g
    assert "JSON.stringify(stored) != JSON.stringify(result)" in g
def test_offscreen_cubs():
    w = src("scripts/world/world_state.gd")
    assert "func advance_world_time(" in w
    assert "advance_world_time(step)" in w
    assert "step = minf(seconds" in w  # do not advance beyond an expired shift
def test_repeat_day_ui():
    assert '"shift_day"]) != int(world.state["calendar"]["day_index"])' in src("scripts/main.gd")
    assert '"shift_day"]) == int(world.state["calendar"]["day_index"])' in src("scripts/home/home_view.gd")
