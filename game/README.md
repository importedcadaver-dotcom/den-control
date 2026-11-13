# Unbearable Conditions — P6 technical QA prototype

**Working two-day QA loop, not the final authored story game.** In Godot 4.7.2 or the portable Windows QA runner: play with Mama, Button and Hazel in the den; on day one work a gate shift with anonymous training cases; return home, advance to day two; operate the public Briarwood Refuge; return home and save. A third-day gate shift can also start. No new named characters or official Honeyhold laws have been created.

**Windows runner:** Download the [tested QA runner artifact](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996) (Artifacts section). Extract the ZIP and launch PLAY_P6_QA.bat. The official Godot Windows executable is bundled, so a separate editor install is unnecessary. The archive was verified to contain the launcher, executable, source and license. See [P6 playtest checklist](../docs/P6_WINDOWS_PLAYTEST_CHECKLIST.md).

**Verification:** [Linux + Windows Godot 4.7.2, 423 GDScript assertions plus 44 Linux Python checks](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996). These automated headless checks are **not** a visual Windows playtest. P6 uses developer save schema **v7**, with a validated v6→v7 developer-save upgrade. Prior developer schemas are not guaranteed to migrate. The P6 family supervision windows are provisional; no named teacher or Grandma incident is invented.

**Current project instructions (from repository root):**
- Godot editor: open game/project.godot; click Play
- Tests: godot --headless --path game --script res://tests/test_p6.gd
- UI tests: godot --headless --path game --script res://tests/test_p6_ui.gd
- Python: python -m pytest -q tests/

---
## Historical P5 setup notes (superseded by P6)

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

## P4 — Gate workday training

From Mama's home on Day 1, select **Go to gate**. Six anonymous QA visitors have passes, identity records, inquiries and registry checks. The workbench supports a provisional rulebook, authorize/hold/deny decisions with reason selection, a 20-minute **test-only** shift timer (pauses while reading, toggleable off) and save/load of the same persistent world as the home scene. Complete the queue or close early, then return to Mama and the cubs during evening. **These regulations and applicants are not final Honeyhold canon.**

Run with Godot 4.7.2:

    godot --headless --path game --editor --quit
    godot --headless --path game --script res://tests/test_p4.gd
    godot --headless --path game --script res://tests/test_p4_ui.gd
    python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py tests/test_p3_static.py tests/test_p4_static.py

The full P1–P4 suites and main scene startup passed in [Actions run 42534096795](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42534096795). **P5 refuge, full childcare/school schedules and a Windows visual playtest are pending.** The P4 developer save schema is version **4**; no previous P3 developer-save migration is promised.


## P5 — Refuge day, QA mode only

After completing the day-one gate shift, return home and advance to Day 2 (refuge duty). Click **Go to refuge** in the home sidebar. Briarwood Refuge uses the same persistent characters, case records, entry permissions, home state and financial ledgers as the gate.

- Select an **authorized anonymous QA entrant** and admit them only if a separate refuge bed is available. Gate entry alone is not residence, guardianship or legal custody.
- QA starts with one bed and zero supply stock. Press **Seed QA budget 80 HM** to explicitly initialize a **provisional public test budget**. None of these prices, supplies or bed limits are approved Honeyhold economy.
- Buy food, medicine, blankets or additional beds using the **public refuge** ledger (not Mama's private household funds).
- Select a resident and feed, comfort, rest or treat them. Needs update and persist, and a resident's simple autonomous needs continue while the refuge screen is open.
- Finish the refuge shift, return home with the same two cubs, and save/load.
- The full two-day production release, Windows visual review, school/Grandma offscreen activities and authentic individually authored recurring refugee story remain future work.

To verify using Godot 4.7.2 and Python (from repository root):

    python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py tests/test_p3_static.py tests/test_p4_static.py tests/test_p41_static.py tests/test_p5_static.py
    godot --headless --path game --editor --quit
    godot --headless --path game --script res://tests/test_p41.gd
    godot --headless --path game --script res://tests/test_p5.gd
    godot --headless --path game --script res://tests/test_p5_ui.gd

[Verified GitHub Actions run](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42747344337): P1–P5 headless and Python passed. Current developer-save schema is **6**, without an automatic migration promise for older developer saves.
