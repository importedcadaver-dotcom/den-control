from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "game"

def read(path):
    return (ROOT / path).read_text(encoding="utf-8")

def test_refuge_is_world_owned():
    world = read("scripts/world/world_state.gd")
    assert 'RefugeSystem.initial_state()' in world
    assert 'RefugeSystem.validate(candidate.get("refuge", null), candidate)' in world
    assert "func admit_refuge_subject" in world

def test_public_funds_and_capacity():
    refuge = read("scripts/refuge/refuge_system.gd")
    assert 'world.post_hm("refuge"' in refuge
    assert 'int(r["bed_count"])' in refuge
    assert '"qa_only": true' in refuge
    assert 'entry.get("case_id", "") != case_id' in refuge

def test_care_and_autonomous_residents():
    refuge = read("scripts/refuge/refuge_system.gd")
    for action in ('"feed"', '"comfort"', '"rest"', '"treat"'):
        assert action in refuge
    assert 'static func tick(' in refuge
    assert '"refuge.care"' in refuge

def test_ui_navigation():
    home = read("scripts/home/home_view.gd")
    main = read("scripts/main.gd")
    assert "signal request_refuge" in home
    assert "request_refuge.connect(_show_refuge)" in main
    assert "RefugeView.new()" in main
    assert (ROOT / "scripts/refuge/refuge_view.gd").is_file()

def test_headless_qa_tests_present():
    assert (ROOT / "tests/test_p5.gd").is_file()
    assert (ROOT / "tests/test_p5_ui.gd").is_file()
