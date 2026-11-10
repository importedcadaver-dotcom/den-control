# Unbearable Conditions — P5 Refuge Management Checkpoint (2026-11-09)

**Status:** Source implemented and independently verified in [GitHub Actions run 42747344337](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42747344337), against commit \`0fba64ee7f1285d156bdad9e90070a333203d167\` (before checkpoint documentation updates). **Not a Windows export or an approved story-content release.**

## Completed P4.1 repairs (prerequisite to P5)

1. **Repeatable gate days:** Gate shifts are indexed by world day. A later scheduled gate day archives the earlier completed shift without deleting cases, identities, verdicts or events. No replay of a shift on the same day.
2. **Separate person/party records:** The anonymous adult-and-cub test case now registers two distinct permanent QA IDs with a shared case. Each has an independent gate entry result; no guardianship is inferred from accompaniment.
3. **Case ownership:** Entry and raw refuge placement reject an anonymous subject being processed against a different registered case. The P5 admission workflow independently checks admission status, case ownership, bed availability and QA provenance.
4. **Source snapshots:** Historical QA cases and digest persist with the shift instead of validating old saves against an updated fixture file. The full copied gate outcome and each participant's status are cross-checked against authoritative records.
5. **Atomic gate startup:** Failed shift setup restores the previous full world snapshot.
6. **Incomplete investigations:** A reasoned HOLD can be recorded without fabricating verification already completed.
7. **Adult/cub visual correction:** The adult-and-cub training case draws distinct quadrupedal figures instead of shrinking the adult.
8. **World time beyond home UI:** Active unpaused work shifts call a shared world timer that advances autonomous cub behavior even if the home scene is not present. **Care coverage remains explicitly \`unresolved_schedule\`**: this does not simulate Grandma's approved cruelty or invent school events.

The prior-day gate validation originally incorrectly required the *current* calendar to be evening whenever an earlier gate shift was complete. This blocked starting a refuge shift on the next day's daytime phase. It was fixed by scoping that check to the gate shift's own calendar date.

## P5 implementation

- \`game/scripts/refuge/refuge_system.gd\`: distinct refuge-operation lifecycle, authorized resident eligibility, bed allocation, capacity limits, supplies, public-budget purchases, hands-on care, simple autonomous needs and care/event history. All initial capacity and pricing values are **provisional QA tuning**, not approved city economy facts.
- \`game/scripts/refuge/refuge_view.gd\`: actual Godot view showing resident beds and quadrupedal animals, admission controls, purchasing, resident selection, feed/comfort/rest/treat, shift completion, save/load, and return home.
- \`game/scripts/world/world_state.gd\`: P5 refuge state added to single canonical world; versioned developer save schema raised to **6**. Gate outcomes, guardianship, household state, independent private/public ledgers, and event log remain separate. No promise to migrate prior *developer* saves.
- \`game/scripts/home/home_view.gd\` and \`game/scripts/main.gd\`: Mama's home can open the scheduled refuge shift on day 2; Gate → Home → Refuge → Home uses the same \`WorldState\`.
- \`game/tests/test_p5.gd\`, \`game/tests/test_p5_ui.gd\`, \`tests/test_p5_static.py\`: independent behavior and UI regression suites, added to GitHub Actions.

### Important design/authority boundaries

- The P5 facility is currently a **QA training refuge** using only anonymous \`uc.qa.*\` gate people. **They are not approved Honeyhold recurring characters.** No names, relationships or history were invented.
- Gate permission **does not** automatically assign a bed. Residence requires a separate P5 admission operation.
- The only automatic changes to resident needs are simple QA hunger/energy/comfort behavior. This is **not** yet a deep independent resident psychology or social life simulation.
- All purchases use the **public refuge** Honey Marks ledger and require explicitly initialized QA funds. The household ledger is not seeded or debited by these purchases. No approved Mafia debt principal or wages were invented.
- **No final Honeyhold admissions statutes, medical details or facility costs** were established. QA training rules and prices are placeholders.
- No Grandma/preschool offscreen caregiver simulation is implemented. The existing approved cruel-caregiver canon is preserved, neither softened nor illustrated through unauthorized events.

## CI evidence

[Latest successful run — 42747344337](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42747344337):

| Suite | Verified checks |
|---|---:|
| P1 Godot | 7 passing |
| P2 Godot | 56 passing |
| P3 Godot | 67 passing |
| P4 Godot | 85 passing (revised for separate cub QA identity) |
| P4 home/gate UI | 19 passing |
| P4.1 Godot | 37 passing |
| P5 Godot resident/care/legal/financial/save | 64 passing |
| P5 Godot home/gate/refuge UI | 17 passing |
| **Total Godot assertions** | **352 passing** |
| Python source/static suite | **40 passed** |

Both GitHub Actions jobs succeeded; a headless editor import and main-scene startup also succeeded. The first P5 test attempt exposed a real cross-day validation bug; the date-scoped fix was applied and later full CI passed. **These are real automated engine checks, not a Windows human playtest or visual polish review.**

## Remaining risks and next milestone

1. **Visual/manual Windows QA is outstanding.** Verify the inspection workbench, refuge sidebar, text sizes, controls, species/cub proportions, animations and screenshot evidence on Windows.
2. **Refuge care is still a simple QA prototype.** Bed management, supply accounting and resident need progression work, but there is no real hiring, discharge workflow, medical investigation, ordinary resident conversations, authored resident family case, occupancy politics or city-scale consequences.
3. **Calendar/story integration is partial.** P4.1 offscreen world time advances cub needs while work runs, but no full daycare/school/Grandma schedule or day-phase salary/cost simulation exists.
4. **QA content is not production content.** Before the actual P6 release, individually approve the first recurring applicant/household and its legal evidence/agency and design how the consequences unfold. Avoid creating a roster.
5. **Save schema migration is not settled.** Current schema v6 is a developer-save format; decide the first player-save compatibility contract before distributing a durable release.
6. **Full seven-day acceptance and game balance are untested.** P6 remains a cohesive first two-day playable milestone with a genuine authored case and visually audited home/gate/refuge continuity. A later test must cover 3 gate / 3 refuge / 1 off.

**Readiness:** P4.1 and P5 engineering source milestone **verified**; **P6 not yet complete**. Preserve this difference in future summaries.
