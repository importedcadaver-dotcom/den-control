# UNBEARABLE CONDITIONS — Forensic project audit and checkpoint
**Checkpoint:** 2026-11-07 (America/Los_Angeles). **Basis:** This conversation's explicit decisions and the connected GitHub repository `importedcadaver-dotcom/den-control` on `main`.
**Status:** Documentation and design consolidation, **not** a built or tested merged game. **Audit scope:** 10 tracked Markdown files read, entire default-branch file tree inspected, GitHub commit listing, branch list, issue list, PR list and release list. Original external Godot and Claude source archives were **not executed or inspected afresh** in this audit.
**Source-of-truth order:** Latest explicit user corrections > `docs/APPROVED_DECISIONS.md` (read chronologically, respecting supersessions) > approved individual-character dossier sections > this checkpoint > historical proposal documents. Actual running code and test evidence must be distinguished from claims inside design documents.

## 1. Executive findings

1. **Canon documentation: substantial and recently edited.** Rounds 1–6 and individually approved Queen Ursula details are in the approved canon; Queen Ursula has a dedicated dossier. Historical proposals remain clearly labeled, though some stale text persists.
2. **Code/build presence in GitHub: zero.** Default branch has **10 files, all Markdown**, plus directories. No `project.godot`, `.gd`, scenes, imported assets, build artifacts or runnable tests. The README refers to a previous Godot baseline and a Claude HTML prototype, but neither was committed as playable merged code.
3. **Latest user-approved change incorporated:** Queen Ursula inherited the throne **at six months** because **the previous monarch died unexpectedly**. The former monarch's identity, relationship, cause/circumstances of death and aftermath are not approved. Current Ursula age **7**, reign **6 years 6 months**. Since her coronation, she possessed actual near-unchecked sovereign authority, not puppet status.
4. **Most severe design-process mistake already corrected:** An assistant invented a 20-character supporting roster. The user explicitly **rejected all invented characters** and requires **individual approval** of every new person. The current Round 6 document withdraws the roster. The rejected characters remain only in historical Git revisions.
5. **Technical integration risks remain unresolved.** The Godot baseline has legacy NPCs called Button (cub) and Hazel (adult). They are **OLD / BAD / DO NOT USE** and are **not** the newly approved siblings. A future source migration must omit them, never merge by display name, and use new stable IDs.
6. **Governance simulation is under-specified:** nominal constitutional institutions and two parties coexist with Ursula's overwhelming de facto authority and indefinite emergency powers. This tension is canon, but actual mechanics for laws, elections, votes, official execution of childish orders and court limits are not yet specified or tested.

## 2. Repository evidence and timeline

- **Repository:** https://github.com/importedcadaver-dotcom/den-control (public; default branch `main`).
- **Initial commit:** `549a2fe8481ad2381a776e8aa29a986be3b71d53`, `2026-11-07T05:40:56Z` = **November 6, 2026, 9:40:56 PM PST**.
- **Before this audit's edits:** latest `927dba6582cee8df7d09ef68f1dd2434497ea1b2`, `2026-11-08T00:18:24Z` = **November 7, 2026, 4:18:24 PM PST**, approving Ursula age seven.
- **Latest accession correction immediately before this checkpoint:** `4c617ce6b0f20876fe9f5e658115f628a628b973`, `2026-11-08T00:50:25Z` = **November 7, 2026, 4:50:25 PM PST**, approving previous monarch's unexpected death. Newer checkpoint commits will follow.
- **Commit count at pre-checkpoint inspection:** **49**, all present in `GET /repos/.../commits?per_page=100`. A high commit count is **not** a measure of completed code.
- **Tree at pre-checkpoint inspection:** 10 tracked Markdown files and 2 directories; no game code, assets, tests, CI configs or generated builds.
- **Branches:** one (`main`). **Issues:** zero. **Pull requests:** zero. **Releases:** zero. A GitHub Actions endpoint was not available through this connector; absence of a `.github/workflows` directory is verifiable from the tree, but live Actions runs were **not** checked.

### Tracked files inspected

