# Unbearable Conditions — Production Plan v0.1

**Status:** Production scope approved; implementation preparation in progress.  
**Target:** Windows desktop, Godot 4.7.2 / GDScript (provisional baseline inherited from the recovered source).  
**Project canon:** Honeyhold, Mama Bear, Button, Hazel, Grandma and Queen Ursula remain governed by APPROVED_DECISIONS.md. This plan does not create or rename characters.

## 1. Approved production decisions

The user explicitly approved:

1. **First production milestone B:** one complete gate day + one complete refuge day + home/family gameplay.
2. **Gate gameplay C:** a combination of detailed investigations and routine arrivals.
3. **Refuge gameplay C:** hands-on resident care and facility/operational management.
4. **Family gameplay B:** direct interaction with the cubs, while they retain autonomous behavior.
5. **Art production C:** a functional prototype with a consistent pixel-art style, followed by a dedicated polish pass.

These decisions define production scope. They do not reopen previously approved canon.

## 2. Production objective

Build a small but genuine connected section of Unbearable Conditions in which the player can:

- Start a workday in Mama's home and interact directly with Button and Hazel.
- See the cubs follow their own needs, preferences, intentions and relationships rather than simply waiting for commands.
- Complete a gate shift with routine arrivals and at least a few substantive investigations.
- Carry gate decisions forward into the world without collapsing entry permission, guardianship and refuge placement into one status.
- Complete a refuge-management shift, care for residents and manage beds, supplies, capacity and the public operating budget.
- Return home, see the cubs' reactions and consequences, and advance to the next day.
- Save, reload and use the cheat menu without corrupting persistent state.

The milestone should feel like a connected piece of the intended game, not two unrelated minigames or a disposable interface demo.

## 3. Exact scope of the first milestone

### A. Home and family — present on both days

**Required:**
- Mama's home as a playable, visible scene.
- Button and Hazel as distinct, persistent six-month-old brown bear littermates, with their approved personalities.
- Direct interactions with both cubs.
- Autonomous behavior that continues to express different preferences, needs and reactions.
- A basic daily routine connecting home, preschool and caregiver arrangements.
- Grandma remains the established, deliberately cruel caregiver. Her established behavior and the cubs' justified hatred must not be softened or rewritten. Her personal name and detailed event history remain open.

**Initial behavior depth:** use a small number of meaningful needs and persistent intentions. A cub may seek comfort, pursue an activity, rest, avoid an instruction or react to the sibling. Direct interaction can influence behavior but should not erase autonomy. The first implementation can begin with hunger, energy and comfort as a provisional technical minimum; exact needs and tuning remain open to later design.

**Not required yet:** a complete playable school, a full childcare replacement storyline, advanced long-term developmental transitions or a large family event library.

### B. Gate day — detailed work plus routine arrivals

**Required work loop:**
1. Open the shift and show the day's current rules, schedule and clear instructions.
2. Receive routine arrivals and authored investigative cases.
3. Inspect documents, compare relevant fields, ask questions and seek external verification where appropriate.
4. Distinguish objective facts, available evidence, legal rules, uncertainty and the player's decision.
5. Record a reasoned decision and its immediate consequences.
6. Preserve the same identities and case history after the visitor leaves.

**Required decision concepts:** admit/authorize entry, deny, hold pending investigation and document an authorized exception where the rules permit it. Exact legal labels and the relationship between entry authorization and later refuge placement must be implemented as separate states.

**Timing:** no individual visitor deadline. A generous real-time shift clock applies to the work shift, pauses while reading documents or using menus, and can be disabled in Settings. Do not import Honey, Please's 120-second countdown.

**Content:** routine arrivals may use anonymous generated data for testing. Do not invent new named recurring characters. The first authored recurring applicant family should be created with the user individually before being treated as canon.

### C. Refuge day — resident care plus operations

**Required:**
- A visible refuge interior with residents whose identities persist from the gate/case system.
- Direct care interactions.
- Resident needs and autonomous everyday behavior.
- Beds, capacity, supplies and operating costs.
- A daily refuge budget preview and a record of public expenditure.
- Decisions about placement, temporary accommodation and care that respect legal/guardian state.
- Visible consequences of earlier gate decisions.

