"""P4 code and QA data contracts. These do not replace running Godot."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


def source(path):
    return (GAME / path).read_text(encoding="utf-8")


def fixture():
    return json.loads(source("data/qa/gate_training_cases.json"))


def test_p4_source_layout():
    for name in ["scripts/gate/gate_system.gd", "scripts/gate/gate_view.gd", "tests/test_p4.gd"]:
        assert (GAME / name).is_file(), name
    assert 'GateSystem = preload("res://scripts/gate/gate_system.gd")' in source("scripts/world/world_state.gd")
    assert 'GateView = preload("res://scripts/gate/gate_view.gd")' in source("scripts/main.gd")
    assert "request_gate" in source("scripts/home/home_view.gd")


def test_training_is_not_fictional_canon():
    data = fixture()
    assert "not approved Honeyhold law" in data["notice"]
    assert data["fixture_version"] == 1
    cases = data["cases"]
    assert len(cases) == 6
    assert len({c["code"] for c in cases}) == len(cases)
    assert sum(c["type"] == "routine" for c in cases) >= 2
    assert sum(c["type"] == "investigation" for c in cases) >= 2
    assert all(c["subject"].startswith("Anonymous") for c in cases)
    assert all(c["pass_name"].startswith("TEST SUBJECT") for c in cases)
    assert "Mara" not in json.dumps(data) and "Pip" not in json.dumps(data)


def test_gate_case_training_contracts():
    data = fixture()
    reason_values = {r["code"] for r in data["reasons"]}
    assert len(reason_values) == 5
    for case in data["cases"]:
        assert case["expected_status"] in {"held", "denied", "authorized"}
        assert case["expected_reason"] in reason_values
        assert case["requires_check"] in {"", "registry", "guardian"}
        assert all(k in case for k in ["questions", "registry_response", "guardian_response", "photo_matches", "pass_valid_until_day"])
    assert any(c["accompanied_minor"] for c in data["cases"])
    assert any(c["expected_reason"] == "registry_exception" for c in data["cases"])


def test_p4_safety_and_world_integration():
    gate = source("scripts/gate/gate_system.gd")
    world = source("scripts/world/world_state.gd")
    assert "register_qa_subject" in gate and "world.enable_qa_mode()" in gate
    assert "world.record_entry_decision" in gate
    assert "world.place_in_refuge(" not in gate
    assert "world.change_guardian(" not in gate
    assert '"gate": GateSystem.initial_state()' in world
    assert 'GateSystem.validate(candidate.get("gate", null), candidate)' in world
    assert "const SAVE_VERSION: int = 4" in world
    assert '"mama"' not in gate.lower() or 'Mama' not in gate  # No invented family-based case outcomes


def test_timer_and_decision_reasons():
    view = source("scripts/gate/gate_view.gd")
    gate = source("scripts/gate/gate_system.gd")
    assert "world.pause_shift" in gate
    assert '"reading_documents"' in gate
    assert 'QA_SHIFT_SECONDS := 1200' in gate  # QA-only provisional, not canon
    assert "world.set_shift_timer_enabled" in view
    assert "world.decide_gate(status, reason)" in view
    assert "decision_reason = OptionButton.new()" in view
    assert "status == ticket[\"expected_status\"]" in gate


def test_p3_home_still_attached_and_saves_unified():
    main = source("scripts/main.gd")
    home = source("scripts/home/home_view.gd")
    gate = source("scripts/gate/gate_view.gd")
    assert "HomeView.new()" in main and "GateView.new()" in main
    assert 'user://uc_p4_dev.json' in home and 'user://uc_p4_dev.json' in gate
    assert "world.advance_day()" in home
    assert "GateSystem.initial_state" in source("scripts/world/world_state.gd")
