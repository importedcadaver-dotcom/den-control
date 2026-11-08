"""P2 static contract tests. These do NOT execute GDScript; run Godot headless separately."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / 'game'
WORLD = GAME / 'scripts' / 'world' / 'world_state.gd'
SAVE = GAME / 'scripts' / 'world' / 'save_store.gd'


def document(name):
    return json.loads((GAME / 'data' / 'canon' / name).read_text(encoding='utf-8'))


def test_world_modules_and_godot_test_exist():
    assert WORLD.is_file() and SAVE.is_file()
    assert (GAME / 'tests' / 'test_p2.gd').is_file()
    assert 'extends RefCounted' in WORLD.read_text(encoding='utf-8')
    assert 'extends RefCounted' in SAVE.read_text(encoding='utf-8')


def test_p2_does_not_seed_extra_characters():
    data = document('characters.json')
    ids = {p['id'] for p in data['characters']}
    assert len(ids) == len(data['characters']) == 5
    assert ids == {'uc.family.mama', 'uc.family.button', 'uc.family.hazel', 'uc.family.grandma', 'uc.royal.ursula'}
    assert 'button' not in ids and 'hazel' not in ids


def test_approved_work_rotation_kept():
    assert document('work_schedule.json')['work_rotation'] == [
        'gate', 'refuge', 'gate', 'refuge', 'gate', 'refuge', 'off'
    ]


def test_separate_legal_dimensions_in_world_model():
    code = WORLD.read_text(encoding='utf-8')
    for field in ['guardian_links', 'temporary_care', 'legal_orders', 'entry_permissions', 'refuge_placements', 'case_records']:
        assert f'"{field}"' in code
    for action in ['record_entry_decision', 'place_in_refuge', 'change_guardian', 'assign_temporary_care']:
        assert 'func ' + action in code
    assert 'scope", "") != "guardianship"' in code


def test_separate_household_and_public_ledgers():
    code = WORLD.read_text(encoding='utf-8')
    assert '"household": _empty_ledger()' in code
    assert '"refuge": _empty_ledger()' in code
    assert '"opening_balance_hm": null' in code
    assert '"principal_hm": null' in code
    assert '"outstanding_hm": null' in code
    for function in ['configure_opening_balance', 'post_hm', 'configure_debt', 'repay_debt']:
        assert 'func ' + function in code


def test_configured_clock_and_restricted_pause_reasons():
    code = WORLD.read_text(encoding='utf-8')
    assert '"duration_seconds": null' in code
    assert '"menus", "reading_documents"' in code
    for token in ['func pause_shift', 'func tick_shift', 'func start_shift', 'func set_shift_timer_enabled']:
        assert token in code


def test_world_event_sequence_and_deep_snapshot():
    code = WORLD.read_text(encoding='utf-8')
    assert '"next_event_sequence": 1' in code
    assert 'state.duplicate(true)' in code
    assert 'func restore_validated' in code
    assert 'func validate_state' in code


def test_save_version_and_backup_before_rename():
    code = SAVE.read_text(encoding='utf-8')
    assert 'WorldState.validate_state(snapshot)' in code
    assert 'WorldState.validate_state(parsed)' in code
    assert '.tmp' in code and '.bak' in code
    assert code.index('DirAccess.copy_absolute') < code.index('DirAccess.rename_absolute')
    assert 'existing save invalid; refusing overwrite' in code


def test_godot_behavioral_test_covers_key_failures():
    code = (GAME / 'tests' / 'test_p2.gd').read_text(encoding='utf-8')
    for phrase in [
        'legacy IDs excluded', 'no imaginary shift duration',
        'reading pauses timer', 'cannot place without entry authorization',
        'generic case followup cannot change guardian', 'temporary care does not change guardianship',
        'no invented debt principal', 'refuge unaffected by household expense',
        'overdraft rejected', 'corrupt save rejected', 'failed load did not modify active world',
        'backup restored', 'tampered balance rejected'
    ]:
        assert phrase in code


def test_no_legacy_imports_in_active_game():
    for file in GAME.rglob('*'):
        if file.is_file() and file.suffix in {'.gd', '.tscn', '.json', '.godot'}:
            text = file.read_text(encoding='utf-8')
            assert 'res://legacy' not in text
            assert 'BriarwoodRefuge/source/scripts/world.gd' not in text


def test_no_model_time_advance_inside_saving():
    text = SAVE.read_text(encoding='utf-8')
    assert 'advance_day(' not in text
    assert 'tick_shift(' not in text


def test_no_godot_runtime_claim_in_docs():
    report = (ROOT / 'docs' / 'P2_CHECKPOINT.md').read_text(encoding='utf-8')
    assert 'not run' in report.lower() or 'unexecuted' in report.lower()
