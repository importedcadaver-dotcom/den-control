# Unbearable Conditions — P1 Godot shell

This is **a clean Godot 4.7.2 project foundation, not the first playable milestone**.
It never imports the archived Briarwood v0.1 world script.

With Godot installed, run:

    godot --headless --path game --script res://tests/test_p1.gd
    godot --path game

A Python static contract suite can run without the Godot engine:

    python -m pytest -q tests/test_p1_static.py

See [Production Plan](../docs/PRODUCTION_PLAN_V0_1.md) and [P1 checkpoint](../docs/P1_CHECKPOINT.md). 
The old v0.1 IDs "button" and "hazel" are explicitly excluded. The new IDs are "uc.family.button" and "uc.family.hazel".