**Important distinction:** permission to enter Honeyhold does not automatically make someone a Briarwood resident. Refuge admission/placement is a separate decision and record.

**Initial management depth:** operational budget, supplies, beds/capacity and care priorities. Complex hiring, detailed staff careers and city-wide finance can wait until individual staff and the required systems are designed.

### D. Connected two-day sequence

The intended first slice is:

- **Day 1:** home/family → gate shift → home/evening.
- **Day 2:** home/family → refuge-management shift → home/evening.

This follows the already approved alternating gate/refuge work pattern. It is an intentionally narrow excerpt of the approved weekly schedule, not a replacement for the full 3 gate / 3 refuge / 1 off week.

## 4. Explicitly out of scope for this milestone

These remain part of the broader game direction but are not blockers for the first connected slice:

- All seven explorable city districts.
- A complete 25+ day campaign and all endings.
- Full royal politics, elections, ministries and emergency-law simulation.
- Complete criminal courts and the entire Panda Mafia storyline.
- Every occupation and career track.
- A fully playable preschool.
- A 12–20 person authored recurring cast. This is a future scale target, not permission to invent people. Every new named character must be designed individually with the user.
- Detailed biography and private routines for Queen Ursula beyond the approved facts.
- Finalized city map, all district names, final economy balance and every item.
- Final commissioned-quality sprite and animation set.

Do not create placeholder named characters to fill any of these future roles.

## 5. Technical direction

### Engine and repository strategy

- Use Godot 4.7.2 / GDScript as the provisional baseline, matching the recovered v0.1 project.
- Preserve the original Briarwood Refuge v0.1 archive unchanged as a historical source reference.
- Create a clean Unbearable Conditions project rather than continuing to use the old seeded world as the new game's data.
- The v0.1 Button cub and adult Hazel are **OLD / BAD / DO NOT USE**. Their source records remain archived only and are explicitly blacklisted from the new game's canonical data.
- Do not claim the later Godot UI/economy/guardianship fixes are present until their actual source revision is recovered and compared.

### Proposed architecture

Keep the first implementation small and separable:

| Module | Responsibility |
|---|---|
| WorldState / SessionState | Current persistent world and current play session |
| CharacterRegistry | Stable character IDs, identity, age, species and location |
| HouseholdAndRelationships | Kinship, guardianship, household membership and relationships |
| CalendarAndSchedule | Day, phase, work rotation, school/caregiver schedules and aging |
| BehaviorSystem | Cub needs, intentions, autonomous action selection and memory updates |
| GateCaseSystem | Arrival, document, evidence, questioning, verification and decision records |
| PolicySystem | Rules, effective dates, exceptions, emergency orders and audit reasons |
| RefugeSystem | Placement, resident capacity, beds, supplies, care and operating budget |
| EconomySystem | Separate household and public-refuge ledgers, wages, bills and liabilities |
| SaveService | Versioned serialization, validation, backups and recovery |
| CheatService | Explicit debug overrides, kept separate from ordinary game rules |

The interface should read and issue actions against these systems. It should not own the authoritative truth about characters, laws, money or guardianship.

### Core data records

At minimum, establish stable, independently addressable records for:

- Character
- Household
- Relationship
- Guardian/custody link
- Work/school/caregiver schedule
- Gate case
- Document
- Evidence item
- Policy/rule
- Gate decision
- Refuge placement
- Resident care state
- Financial ledger and transaction
- Memory/event record
- Save metadata

Do not collapse entry authorization, citizenship/residency, guardianship, custody and refuge placement into one boolean or one status field.

### Time and simulation

Keep two clocks separate:

1. **Calendar/world time:** advances through player-controlled day phases and scheduled transitions.
2. **Shift clock:** a generous real-time clock only during active work; pauses during reading/menus and has a Settings option to disable it.

Do not let a menu pause accidentally advance the calendar, age cubs, charge costs or trigger an overnight event. The full 3/3/1 weekly rotation is a later acceptance milestone; the first slice tests one gate day followed by one refuge day.

### Economy

- Currency: Honey Marks (HM), already approved.
- Household money and the city-owned refuge budget must be separate.
- Wages, household expenses, refuge operating costs, inventory and Panda Mafia debt must have explicit ledger entries.
- No public refuge purchase should silently spend Mama's personal funds, and no household purchase should silently draw from the refuge grant.
- Use provisional editable balance values for early testing; do not mistake test numbers for approved canon.

