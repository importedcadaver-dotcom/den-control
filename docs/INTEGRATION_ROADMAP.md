# Unbearable Conditions — Technical integration roadmap

## Sources inspected (not yet committed as game code)

1. **Briarwood Refuge v0.1:** Godot 4 project, from `BriarwoodRefuge_v0.1_Windows_and_Source.zip`; includes a Windows executable, GDScript source, tests, screenshots, README, and QA record. It is a **recovered baseline**, not the later uncollected UI audit revision.
2. **Honey, Please — Layer 1 v3:** Single-file HTML game source. Includes SVG animal faces, a drag-and-compare document desk, procedural parties, rules data, stamping, a queue, Gazette headlines, escalating policies, and a 120-second shift timer. **No implemented home, refuge, persistent characters, or multi-day narrative simulation.**
3. User feedback and approvals in both chat transcripts. These take priority over proposed assistant defaults.

## Recommended engineering order

### 0. Preserve and reconcile sources
- Import Godot editable source as a tagged initial snapshot; **exclude the large Windows binary**, generated Godot cache, personal saves, and build artifacts from the main source tree.
- Commit the original Claude HTML under `references/honey-please/` as a **reference**, not as a second production engine.
- Find the post-v0.1 Den Control revision, inspect its changes, and merge its fixes before feature work.
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
- **Grandma (Mama's mother)** lives nearby and cares for Button and Hazel after structured **half-day** preschool; **she is mean to them and both justifiably hate her**. Model conflict, observations, safety, options for alternate care, and memories; do not turn her into a benign default without player-approved development.
- **Button** prefers inside/modern conveniences over wilderness; **Hazel** hates being told what to do. Each has different teachers and peer relationships.
- Ensure **quadrupedal movement** for all bears, with cub/adult anatomy, desks, classrooms and furniture arranged accordingly.

### 3. Upgrade the inspection loop
- Use data-driven legal policies but separate `law`, `facts`, `evidence available to player`, `verdict`, and `supervisor assessment`.
- Build clear manipulable documents and evidence comparisons, humane exceptions, holds, appeals, and registry queries.
- Distinguish city-entry clearance from any subsequent refuge-placement decision.
- Design most routine arrivals procedurally; preserve authored family arcs across days.

### 4. Build the first connected week
Acceptance test: over a fixed **3 gate + 3 refuge + 1 off** seven-day cycle, a family is encountered at the gate, investigated, admitted/denied/held, located afterward, affected by Mama's refuge decisions, and able to return. Mama's two authored cubs and caregiver maintain independent routines through checkpoint and refuge days; finances and consequences persist through save/reload.

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

## Current repository state when this document was initialized

Only design/integration documentation has been uploaded via the connected GitHub integration. **Do not represent this as a code import or playable version.** First source-import commit is a separate tracked step.
