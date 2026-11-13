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


## Verified P6 execution results — November 12, 2026 PST

**Authoritative completed CI:** [GitHub Actions 43361027996](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996), passing all three jobs:
- **Linux Godot 4.7.2:** editor import, P1/P2/P3/P4/P4 UI/P4.1/P5/P5 UI/P6/P6 UI headless suites, and main-scene boot. **423 GDScript assertions passed** (P1 7, P2 56, P3 67, P4 85, P4 UI 19, P4.1 37, P5 64, P5 UI 17, P6 56, P6 UI 15).
- **Python on Linux:** 44/44 source/contract checks passed. The first P6 attempt had one stale P4.1 source-string assertion; updated it to assert the new bounded time-step path. After that correction, all 44 passed.
- **Windows Godot 4.7.2:** official 86 MB Windows Godot binary from the verified Godot release; editor import, all P1–P6 headless suites, and main-scene startup passed.

### Downloadable Windows QA runner
- GitHub workflow artifact ID: **14008022958**, name **UnbearableConditions-P6-QA-Windows**.
- [Download from the successful workflow's Artifacts section](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996). Artifact retention is 30 days; the repository source remains available after artifact expiry.
- Includes the official Godot 4.7.2 Windows x64 executable, full current game project, PLAY_P6_QA.bat, QA README and official Godot MIT license.
- The downloaded artifact ZIP passed integrity testing with **52 entries**, and SHA-256 **09b13d62e7d673cbcc0d01d6ea640ac24bfc36f753951fbb370cc292c5f22c60**. It is a portable **developer QA runner**, not a final Godot-exported game package or visual certification.
- A user on Windows can extract the ZIP and run the launcher; no separate Godot editor installation is required. **A human Windows session has not been playtested**; no claims of validated mouse controls, text clipping, final polish or real audio are supported.
- [QA playtest checklist](P6_WINDOWS_PLAYTEST_CHECKLIST.md) gives concrete manual verification steps.

### Remaining release gates

1. **First recurring applicant:** only after individual user-approved identity, relationships and legal case context. Anonymous QA visitors cannot be silently converted to fictional citizens.
2. **Childcare:** clarify school calendar and actual timings, model observable Grandma risk/consequences and immediate safety choices, without inventing an abuse incident or excusing her established cruelty.
3. **Legal and economy content:** official regulations, ethical uncertainty, staff welfare, actual case/refuge consequences, wages/debt and production balances remain unapproved or unimplemented.
4. **Windows visual/manual QA:** screenshots at real desktop scale, text readability, mouse targets, scrolling, animation/character proportions and gameplay feel.
5. **Durable saves:** v6→v7 development save upgrade exists; production cross-version compatibility and migration from schemas 1–5 are not promised.
6. **Seven-day acceptance:** verified first/third gate days and two-day QA sequence, not a complete 3-gate/3-refuge/1-off player campaign.

**Canonical protection:** exactly five approved established individuals; no new recurring named characters, real Honeyhold laws or final budget figures added. Old v0.1 Button/Hazel seeds remain excluded.
