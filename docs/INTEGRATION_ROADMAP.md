# Unbearable Conditions — Technical integration roadmap

## Recovered sources inspected (not yet imported into the active project)

1. **Briarwood Refuge v0.1:** recovered from the current conversation attachment `BriarwoodRefuge_v0.1_Windows_and_Source.zip` and statically inspected. It includes a Windows executable, 19 editable source files, tests, screenshots, README and QA record. The archive passes ZIP integrity testing. The editable source is a **legacy baseline**, not the later uncollected UI audit revision. A source-only copy is prepared, but neither copy is committed to GitHub yet.
2. **Honey, Please — Layer 1 v3:** complete HTML source recovered from the current conversation attachment `Pasted text(20261107-050627).txt`, extracted and JavaScript syntax-checked. It includes SVG animal faces, a drag-and-compare document desk, procedural parties, rules data, stamping, a queue, Gazette headlines, escalating policies and a 120-second shift timer. **No implemented home, refuge, persistent characters or multi-day narrative simulation.** It remains a presentation reference, not a second production engine.
3. User feedback and approvals in both chat transcripts. These take priority over proposed assistant defaults. The later Godot UI/economy/guardianship fixes are described in a transcript, but their source archive has not been recovered; do not assume those fixes exist in v0.1.

## Recommended engineering order

### 0. Preserve and reconcile sources
- Import Godot editable source as a tagged initial snapshot; **exclude the large Windows binary**, generated Godot cache, personal saves, and build artifacts from the main source tree.
- Commit the original Claude HTML under `references/honey-please/` as a **reference**, not as a second production engine.
- Recover the post-v0.1 Den Control revision if it still exists, inspect its changes and compare it with v0.1 before deciding which fixes to port. The current transcript is evidence of reported changes, not source code.
- Capture reproducible tests and screenshots from actual executed builds. Distinguish previous reported test results from newly rerun ones.

### 1. Stabilize persistent world model
- Split NPC identity/biology, relationships, guardianship/legal rights, households, jobs, residence, evidence, and case outcomes into explicit data.
- Keep stable entity IDs independent of scenes and case templates.
- Ensure an adopted animal's guardian cannot be overwritten by later generic case follow-ups.
- Add save schema version and validation, and tests for custody transitions and case continuity.

