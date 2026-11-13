"""P6 QA integration contracts. GDScript behavior runs in engine CI."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"

def source(path):
    return (GAME / path).read_text(encoding="utf-8")

def test_family_schedule_and_dev_upgrade():
    family = source("scripts/world/family_schedule.gd")
    world = source("scripts/world/world_state.gd")
    store = source("scripts/world/save_store.gd")
    assert 'FamilySchedule.initial_state()' in world
    assert 'FamilySchedule.validate(candidate.get("family_schedule", null), candidate)' in world
    assert "QA_HALF_SHIFT_SECONDS := 600.0" in family
    assert 'Grandma' not in family or '"uc.family.grandma"' in family
    assert "WorldState.upgrade_dev_v6(parsed)" in store
    assert "SAVE_VERSION: int = 7" in world

def test_refuge_actions_need_real_shift():
    source_text = source("scripts/refuge/refuge_system.gd")
    assert "static func _active_operations(" in source_text
    assert source_text.count("not _active_operations(world)") >= 3

def test_shared_worldtime_and_family_readout():
    world = source("scripts/world/world_state.gd")
    home = source("scripts/home/home_view.gd")
    assert "FamilySchedule.begin_shift(self)" in world
    assert "FamilySchedule.advance(self)" in world
    assert "FamilySchedule.finish_shift(self)" in world
    assert "Care schedule (QA)" in home

def test_actual_p6_engine_suites_in_ci():
    workflow = (ROOT / ".github/workflows/foundation.yml").read_text()
    for item in ["res://tests/test_p6.gd", "res://tests/test_p6_ui.gd"]:
        assert item in workflow
    assert (GAME / "tests/test_p6.gd").exists()
    assert (GAME / "tests/test_p6_ui.gd").exists()
