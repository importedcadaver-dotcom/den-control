# Unbearable Conditions — P3 Home Sandbox

**A small interactable home scene**, not the complete game or the two-day gate/refuge/family release.

Start with Godot 4.7.2:

    godot --path game

Controls: select Button or Hazel with sidebar tabs or click the cub, choose an interaction (feed, cuddle, play, wash, pick up, put down, tidy request, first aid, separate, or play together). Autonomous behavior advances at a fixed sandbox rate; pause/resume in the sidebar. Save and load from the local user data directory. Pressing save records persistent needs, memories, sibling relationships and location.

Some actions can fail or be refused; the feedback field explains why. The P3 pantry has six **demo** portions so feeding is not a free infinite resource. The production economy is still unconfigured.

Run verification:

    python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py tests/test_p3_static.py
    godot --headless --path game --editor --quit
    godot --headless --path game --script res://tests/test_p1.gd
    godot --headless --path game --script res://tests/test_p2.gd
    godot --headless --path game --script res://tests/test_p3.gd
    godot --headless --path game --quit-after 12

All three GDScript headless suites, the headless editor import, and main-scene boot **passed** in [GitHub Actions run 42527012709](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42527012709): P1 7/7, P2 56/56, P3 67/67; 24 GitHub Python checks passed (26 in the complete local package). This is not a Windows human playtest. The first production milestone still requires playable gate and refuge shifts.

The legacy Godot v0.1 cub named Button and adult bear Hazel are **OLD / BAD / DO NOT USE**. Only the newly approved family records are loaded.
