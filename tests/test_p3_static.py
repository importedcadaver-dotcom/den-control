"""P3 structural tests. Real GDScript execution occurs separately in CI."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
WORLD = (GAME / "scripts/world/world_state.gd").read_text(encoding="utf-8")
HOME = (GAME / "scripts/home/home_system.gd").read_text(encoding="utf-8")
VIEW = (GAME / "scripts/home/home_view.gd").read_text(encoding="utf-8")
MAIN = (GAME / "scripts/main.gd").read_text(encoding="utf-8")


def test_p3_files_exist():
    assert (GAME / "tests/test_p3.gd").is_file()
    assert "HomeSystem" in WORLD and '"home": HomeSystem.initial_state()' in WORLD
    assert "HomeView.new()" in MAIN
    assert "extends Control" in VIEW


def test_home_state_is_validated_and_saved():
    assert "HomeSystem.valid(candidate.get" in WORLD
    assert "SAVE_VERSION: int = 6" in WORLD  # P4.1 adds repeatable shifts; P3 cubs stay intact
    for key in ["sim_steps", "cubs", "holding_id", "memories", "sibling", "pantry_portions"]:
        assert f'"{key}"' in HOME
    for method in ["act_with_cub", "tick_home", "select_home_cub"]:
        assert f"func {method}" in WORLD


def test_canon_only_characters_and_quadru_pedal_rendering():
    record = json.loads((GAME / "data/canon/characters.json").read_text(encoding="utf-8"))
    names = {c["id"] for c in record["characters"]}
    assert len(names) == 5
    assert names == {"uc.family.mama", "uc.family.button", "uc.family.hazel", "uc.family.grandma", "uc.royal.ursula"}
    assert "_bear(" in VIEW and "for leg in [-22, -9, 7, 17]" in VIEW
    assert '"88c4de"' in VIEW  # real visible tear effect when stressed


def test_cub_autonomy_and_nonforced_relationships():
    assert "func step(" in HOME
    assert "_choose_intention" in HOME
    assert "sibling.dispute" in HOME and "sibling.fight" in HOME
    assert '"bond": 0' in HOME  # user did not approve pre-existing mutual hatred
    assert '"play_together"' in HOME and '"first_aid"' in HOME
    assert '"home.sibling_conflict"' in HOME


def test_no_free_food_or_unapproved_wealth():
    assert 'home["pantry_portions"] = int(home["pantry_portions"]) - 1' in HOME
    assert "Pantry is empty" in HOME
    assert '"balance_hm": null' in WORLD
    assert '"principal_hm": null' in WORLD


def test_ui_is_not_a_false_gate_or_refuge_build():
    assert "P4 WORK IN PROGRESS" in VIEW
    assert "GATE SHIFT TRAINING AVAILABLE" in VIEW
    assert "NO REFUGE SCENES" not in VIEW  # P5 remains unimplemented, but gate now exists
    assert "SaveStore.save_document" in VIEW and "SaveStore.load_into" in VIEW
    assert "Timer.new()" in VIEW


def test_ci_runs_the_new_headless_suite():
    workflow = (ROOT / ".github/workflows/foundation.yml").read_text(encoding="utf-8")
    assert "res://tests/test_p3.gd" in workflow