1. `README.md` — project overview; contains references to external sources not present on `main`.
2. `docs/APPROVED_DECISIONS.md` — authoritative accumulated choices; append-heavy, some superseded older wording.
3. `docs/DWARGON_INSPIRATION_AND_QUEEN_URSULA_RESEARCH.md` — research and proposal/historical notes; latest explicit Ursula approvals appended.
4. `docs/INTEGRATION_ROADMAP.md` — implementation order (not executed).
5. `docs/ROUND3_PROPOSALS.md` — superseded historical questions.
6. `docs/ROUND4_SYSTEMS_PROPOSALS.md` — resolved Round 4 with remaining proposals.
7. `docs/ROUND5_CITY_AND_CHARACTERS_PROPOSALS.md` — resolved Round 5 with older unapproved district/character ideas.
8. `docs/ROUND5_RECORD_AND_INTERPRETATION_AUDIT.md` — previous interpretation audit.
9. `docs/ROUND6_CAST_AND_INSTITUTIONS_PROPOSALS.md` — rewritten individual-character protocol; AI-created cast withdrawn.
10. `docs/characters/QUEEN_URSULA.md` — Ursula-only approved/proposed biography.

## 3. Verified approved canon (checkpoint snapshot)

### Project and presentation

- Game title **Unbearable Conditions**, separate from other user games.
- Windows game intended in **Godot 4 / GDScript**, detailed **2D pixel art**; game source not present in GitHub.
- All bears are **quadrupedal**. Visible **emotional tears** exist in this universe. Other species require coherent animal anatomy.
- Honeyhold: bear-majority cave city, smaller cat/red panda minorities, **seven connected districts**, a **monumental central cavern** plus substantial connected cavern districts/tunnels (Dwargon-inspired but independent). Neighborhoods mix classes but access to services and property remains sharply unequal.
- Honey Marks (HM) national currency; detailed household and refuge finances, background-level macroeconomy.

### Family and roles

- Mama: seven-year-old female brown bear, gate officer and public **Briarwood Refuge** manager, second role voluntarily sought. **Gate / refuge / gate / refuge / gate / refuge / off**, three shifts of each type per week.
- Button: male, six-month brown bear littermate, clingy, candid/unfiltered, emotional, likes helping Mama, prefers indoor household/modern comforts.
- Hazel: female, six-month brown bear littermate, inquisitive, defiant, hates being ordered, linked to troublesome preschool peers. They can quarrel, injure, emotionally wound, hate and/or reconcile, with observable consequences and no mandatory positive sibling bond.
- Grandma: Mama's mother, lives nearby and looks after the cubs outside school. She is a **fired former nursery teacher**; name and reason for firing unchosen. She enjoys deliberately cruel, threatening, humiliating, hazardous hazing-like treatment; the cubs justifiably hate her. Mama knows she is mean yet relies on her because of money/work. Long-term replacement requires an involved storyline; immediate protection must remain possible.
- Development: 0–3 months den-dependent with Mama; at four months nursery; at six months structured **half-day** preschool (rough human age three). Button and Hazel at same school, different teachers and social ties. Public school includes classes of differing means; school placement/access still stratified by district and wealth.
- Preschool presentation **B now**: observable visits/scenes plus reports, not a full playable school sim; **C later** future aspiration.
- Continuous calendar aging, no mandatory narrative time skips. Juvenile legal thresholds vary by offense/emergency law, with younger cubs ordinarily under school/welfare institutions.

### State, crime and outcomes

