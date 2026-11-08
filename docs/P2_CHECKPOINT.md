# Unbearable Conditions — P2 Persistent World Foundation

**Status:** Implemented as Godot 4 GDScript source + test harness; **Godot runtime tests not run in this environment**. This is not a playable game and does not complete P3–P6.

## What P2 implements

- `world_state.gd`: stable canonical characters, households, approved family guardianship links, separate temporary childcare links, independent gate permissions, case records and refuge placements, explicitly scoped guardianship changes, a deterministic day/phase calendar and fixed 3/3/1 work rotation.
- `world_state.gd`: independent Honey Marks household/refuge ledgers with explicit initialization, itemized transactions, no overdrafts and a separate recorded Mafia debt object. Balances, debt terms and exact shift duration start **unset**, avoiding invented economy values.
- `world_state.gd`: day/phase event history with monotonic sequence numbers, no automatic unnamed NPC creation, guard checks for invalid transitions, and a shift timer that can pause during menus/document reading or be disabled.
- `save_store.gd`: version-2 JSON save format, validation before save or restore, temporary-write verification, backup of the preceding valid save and refusal to overwrite an existing corrupt save.
- `test_p2.gd`: headless Godot tests for state, legal continuity, ledger isolation, day/shift behavior, invalid orders, save/load, corrupt saves and backups.
- `tests/test_p2_static.py`: Python structural tests of the actual committed GDScript source and JSON fixtures.

## Important design/authority limits

- P2 has no enacted gate cases, refugee characters or active home scenes. Test cases are artificial QA records; no additional named characters have been created.
- The basis for future guardianship legal orders remains open to future court/welfare design. P2 only requires an explicitly approved, uniquely identified `guardianship`-scoped order; it does not claim a fully simulated legal system.
- The calendar advances in day indices; exact months/day lengths and developmental transitions are not finalized. Starting ages (Mama/Ursula 84 months, cubs 6 months) are stable anchors, not implemented birthday events yet.
- The Queen's biography, party names, district map and the previously rejected cast remain unaffected.
- The old Briarwood v0.1 `button` cub and adult `hazel` are **OLD / BAD / DO NOT USE**; their records never initialize in this model.
- In Godot, serialization of JSON numbers may produce floats; the validator accepts integer-valued JSON numbers but rejects fractions.

## Verification

- Python static tests: **19 passed, 0 failed in the full locally prepared P2 package** (7 P1 preservation checks and 12 P2 structural checks). The GitHub-hosted test subset differs because the full legacy source is delivered in the separate package; CI outcomes are not assumed. These are not gameplay or GDScript runtime tests.
- GDScript headless suite: **not run** because the Godot executable was not available in this environment.
- Windows export / real game launch: **not run**.
- Do not claim this implementation is a finished or playable game. A Godot runtime smoke test and headless P1/P2 test pass are required before using this source as P3's verified foundation.

## Next stage

P3 should build Mama/Button/Hazel home presentation and autonomous behavior **against this single persistent world state**. P4 gate and P5 refuge must call the same legal/case/finance services, not invent parallel scene-local variables. Detailed event stories and new recurring people still require individual user approval.

## GitHub and package verification

The new source is tracked in `game/scripts/world/`, with the foundation tests in `game/tests/test_p2.gd` and `tests/test_p2_static.py`. The connected GitHub commit and the final downloadable ZIP are recorded in the delivery response. No Godot runtime was available; no claimed P2 behavioral pass is inferred from the 19 Python static checks.

## Automated CI configuration

A [foundation verification workflow](../.github/workflows/foundation.yml) was committed for GitHub Actions. On push or manual dispatch it runs Python static checks and attempts to download the official Godot 4.7.2 editor to run both headless Godot tests. **GitHub did not report an executed workflow run during this checkpoint**; no GDScript tests are counted as passed until a run is observed with successful logs. The repository is public and standard GitHub-hosted runners are free for public repositories under GitHub's documented billing policy.

The next verification gate is concrete: see an actual successful headless `test_p1.gd` and `test_p2.gd` run (and a Windows launch smoke test later) before claiming P2 is runtime verified.
