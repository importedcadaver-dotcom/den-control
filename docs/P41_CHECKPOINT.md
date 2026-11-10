# Unbearable Conditions — P4.1 gate integration hardening

P4.1 source implementation adds:
- Date-keyed repeatable gate days and completed-shift archives.
- Separate anonymous QA adult/cub records, with no presumed guardianship.
- Applicant-case ownership checks for legal entry and placement.
- Versioned historical QA evidence snapshots with digests.
- Full copied-result integrity comparison and party legal outcome checks.
- Atomic rollback if shift setup fails.
- Reasoned HOLD when investigation remains incomplete.
- Separate adult/cub quadrupedal display in training.
- Shared offscreen cub simulation during active, unpaused work (care coverage **unresolved_schedule**; no Grandma incidents fabricated).

Python structural suite and headless Godot P1–P4.1 regressions are required before P5.
The P4.1 schema is v5 (dev saves before v5 have no migration promise).
No new named characters, final Honeyhold laws, money amounts, or P5 gameplay introduced.


## Verified execution

[Godot CI run 42747344337](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42747344337) completed successfully after the P4.1 gate state and P5 prior-day gate validation fixes. **P4.1: 37/37 headless Godot checks passed.** Python static test suite also passed. The first P4.1 CI attempt failed because the old test expected six QA subjects even after an additional independent cub record was introduced; the test was updated to reflect the new individual identity. The prior-day gate validation issue only surfaced during P5 and was repaired there. No new canon characters were created.