### UI and art

- Keep the approved 2D pixel-art direction.
- Use a consistent first-pass palette, tile/grid scale, perspective, character proportions and UI language from the beginning.
- All bears remain quadrupedal. Adult bears and cubs must be visibly different in body proportions, scale, posture and animation.
- The first pass may use clean code-painted/blockout sprites, but it must look like one coherent game—not unrelated placeholder shapes.
- Redesign the inspection UI rather than preserving the crowded v0.1 top bar. Keep one clear primary task, explicit labels, readable documents, contextual explanations and progressive disclosure.
- Reinterpret the HTML prototype's tactile documents, movable papers, physical-feeling stamps, rulebook and newspaper framing. Do not import its setting names, random cast, simplistic validator or timer.
- Keep Settings and Cheats accessible but out of the primary work surface. The cheat menu is available from the first playable build.

## 6. Production sequence

| Stage | Deliverable | Exit condition |
|---|---|---|
| P0 — Source recovery and inspection | Godot v0.1 and Honey, Please sources recovered, integrity checked and statically inspected | Source inventory, reuse decisions and limitations recorded. **Completed in this preparation pass.** |
| P1 — Source preservation and clean project shell | **Clean shell committed**; original source preserved unchanged in separate recovery package | Python static checks pass; Godot headless validation remains pending. No legacy world script is imported. |
| P2 — Persistent world foundation | **Implemented and headless-verified**: stable IDs, legal/guardian isolation, calendar, event log, separate HM ledgers, debt, validated save/load | Official Godot 4.7.2 CI: P1 7/7 and P2 56/56; Python CI 17 passed. Windows gameplay untested. |
| P3 — Home and family foundation | Mama, Button and Hazel scene; direct interactions and autonomous intentions | Cub differences are observable; direct interaction influences but does not fully override autonomy. |
| P4 — Gate workday | Routine arrivals, detailed cases, document comparison, questions, verification, decisions and case journal | A complete gate shift can be played and decisions persist. |
| P5 — Refuge-management day | Residents, care interactions, beds, supplies, capacity and public budget | Refuge actions alter the same persistent residents and ledger. |
| P6 — First connected production milestone | One gate day + one refuge day + home/family gameplay, save/load, cheats and consistent first-pass pixel art | All acceptance tests in Section 7 pass; a Windows build is exported and actually opened on a Windows machine. |
| P7 — Seven-day acceptance week | 3 gate + 3 refuge + 1 off, school/caregiver routines and repeated consequences | Full week completes and saves without schedule, identity or financial inconsistencies. |
| P8 — Broader production | Districts, recurring NPCs, politics, occupations, courts, crime, media, campaign and endings | Expand only after the connected slice is stable and the relevant people/systems are individually designed. |

## 7. First milestone acceptance tests

### Gate
- Routine arrivals and detailed cases both appear.
- The player can inspect, compare, ask, verify and decide.
- A case records what was true, what evidence was available and what the player decided.
- No individual visitor deadline exists.
- Shift clock pauses in reading/menu states and can be disabled.
- A denial, hold or exception has a recorded reason and does not silently change guardianship.

### Identity and legal continuity
- The same stable character ID follows a visitor from the gate into the relevant later state.
- A gate decision does not automatically grant refuge placement.
- Refuge placement does not automatically change legal guardianship or citizenship.
- A follow-up cannot overwrite an adoption, guardian or custody decision without a separately authorized transition.
- Legacy v0.1 IDs and seed characters do not appear in the new game.

### Refuge
- Resident care changes needs and behavior.
- Beds, capacity and supplies have observable effects.
- Refuge spending affects only the refuge ledger.
- Overnight/refuge costs cannot be paid repeatedly by advancing empty post-campaign days.
- A shortage is explained before or when it affects residents.

### Family
- Button and Hazel have distinct approved behavior.
- Direct care changes their state and memories.
- Their autonomous behavior continues when the player is focused elsewhere.
- One sibling's actions can affect the other's relationship or comfort where the simulation says so.
- School and caregiver schedules do not disappear when Mama changes work location.

