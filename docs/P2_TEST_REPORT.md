# P2 Test Report — November 8, 2026

## Performed now

- Python 3.13.5 / pytest 9.0.2.
- Source integrity, P1 baseline fixtures, P2 schema markers, legal/financial separation, active-code legacy exclusion, presence of Godot behavioral regressions and save API guards.
- Result from `python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py` in the complete P2 package: **19 passed, 0 failed**.
- P2 ZIP archive integrity: passed (`zipfile.testzip() is None`).

## Not performed

- Godot GDScript parse, headless P1/P2 behavior tests, UI scenes, Windows export and interactive playtest: **not run**, because Godot is unavailable in this environment.
- Thus these static tests do not prove the 40+ GDScript behavioral assertions pass. They are intentionally not counted as gameplay-tested features.

## Prepared regression scenarios in `game/tests/test_p2.gd`

- Canonical five-person world, unique identities, no old Button/Hazel records.
- Correct gate/refuge rotation, phase guards, shift duration unset until configured, pause and unlimited-timer setting.
- Anonymous QA case, gate clearance separate from refuge placement.
- Invalid case follow-up cannot override guardianship; authorized specific order can; duplicate orders rejected.
- Grandma temporary care never changes the legal maternal guardian by itself.
- No invented cash/debt values; money accounts isolated; overdraft rejected; debt repayment affects household money only.
- Save verification, previous-save backup, corrupt-save rejection, active state unchanged after failed load, and tampered balance detection.

## Result classification

**P2 code written and committed. Static checks pass. Godot runtime verification is outstanding. Not a playable game.**

## CI status

The workflow file `.github/workflows/foundation.yml` is present on `main` and defines both Python static and Godot 4.7.2 headless verification. At report time GitHub returned **zero workflow runs**, so CI completion and GDScript pass/fail are **unknown**. A workflow definition is not test evidence.