- Honeyhold is nominally a constitutional **brown bear monarchy** with two major parties opposing welfare/civil liberties vs crown/security, smaller movements and competing media. The Queen can suspend most laws indefinitely under a declared emergency.
- Queen Ursula: **Kodiak brown bear**, **seven years old** at game start; crowned at **six months**, has ruled **six years six months**, and held genuine, practically unchecked authority even as a cub. Thoroughly spoiled, continually indulged and hardly ever denied. Publicly adorable and sincerely affectionate, **possessive** of subjects as family/property, ruthless in protecting power.
- **Newest canon:** Ursula took the throne because the **previous monarch died unexpectedly**. Their name, relation to Ursula, cause of death, and consequences are unapproved. Do not invent them.
- Panda Mafia is a specific powerful organization with business/political corruption, **not a trait of every panda**. Mama begins with a real loan, interest, due payments, missed-payment escalation and possible negotiation; numbers and precise circumstances undecided.
- Gate admissions and publicly funded Briarwood Refuge are distinct operations and legal decisions. No per-visitor clock; generous **real-time shift timer**, paused during reading/menus; disable entirely in settings for unlimited shift time.
- Branching 25+ day campaign and continuation free play. Optional revolutionary ending can kill Queen and Mama, after which player chooses **Button or Hazel** as protagonist while sibling remains autonomous. This is an approved intended ending, **not already implemented**.

### Explicit prohibitions

- **Do not create supporting characters in bulk.** 12–20 deeply simulated recurring characters is an eventual target, not an approved 20-person cast. Each individual name, biography, species and relationship requires approval.
- Old Godot v0.1 Button (cub) and Hazel (adult) are **OLD / BAD / DO NOT USE** for new canon/migration. Historical source may remain archived, not imported as these NPCs.
- Do not import the other bear games' families, clone Tensura/Dwargon or Papers, Please copyrighted assets, or invent unapproved childhood rulers, parents, regents, teachers or party leaders.
- Never report design documents as built or tested game features.

## 4. Issue register

| ID / urgency | Audit finding and evidence | Why it matters | Required next step |
|---|---|---|---|
| P0-1 Critical | Github tree contains 10 Markdown files and no Godot source/tests/art | No reproducible current playable project | Preserve original editable Godot baseline, identify later revision, import source as archival baseline and run actual tests, once code migration is authorized |
| P0-2 Critical | No runnable end-to-end family/gate/refuge loop in repo | Main gameplay promise remains unproven | Define single connected 7-day acceptance test and then implement with tests |
| P0-3 Critical | Rejected assistant-authored 20-person cast survives in Git history | Future assistant/automation could mistakenly revive it | Treat history as evidence only; require approved IDs and one-character-at-a-time authoring; add migration blacklist |
| P1-1 High | Many older documents include questions now answered, e.g. Ursula's age, Rounds 3–5 choices | Readers may treat stale proposals as canon | Maintain a canonical decision ledger and visible superseded markers; current approved doc overrides historical text |
| P1-2 High | Constitutional labels versus Ursula's de facto supreme power | Laws, elections, courts and politics could be mechanically incoherent | Specify which ordinary procedures exist, how royal commands override them, and which opposition actions are meaningful |
| P1-3 High | Ursula had near-unchecked personal authority at preschool-development age | A naive simulation gives her adult intellect or lets ministers secretly rule | Separate political authority from cognitive development; model administration as execution, not overriding sovereignty |
| P1-4 High | Grandma knowingly mistreats the cubs; Mama relies on her | Story risks normalizing harm or removing meaningful player agency | Model observable evidence, investigations, urgent protection, plausible replacement childcare and lasting family consequences |
| P1-5 High | Two government jobs / six-day workweek, childcare, HM ledgers | Economy and daily schedule may contradict resource limits | Specify salary and working hours, bills, loan terms, caregiver cover, rest-day needs and balance testing |
| P1-6 High | 25+ day branching campaign with continuous aging | Age/development and plot events may drift without a calendar | Establish calendar units, school calendar, age transitions, birthday events and age-specific jurisdiction |
| P1-7 High | Shift timer may be disabled, and pauses during reading | Can create infinite free investigation and inconsistent NPC time | Define pause boundary, what unlimited mode changes, case state, NPC aging and shift-end outcomes |
| P1-8 High | Gate entry, refuge placement, custody/adoption and justice separate | A single status field could erase guardianship or mis-sentence a resident | Define independent state machines and stable IDs; track actual institutional authority |
| P1-9 High | Former Godot Button and Hazel conflict with newly approved family names | Character identities could be overwritten or merged | Exclude blacklisted legacy NPCs; create separate canonical IDs; test no collisions |
| P2-1 Medium | Seven districts and hybrid cave map confirmed, but no final boundaries/transport/food/heat | Atmosphere not yet navigable or ecologically modeled | Build original topological map with ramps, ventilation, logistics and quadrupedal accessibility |
| P2-2 Medium | No approved party names/leaders, school teachers, staff, Grandma personal name, old monarch identity | Many social interactions require later human choices | Design individuals one at a time, not a bulk name list |
| P2-3 Medium | Ursula dossier duplicates updates from main canon, appended rather than consolidated | Conflict risk and poor readability | Give each approved fact one canonical owner; cross-link and use change log |
| P2-4 Medium | GitHub has zero issues, PRs and releases; no tracked workflows seen | Progress has little verifiable milestone tracking | Create a milestone/issue/test log only when the user chooses to manage implementation that way |

