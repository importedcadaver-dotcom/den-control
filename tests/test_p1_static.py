import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


def read(name):
    return json.loads((GAME / "data" / "canon" / name).read_text(encoding="utf-8"))


def test_shell_files():
    project = (GAME / "project.godot").read_text(encoding="utf-8")
    scene = (GAME / "scenes" / "main.tscn").read_text(encoding="utf-8")
    assert 'run/main_scene="res://scenes/main.tscn"' in project
    assert 'path="res://scripts/main.gd"' in scene
    assert (GAME / "scripts" / "main.gd").is_file()
    assert (GAME / "scripts" / "foundation" / "canon_loader.gd").is_file()
    assert (GAME / "tests" / "test_p1.gd").is_file()


def test_only_approved_characters():
    data = read("characters.json")
    assert data["schema_version"] == 1
    roster = data["characters"]
    ids = {item["id"] for item in roster}
    assert len(roster) == len(ids) == 5
    assert ids == {
        "uc.family.mama", "uc.family.button", "uc.family.hazel",
        "uc.family.grandma", "uc.royal.ursula",
    }
    assert data["excluded_legacy_ids"] == ["button", "hazel"]


def test_family_ids_ages_and_unknowns():
    c = {item["id"]: item for item in read("characters.json")["characters"]}
    assert c["uc.family.mama"]["age_months"] == 84
    for who, other in (("button", "hazel"), ("hazel", "button")):
        cub = c["uc.family." + who]
        assert cub["age_months"] == 6
        assert cub["mother_id"] == "uc.family.mama"
        assert cub["littermate_id"] == "uc.family." + other
    grandma = c["uc.family.grandma"]
    assert grandma["personal_name_approved"] is False
    assert grandma["age_months"] is None
    assert c["uc.royal.ursula"]["age_months"] == 84
    assert c["uc.royal.ursula"]["coronation_age_months"] == 6


def test_week_and_clock_canon():
    c = read("work_schedule.json")
    assert c["work_rotation"] == ["gate", "refuge", "gate", "refuge", "gate", "refuge", "off"]
    assert c["school"]["half_day"] is True
    assert c["time_policy"]["per_case_timer"] is False
    assert c["time_policy"]["timer_off_setting"] is True
    assert set(c["time_policy"]["pause_during"]) == {"reading_documents", "menus"}


def test_no_legacy_source_imports():
    for path in GAME.rglob("*"):
        if not path.is_file() or path.suffix not in {".gd", ".tscn", ".godot", ".json"}:
            continue
        contents = path.read_text(encoding="utf-8")
        assert "res://legacy" not in contents
        assert "BriarwoodRefuge/source/scripts/world.gd" not in contents