### Persistence and tools
- Save/load preserves calendar, character IDs, relationships, guardianship, cases, refuge placement, money, inventory, memories and cheats.
- Invalid or incomplete saves are rejected without destroying the current session.
- A backup exists before replacing a valid save.
- Cheats can be used without corrupting the normal game state.
- Tests are deterministic and repeatable with fixed random seeds.

### Presentation
- Labels explain what an item/document/action means; the player is not expected to know hidden rules.
- The primary work surface is not crowded with every global control at once.
- Adult bears and cubs are visibly distinct and all bears use quadrupedal poses.
- Pixel art, character perspective, environment and interface look like one consistent game.
- Visual inspection is performed on real exported builds, not only source screenshots or mockups.

## 8. Known blockers and risks

1. **Later Godot revision missing:** the transcript describes important post-v0.1 fixes, but no later source archive was recovered. Recover it before deciding whether any of those fixes can be ported.
2. **Legacy content conflict:** v0.1 seeds an unrelated Button cub and adult Hazel. Keep the old archive unchanged, but exclude its data and IDs from new game initialization and saves.
3. **No current Godot runtime in this analysis environment:** the source's stored tests were inspected but not rerun. Windows build validation must occur on an actual Windows/Godot environment.
4. **Unapproved applicant cast:** the first real recurring applicant family still needs individual user design. Use anonymous fixtures for system testing until approved.
5. **Unsettled numerical balance:** salary, loan, starting cash, food prices, capacity and daily expenses are not all fixed. Use editable test values and report them as provisional.
6. **Autonomy depth:** the old behavior selector is only a small prototype. Do not claim a deep cub simulation from a few needs thresholds.
7. **Art production:** consistent first-pass pixel art is approved, but final sprite dimensions, resolution, palette and animation list are not yet locked.

## 9. Decisions not required before production starts

Do not block P1–P6 on:
- Ursula's full biography or the identity of the previous monarch.
- Names of all seven districts.
- Party names, ministers, court personnel or a full recurring cast.
- Every profession, law or criminal organization.
- Every school classmate or teacher.
- Final household prices and every balance number.
- The late-game rebellion details.

These can be developed alongside production when a system actually needs them. Do not invent the missing characters to fill the gap.

## 10. Immediate next actions

1. Preserve the recovered Godot v0.1 source as an unchanged legacy snapshot with provenance.
2. Recover the later post-v0.1 Godot revision, if it still exists, and compare its code against v0.1.
3. Establish a clean Godot project and the minimal data contracts described above.
4. Implement the persistent character/calendar/save foundation.
5. Build the home/family foundation, then the gate shift and refuge shift.
6. Run the two-day integration acceptance tests before expanding the world.

**Current completion (November 8, 2026):** P0 source recovery and P1 shell completed. **P2 persistent world foundation implemented and verified in GitHub Actions** with Godot 4.7.2 (7 P1 and 56 P2 headless checks passed; 17 CI Python tests passed). **P3 home sandbox implemented and headless-verified; P4–P8 unimplemented.** No playable game or Windows export has been verified. This document is a production plan, not a claim that a new build exists.
## Production implementation update — P1

The first source-code commit added `game/` as a clean Godot 4.7.2 project, approved identity and schedule fixtures, a canon loader, GDScript contract tests and Python static checks. This is **infrastructure**, not a playable two-day slice. The complete unmodified legacy source, including the earlier HTML reference, is in a separate downloadable P1 recovery bundle, while GitHub contains preservation manifests/hashes. The previously rejected v0.1 Button/Hazel records are excluded from all new seeds.

The [worldbuilding dependency audit](P1_WORLDBUILDING_GATE.md) finds no need to resolve further Ursula/party/district biography for P1. Before authoring the final gate/refuge story content, one applicant/household should be created individually or kept as anonymous QA fixtures. See [later revision gap matrix](P1_LATER_REVISION_GAP_MATRIX.md) for the differences between source code and claims in the old transcript.

## P2 verified engine-checkpoint