## 5. Prioritized repair plan (not authorization to implement game code)

1. **Now:** Record Ursula accession choice A; update her individual dossier and approval ledger. Preserve the former monarch as unnamed/unwritten.
2. **Now:** Commit this checkpoint and an explicit chat-review prompt. Fix stale cross-document contradictions only where the user-approved later choice is unequivocal; do not secretly finalize unanswered content.
3. **Design next:** Ursula individual questions in a **batch**, as the user requested. No mass NPC creation.
4. **Engineering next (separate authorization):** Import recoverable Godot baseline and reference HTML into appropriate historical paths with provenance; inspect and reconcile v0.1 legacy names **without importing excluded characters**. If post-v0.1 code missing, label its loss.
5. **First executable milestone:** One seven-day gate/refuge/family loop with save/load, stable IDs, legitimate clock behavior, separate money accounts, observed school routine, and a recurring refugee family, with actual automated and manual tests.
6. **Expand only after verified:** Deep NPC work, professions, courts and political decrees, city navigation, campaigns, art/audio. Each new named character requires individual approval.

## 6. Evidence and limits

This audit verifies **GitHub state and current-conversation decisions**. It does not independently inspect the contents of the historical `BriarwoodRefuge_v0.1_Windows_and_Source.zip` or Claude HTML source, execute Godot, test gameplay, or claim all older project chats were exhaustively retrieved. No claimed playable build, QA pass percentage or full-transcript completion can be inferred. The preexisting [Round 5 interpretation audit](ROUND5_RECORD_AND_INTERPRETATION_AUDIT.md) records the earlier unauthorized cast mistake; this checkpoint includes its corrected status.

## 7. Repairs actually completed during this checkpoint (documentation only)

- **Approved the newest user selection A**: the former monarch's unexpected death explains Ursula's accession. Updated `docs/APPROVED_DECISIONS.md`, `docs/characters/QUEEN_URSULA.md` and the Dwargon/Ursula research brief. No predecessor name, relation, cause of death or new NPC was invented. The latest of these three commits was `4c617ce6b0f20876fe9f5e658115f628a628b973`.
- **Created this audit/checkpoint** and `docs/CHAT_REVIEW_PROMPT_2026-11-07.md` to preserve a reusable audit process. The reviewer must always recheck future GitHub state rather than assume this snapshot is current.
- **Repaired README status wording**: said the Godot/HTML prototypes were design sources, not already merged game code; linked the new checkpoint, individual Ursula dossier and review prompt. Commit `7668584f4b0d75fbff80beecb352c76cf8e3862b`.
- **Cleaned stale Ursula wording**: removed outdated claims that coronation age, succession trigger or reign duration remain unselected, and corrected a typo and a mistaken "decades" characterization. Documentation-only corrections: `0e69d1b998f7e9ef5433b0f66ab7c679562fe864`, `354c600f297cd0cbf1b68f1b54980a44e1af4df0`, `e3e5548c0255c975010069ced6cc0db67cf09be3`.
- **Not completed:** source import, a first executable, test execution, implementation of any approved mechanic, creation of new NPCs, or selecting unapproved Queen Ursula biography details.