### 2. Implement a calendar and role schedule
- **Fixed seven-day loop: gate / refuge / gate / refuge / gate / refuge / off**, with school, Grandma and home scenes each day. Mama voluntarily sought the second appointment for income/career progression.
- No per-entrant inspection deadline. Preserve the user's **shift timer only** requirement and flexible day phases. **Round 4 resolves clock behavior:** generous real-time shift timer, pauses during document reading and menus, and may be disabled in Settings for unlimited shift time. Do not copy Claude's 120-second timer unchanged.
- Household expenses, public refuge budget and Mafia debt have separate **Honey Marks (HM)** ledgers. The wider city economy is mostly simulated in the background; do not overbuild detailed NPC finance for every resident.
- **Grandma (Mama's mother), a fired former nursery teacher (reason unapproved),** lives nearby and cares for Button and Hazel after structured **half-day** preschool; **she deliberately enjoys humiliating cruel dares, threats, and neglecting comfort**, and both cubs **justifiably hate her**. **Mama knows she is mean** but relies on her because of work and money. A new regular caregiver requires a **substantial replacement-care storyline**, though immediate protective responses remain possible. Track memory, severity, evidence, safety and aftermath; do not turn her into a benign default.
- **Button** prefers inside/modern conveniences over wilderness; **Hazel** hates being told what to do. Each has different teachers and peer relationships. Both can harm one another physically/emotionally, fight, become estranged, hate each other, or reconcile; **bear emotional tears** need animation support.
- Ensure **quadrupedal movement** for all bears, with cub/adult anatomy, desks, classrooms, furniture and visibly tearful expressions arranged accordingly.
- Implement **continuous calendar aging** and developmental milestones; do not default to forced narrative time skips. Preschool scenes are observational/visit-based initially, with a deeper playable school perspective deferred.

### 2b. Populate the persistent Honeyhold world
- **Seven connected districts** with explorable interiors and individual resident schedules; specific district names are proposals only.
- **12–20 deeply simulated recurring characters is a future target only**, NOT permission to create or import a roster. **Design each named person individually with the user**. Only Mama, Button, Hazel, Grandma (name undecided), and Queen Ursula are established characters.
- Bears are a large citywide majority with smaller cat and red panda populations; mixed neighborhoods have sharply unequal resources.
- **Queen Ursula** is a **Kodiak brown bear** with a cuddly, affectionate public persona and ruthless protection of power. Two major political parties contest welfare/civil rights versus royal authority/security, with names and leaders undecided.
- Profession-specific eligibility combines schooling, apprenticeship, experience and patronage. Young cubs normally use school/welfare jurisdiction; juvenile court thresholds vary by offense and emergency orders.
- **Preschool includes multiple classes yet district/wealth affect placement and quality**. Button and Hazel's individual teachers/classmates are not approved, and all characters from the rejected proposal must stay absent until created individually.
- **Legacy character blacklist:** The v0.1 **Button cub** and **adult Hazel** are **OLD / BAD / DO NOT USE**. Preserve the source archive for audit, but **exclude these legacy characters from new game canon, migration and NPC spawns**. Create fresh persistent IDs for Mama's approved cubs. Do not adapt/rewrite the blacklisted legacy characters into the new cast.

### 3. Upgrade the inspection loop
- Use data-driven legal policies but separate `law`, `facts`, `evidence available to player`, `verdict`, and `supervisor assessment`.
- Build clear manipulable documents and evidence comparisons, humane exceptions, holds, appeals, and registry queries.
- Distinguish city-entry clearance from any subsequent refuge-placement decision.
- Design most routine arrivals procedurally; preserve authored family arcs across days.

### 4. Build the first connected production slice
**Approved first milestone:** one complete gate day + one complete refuge-management day + home/family gameplay. Gate work combines routine arrivals with detailed investigations. Refuge work combines hands-on resident care with facility/operational management. Mama can directly interact with Button and Hazel while both cubs retain autonomous behavior. Art begins as a consistent functional pixel-art prototype, followed by polish.

**Acceptance test:** on Day 1, the player completes a gate shift and records decisions; the same persistent people and consequences remain available to the refuge/legal systems; on Day 2, the player completes a refuge-management shift with hands-on care, beds, supplies and a separate public budget; home/family scenes occur on both days; save/load preserves the complete state. Entry permission, guardianship and refuge placement remain distinct. Do not create new named recurring characters to fill test cases; use anonymous fixtures until the user individually designs an authored family.

### 4b. Expand to the first connected week
After the two-day slice passes, test the approved full rotation of **3 gate + 3 refuge + 1 off** days. A family can be encountered at the gate, investigated, admitted/denied/held, separately considered for refuge placement, located afterward, affected by Mama's refuge decisions and able to return. Mama's cubs and caregiver maintain independent routines; finances and consequences persist through save/reload.

### 5. Expand and test
- 25+ day authored campaign with procedural variety, factions, lawful and illicit choices, rebellion threads, multiple endings, and post-campaign free play.
- Refine adult/cub physical silhouettes, animation poses, coherent pixel-art UI, audio, accessibility, performance, and balance.
- Run tests and actual input-driven playthroughs; do not count reported historical tests as current verification.

## Audit risks from the supplied designs

- Existing Godot authored cases are limited and some logic is highly coupled to UI state.
- Claude's rule engine equates legality with correctness; it cannot model morally troubling lawful decisions or false evidence adequately.
- Claude's travel parties and cub names are generated anew and **not persistent**.
- Conflicting schedules: both-job-per-day concept is **superseded** by approved alternating-day design.
- Conflicting pressure: Claude's short timer is **not canon**. Round 4 approved a **generous real-time shift timer, paused during reading/menus, with a settings toggle to disable it**, and **no per-case deadlines**.
- Family ownership, foster status, refuge placement, and city-entry authorization must not be collapsed into a single `guardian` or `admitted` value.

## Round 6 retraction

The former 20-character AI-created roster is **rejected**. The current [Round 6 document](ROUND6_CAST_AND_INSTITUTIONS_PROPOSALS.md) withdraws the roster and replaces it with a one-character-at-a-time creation requirement. Any implementation must exclude the rejected proposal and two blacklisted v0.1 legacy names.

## Current repository state after source recovery and production approval

The Godot v0.1 archive and Honey, Please HTML source have now been recovered from the conversation attachments and statically inspected. The Godot ZIP passes integrity checking; the HTML JavaScript passes a syntax check. **The actual source files are not yet imported into GitHub or merged into a new game project.** The repository still contains design/integration documentation only. P0 source recovery and reuse audit is complete; P1 source preservation and clean project setup remain next. Do not represent this as a merged codebase or playable Unbearable Conditions build.


## Production scope approved November 7, 2026

The user approved first milestone B (one gate day + one refuge day + home), gate gameplay C (detailed cases plus routine arrivals), refuge gameplay C (hands-on care plus operations), family gameplay B (direct interaction plus autonomous cubs), and art production C (consistent functional pixel-art prototype, then polish). See [PRODUCTION_PLAN_V0_1.md](PRODUCTION_PLAN_V0_1.md) for the complete production specification, architecture, staged sequence and acceptance tests.
## P1 engineering checkpoint — November 8, 2026

- Clean Godot 4.7.2 project shell, canonical seed records and contract tests are now committed to `main`. No old v0.1 world initialization is referenced.
- The original source remains intact in a separate recovery bundle and verified SHA-256 list, not in the GitHub active project.
- See [P1 source-gap matrix](P1_LATER_REVISION_GAP_MATRIX.md) for the later reported-but-unrecovered fixes.
- **P2 implemented and Linux-headless verified:** persistent world, legal transitions, calendar, separate HM ledgers, versioned save/load. Both P1 and P2 Godot tests passed in GitHub Actions. **P3 home sandbox is now headless-verified**; Windows launch is still unverified.

## P2 persistent-world checkpoint — November 8, 2026

**Source implemented:** `game/scripts/world/world_state.gd` and `save_store.gd` contain a new version-2 state model, separate legal/entry/refuge records, work calendar and shift-clock APIs, independent HM household/refuge ledgers and debt, event history and guarded save/restore. The [P2 state schema](P2_STATE_SCHEMA.md) and [P2 checkpoint](P2_CHECKPOINT.md) document exact contracts and limits.

**Testing:** Godot test scenarios are authored in `game/tests/test_p2.gd`; Python source-level checks are authored in `tests/test_p2_static.py`. The complete local package passed **19 static pytest checks**. A [GitHub Actions verification workflow](../.github/workflows/foundation.yml) now targets Godot 4.7.2 as well, and [the actual Godot 4.7.2 run passed](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42522146379): P1 **7/7**, P2 **56/56** headless checks, plus **17** GitHub CI static Python tests. Windows export and human playtesting remain unverified.

**Next:** Implement P4 gate workday on top of the shared home/world foundation. P3 home behavior and an in-engine scene are now implemented and headless-verified in Godot. Windows export and real UI playtesting remain separate verification gates. P5 refuge remains unimplemented. No new named NPCs were created.

## P3 checkpoint — November 8, 2026

- [P3 home and family checkpoint](P3_CHECKPOINT.md): one interactable Godot home scene and persistent approved Mama/Button/Hazel home state. P2 world save version bumped to **3** for the home records; no P2 development-save migration is guaranteed.
- Direct Mama care, cub autonomy and conditional refusals, emotional tears, quadrupedal pixel art, memories, sibling disputes, fights and possible injury are implemented within this bounded home sandbox. The demo pantry holds finite test portions; this is not an approved balance decision.
- [GitHub Actions run 42527012709](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42527012709) passed Godot 4.7.2 suites P1 **7/7**, P2 **56/56**, P3 **67/67**, 24 GitHub Python static checks (26 in the complete local package), and headless scene startup.
- The P3 home sandbox is **not P6** (the gate+refuge+home two-day release). Grandma's scheduled childcare, full calendar aging and any new named case character remain deferred; approved canon is unchanged. P4 gate work is next.

## P4 engineering checkpoint — November 8, 2026

The P4 gate workday was implemented on the shared P2+P3 WorldState with six **anonymous QA applicants** and provisional inspection rules. It includes questioning, document examination, record verification, reasoned legal entries/holds/denials, a shift timer that pauses while reading (and can be disabled), persistent case/decision records and home-to-gate-to-home navigation. [P4 checkpoint](P4_CHECKPOINT.md) and [test matrix](P4_TEST_MATRIX.md) describe constraints and evidence. The P4 world/save schema is **4**; earlier P3 developer saves have no automatic migration. The old v0.1 Button/Hazel identities remain excluded.

[GitHub Actions 42534096795](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42534096795) passed Godot 4.7.2 P1/P2/P3/P4 headless suites, P4 UI scene interaction, editor import and startup, and Python checks. The new gate content is expressly **QA-only**, not newly invented Honeyhold law or canonical applicants. **P5 refuge management is next**, followed by P6 connected two-day acceptance testing and Windows visual testing.


## P4.1 and P5 engineering checkpoint — November 9, 2026

P4.1 repaired the audited gate repeat-day and identity handoff blockers: date-scoped repeatable shifts with archives, independent adult/cub QA IDs, case ownership, snapshot integrity, atomic gate startup, pending HOLD, visually separate adult/cub render and shared offscreen world time. The earlier completed gate no longer blocks later refuge daytime validation.

P5 implemented an independent QA refuge management system with public-budget-only purchases, beds/capacity, food and medicine, direct resident care, needs/autonomy, saved resident state and Home → Gate → Home → Refuge → Home navigation, all through the existing world state. **Anonymous QA applicants and provisional numbers are NOT canonical new residents, legal statutes or official Honeyhold financial figures.**

[CI run 42747344337](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42747344337) verified 352 Godot assertions (P1–P5), 40 Python static checks, Godot editor import and headless main-scene boot. See [P4.1 checkpoint](P41_CHECKPOINT.md) and [P5 checkpoint](P5_CHECKPOINT.md).

**P6 remains outstanding.** The game needs authored individually approved people/cases for real fiction, a true cross-day childcare and school simulation, usable and visually inspected Windows UI, final economic balance, player-save compatibility policy and an actually tested two-day integrated release. Do not conflate the tested QA sandbox with those deliverables.


## P6 technical QA checkpoint — November 12, 2026

[Checkpoint and QA limits](P6_TECHNICAL_QA_CHECKPOINT.md) · [Windows manual test checklist](P6_WINDOWS_PLAYTEST_CHECKLIST.md) · [Latest Windows and Linux CI](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996)

Implemented: provisional half-day preschool→Grandma scheduled care state and event history, no invented school or cruelty scenes; date- and shift-scoped refuge actions; finite, bounded shift-time steps; schema v7 and v6 developer-save upgrade; independent end-to-end P6 state/UI tests. The portable **Windows P6 QA runner** is published as a workflow artifact and its ZIP passed integrity checks.

Verified: **423 Godot assertions** on Linux in P1–P6 suites, **44 Python checks**, and official **Windows Godot 4.7.2** headless editor import, P1–P6 suite execution and scene boot. This is not a Windows human-controlled visual playtest.

**Release status: engineering/QA prototype only.** Full authored P6 requires one individually approved recurring applicant case, school/care safety consequences, player save compatibility policy, Windows readability/interaction/visual review, and game-feel tuning. P7 seven-day campaign tests remain a separate stage. Earlier roadmap statements that P5/P6 are wholly unimplemented are superseded by this dated checkpoint.