[CI run 42522146379](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42522146379) checked out the actual GitHub source, downloaded official Godot 4.7.2 and successfully ran the P1 (7 checks) and P2 (56 checks) headless suites. GitHub Python checks passed (17). The complete local recovery package also passed 19 static checks because it carries additional legacy-integrity tests. This is **verified foundation logic, not playable family/gate/refuge gameplay**. P3 home sandbox has since been implemented and verified; P4 gate training workday is implemented and verified; P5 refuge management is next.

## P3 delivery update — November 8, 2026

The first in-engine family interaction layer exists under [`game/scripts/home/`](../game/scripts/home/) with coherent first-pass procedural pixel art. Mama, Button and Hazel can be observed; the cubs act autonomously and react contextually, and care, sibling injuries, disputes, relationship shifts and memories persist in the P2 world/save framework (schema **3**). Current demo interactions are feed, cuddle, play, wash, carry/put down, tidy request, first aid, separate and conditional sibling play. Six pantry portions are a P3 test fixture only.

[GitHub CI](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42527012709) verifies the Godot 4.7.2 headless P3 suite (**67 checks passed**), plus P1/P2 regression suites and main-scene startup. **No Windows executable or manually inspected graphical playthrough has been produced**. The original P6 two-day first playable production milestone still requires P4 gate and P5 refuge work.

## P4 delivery update — November 8, 2026

The Godot project now includes a P4 gate workday in [`game/scripts/gate/`](../game/scripts/gate/), with six anonymous QA cases (routine and investigative), evidence/document inspection, questioning, independent verifications and reasoned authorize/hold/deny decisions. Gate results persist in the existing P2 world and remain legally separate from refuge placement, custody and guardianship. Mama can return to the same P3 home state after a completed gate shift. QA examples and test regulations are **not approved fictional law or character additions**.

GitHub CI [run 42534096795](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42534096795) passed Godot headless P1–P4 plus P4 live-scene interaction and Python static tests (**32 passed locally**). The shift-duration of 1,200 seconds is a provisional test setting, not a final canon number. The P4 world save schema is now **4**; P3 developer saves are not automatically migrated.

**Remaining first-milestone work:** P5 refuge management, meaningful cross-day state/world scheduling and P6 two-day acceptance testing. Windows GUI/visual testing has not been done. The absence of new named characters is deliberate and must persist.


## Progress update — P4.1 + P5 verified, November 9, 2026

**Source implemented and verified in actual Godot CI:** P4.1 repeatable gate and legal integration safeguards, and P5 resident care/facility management with a separate public budget. The first coherent Home → Gate → Home → Refuge → Home *QA* flow now has passing Godot scene tests. [Verification and limitations](P5_CHECKPOINT.md).

- P0–P5: source milestone completed and headless verified (including P4.1 prerequisite).
- P6: **not yet a complete approved release**. The working sessions currently use anonymous engineering applicants, provisional rules, capacity, prices and a simplistic resident AI. Real childcare supervision/school, an approved recurring applicant, persistent story consequences, Windows visual and interactive QA, accessibility and save schema policy are still required.
- P7: seven-day workweek acceptance test not run.
- The previously documented P5-not-yet-implemented statements are **historical as of their written date** and superseded by this progress note. No silent additions to canon.


## Progress update — P6 technical QA slice verified (November 12, 2026)

The integrated home → gate → home → refuge → home **anonymous QA flow** now runs on the shared Godot world with a provisional preschool/Grandma supervision window, time-limited refuge operations, evidence/case persistence and a validated schema **v6→v7 developer-save upgrade**. [P6 checkpoint](P6_TECHNICAL_QA_CHECKPOINT.md) records the implementation and remaining gaps.

[GitHub Actions 43361027996](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996) succeeded on Linux Godot, Windows Godot and Python: **423 passing GDScript assertions** in the full P1–P6 Linux suite and **44 passing Python checks**. The Windows headless job ran P1–P6 engine suites and startup. The same run published a **portable Windows QA runner** artifact containing official Godot 4.7.2 Windows executable, project source, launcher and license. Its ZIP passed integrity verification.

**Do not call this the final approved P6 story release.** It has no user-approved recurring applicant, final Honeyhold regulations, finalized school/Grandma event simulation, city-scale political impact, sustained 25+ day story or verified real Windows visual/manual usability. The seven-day acceptance week is not certified. Next stage is player-led visual QA and a *single* individually approved recurring gate/refuge character case, not an invented supporting cast.
