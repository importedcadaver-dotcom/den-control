# Unbearable Conditions — P2 persistent world foundation

This is a **Godot 4.7.2 data-model foundation**, not the first playable milestone.
The start scene displays its validated world status only.

## Test commands

From repository root (after installing Godot 4.7.2 and Python with pytest):

    godot --headless --path game --script res://tests/test_p1.gd
    godot --headless --path game --script res://tests/test_p2.gd
    python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py

The local container did not have Godot, but [GitHub Actions successfully executed](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42522146379) Godot 4.7.2 headless: P1 7/7 checks, P2 56/56 checks. The Python checks only validate static contracts and structure; they are not a substitute for GDScript or Windows gameplay tests.

## Foundation modules

- `scripts/foundation/canon_loader.gd` — approved characters and schedule JSON.
- `scripts/world/world_state.gd` — state registry, legal/temporary care, case/entry/refuge, HM finance, calendar, clock and event history.
- `scripts/world/save_store.gd` — versioned JSON save and restore with validation and backup.
- `tests/test_p2.gd` — real Godot behavioral tests to run on target machine.

No new recurring characters are initialized. The v0.1 legacy Button/Hazel are **OLD / BAD / DO NOT USE**.
Only the five established individuals appear at reset. Anonymous QA fixtures can be created in explicit test mode and have no names.
