# P5/P4.1 Quality Audit and P6 Technical Integration — November 12, 2026

**Scope:** implement and verify the first complete **anonymous QA** home → gate → home → refuge → home two-day cycle and preserve the five approved canon individuals. **Not** a fully authored P6 story release or a Windows hands-on/visual acceptance test.

## Repository baseline and evidence
- Baseline inspected: 15cb34f9ea5c0d3289b66eea0aeaa10fdd210748, CI [42747720018](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42747720018) passed Linux Godot and Python jobs.
- Existing verified P5 suite: P1–P5 352 GDScript assertions and 40 Python static tests. Older pass counts are historical evidence; P6 requires a fresh run after source changes.
- P5 and P4.1 source reviewed. Gate entry and actual refuge placement were already separate. Public refuge costs were already charged to the refuge HM ledger.

## Audit findings and changes
| Finding | Impact | Change in this milestone | Remaining limitation |
|---|---|---|---|
| Daytime family coverage not represented as a schedule | Cub needs run offscreen, but caregiver/school coverage was unresolved | Added distinct P6 family schedule with QA half-shift preschool window, post-school Grandma coverage, Mama home on return, event history and save validation | No named school staff, Grandma abuse scenes, verified attendance, school-calendar policy or final in-world clock |
| Refuge care/purchases could be called outside scheduled active shift | Possible after-hours state mutations through world API | Added date/phase/duty/running clock guard for purchasing, direct care and resident simulation | A future release needs fuller work-break, emergency and off-duty care policy |
| Unbounded/invalid shift time input | Non-finite input and overshoot could corrupt or over-advance world-time | Added finite-time rejection and caps enabled shift deltas to remaining shift length | Time scale and shift duration still QA-only |
| Developer save schema changes | Previous P5 developer saves fail under new state | P6 schema 7 validates schedule; SaveStore upgrades schema 6 on load with uncertain historical school status, and preserves legal/finance/resident state | No migration promise for earlier schemas 1–5, nor production save compatibility contract |
| Two-day cycle not tested as an independent milestone | P5 tests cover a route but not the new caregiver timeline | Added P6 end-to-end state, scene navigation and save-upgrade regressions | No approved named recurring case or full P6 branching story |

## Non-negotiable canon preservation
- The only approved named/established people are Mama, Button, Hazel, Grandma (personal name not approved), and Queen Ursula. Original Briarwood v0.1 Button/Hazel characters stay blacklisted.
- Button/Hazel remain six-month-old biological littermates, with their mother Mama, separate school/peer identities, independent intentions and possible conflict.
- Grandma is known to be deliberately cruel and both cubs justifiably hate her. **Scheduling her as usual after-school caregiver does not imply she is kind or safe**. The simulation does not invent specific misconduct incidents or claim to have implemented a safeguarding investigation.
- School attendance in this QA slice is a **provisional work-shift time window**, not an approved school calendar or teacher/lesson story. An early shift finish records attendance as **unverified**, not completed.
- The gate and refuge use anonymous test visitors, not newly authored characters, final city law, salary or economics. 80 HM public budget and supply prices remain labeled provisional.
- No public refuge purchase spends Mama's household money and no gate decision grants guardianship or a refuge bed.

## Production gates after this engineering pass
- P6 *technical QA slice*: home, gate and refuge share an authoritative world; the two-day sequence is testable and saves/restores. Godot CI evidence required before calling it verified.
- P6 *authored player release*: still needs individually approved recurring applicant(s) and legal evidence, meaningful downstream outcomes, real school/calendar and caregiver consequences, polished art, Windows human usability testing and a stable save contract.
- Windows headless engine smoke/export are not equivalent to a manual Windows visual playtest. If no Windows runner is used in this pass, record that openly.

## Source
- game/scripts/world/family_schedule.gd
- game/scripts/world/world_state.gd
- game/scripts/world/save_store.gd
- game/scripts/refuge/refuge_system.gd
- game/tests/test_p6.gd and game/tests/test_p6_ui.gd
- tests/test_p6_static.py
