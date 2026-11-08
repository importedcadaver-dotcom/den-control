# Unbearable Conditions — P4 Gate Workday Checkpoint

**Stage:** P4 gate workday, on top of existing P2 persistent world and P3 home sandbox.
**Status:** Source implemented. Static tests passed locally; Godot headless/scene tests pending GitHub Actions verification at first commit. Not a Windows export or completed P6 two-day playable slice.

## Scope delivered

- `game/scripts/gate/gate_system.gd`: authoritative queue and shift lifecycle, dialogue/question records, registry/guardian checks, entry decisions with required reasons and training audits, early-shift/timeout handling, event logs, and independent legal entry permissions.
- `game/scripts/gate/gate_view.gd`: playable procedural gate desk, visible quadrupedal anonymous visitors, pass/identity/guardian documents, tangible paper/stamp presentation, training rulebook, reason selection, question/verification controls and a shift timer toggle.
- `game/data/qa/gate_training_cases.json`: six **anonymous QA fixtures** (three routine, three investigative), covering a valid pass, expired pass, portrait mismatch, minor travelling without verified care authorization, another valid arrival and a registry-confirmed exception.
- `game/scripts/main.gd`: the **same** P2 WorldState instance is shared between P3 home and P4 gate screens. Completing the gate shift returns to evening at Mama's home, where the existing cub needs/relationships persist.
- `game/scripts/world/world_state.gd`: P4 gate state becomes part of version-4 world snapshots, with save validation and thin methods delegating gate actions to GateSystem.
- `game/tests/test_p4.gd`: behavioral regression tests of questions, documents, timers, case outcomes, legal separation, custody safety, saves, replays, provenance and tamper rejection.
- `game/tests/test_p4_ui.gd`: direct Godot scene-interaction smoke test of home → gate → questions/documents → decision → home.
- `tests/test_p4_static.py` and `.github/workflows/foundation.yml`: new static and Godot CI tests.

## Core invariants

1. **No invented canonical people.** The first five approved people are untouched. P4 arrivals have blank display names and IDs under `uc.qa.`; test fixtures are explicitly not authorized Honeyhold NPCs.
2. **No new canon laws.** QA-R1 through QA-R5 are *training rules*, not final Honeyhold statutes. They can be replaced later with individually approved legal content.
3. **No automatic refuge or custody.** A gate authorization only updates `entry_permissions`. A hold or denial also does not change guardian links or move a character into Briarwood.
4. **Reasoned decisions.** Players inspect pass/ID details, question applicants and consult verification sources, select a reason and authorize/hold/deny. Training audit marks correct and incorrect decisions without rewriting the player's action.
5. **One shift timer, no visitor timers.** Prototype duration 1,200 seconds is **provisional test tuning**, not approved canon. Document/rulebook viewing pauses the shift timer; an off switch provides unlimited time.
6. **Persistent consequences.** A case is recorded under its stable QA identity; decisions, verification, event history and legal statuses survive saving and loading. Invalid/tampered state is rejected.
7. **Legacy excluded.** Original Godot v0.1 `button` and `hazel` records are **OLD / BAD / DO NOT USE**. The new family uses only `uc.family.button` and `uc.family.hazel`.

## Important limitations

- These are **anonymous training applicants**, not the first authored Honeyhold recurring family. The proper story cases still need individual user approval of any characters involved.
- The rulebook is a provisional QA mechanism. It is not a finalized legal system and doesn't include the full political or emergency-order simulation.
- P4 does not simulate school or Grandma's childcare while Mama is at the gate. The P3 home behavior state remains saved, but **offscreen cub needs are not advanced during this shift**; the P6 schedule/childcare integration must resolve this.
- P4 doesn't include wages, loan servicing, refugee placement decisions, detailed city travel, a production soundscape or P5 refuge-management gameplay. No Honey Marks balance or new debt amount is made up.
- P3→P4 raised the **developer save schema from v3 to v4**; previous P3 development saves do not have a promised migration path. The original full legacy source remains preserved separately.
- The procedural gate UI uses a preliminary 960×540 layout. It needs visual review at ordinary Windows resolutions for readable documents, scrolling and art consistency.
- No claim of Windows executable launch or user-visible manual playtest is made here.

## Acceptance checklist

- [x] P4 game source, UI, QA fixtures and tests authored.
- [x] 32 Python structural tests passed on this local source bundle (P1–P4).
- [ ] GitHub Godot import, P1/P2/P3 regression tests, P4 behavioral tests and P4 UI interaction script all pass (verify live Actions run after commit).
- [ ] Windows interactive test confirms desk readability, reasonable timing, no overlapping controls, and meaningful visual comparison.

## Next milestone

**P5 — Briarwood Refuge Management:** take the **same** persistent entry decisions and case records into a separate refuge-placement and hands-on care system. Keep city entry, refuge placement, custody and guardianship independent; make public refuge costs distinct from the private household ledger. Do not invent a new recurring named cast to populate test beds.
