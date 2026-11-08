# P2 Test Report — November 8, 2026

## Performed now

- Python 3.13.5 / pytest 9.0.2.
- Source integrity, P1 baseline fixtures, P2 schema markers, legal/financial separation, active-code legacy exclusion, presence of Godot behavioral regressions and save API guards.
- Result from `python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py` in the complete P2 package: **19 passed, 0 failed**.
- P2 ZIP archive integrity: passed (`zipfile.testzip() is None`).

## Not performed

- **GitHub Actions, Ubuntu hosted runner, Godot 4.7.2 official**: project headless import succeeded; P1 **7 checks, 0 failures**; P2 **56 checks, 0 failures** on the latest verified code commit. See [successful run 42522146379](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42522146379).
- GitHub Python CI: **17 passed** (the repo subset; the local full-source package has 19).
- **Windows export and interactive gameplay** have **not** been run. This is still an engineering foundation, not the first playable game.

## Prepared regression scenarios in `game/tests/test_p2.gd`

- Canonical five-person world, unique identities, no old Button/Hazel records.
- Correct gate/refuge rotation, phase guards, shift duration unset until configured, pause and unlimited-timer setting.
- Anonymous QA case, gate clearance separate from refuge placement.
- Invalid case follow-up cannot override guardianship; authorized specific order can; duplicate orders rejected.
- Grandma temporary care never changes the legal maternal guardian by itself.
- No invented cash/debt values; money accounts isolated; overdraft rejected; debt repayment affects household money only.
- Save verification, previous-save backup, corrupt-save rejection, active state unchanged after failed load, and tampered balance detection.

## Result classification

**P2 source and Linux Godot headless tests verified (56/56 P2, 7/7 P1); Windows build and gameplay unverified. Not a playable game.**

## GitHub CI workflow

`.github/workflows/foundation.yml` provides Python static and official Godot 4.7.2 headless jobs. The workflow is committed to the connected public GitHub repository. After the initial check, GitHub completed real Python and Godot jobs successfully; see the linked run above.
