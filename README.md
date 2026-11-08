# Unbearable Conditions

An in-development 2D pixel-art Honeyhold cave-city bureaucracy, family-life, and refuge-management game. The design draws on the original Godot **Briarwood Refuge** prototype and selected ideas from the HTML **Honey, Please** prototype. **These codebases have not yet been merged here.**

## Project status

**P3 interactive home sandbox implemented and headless-verified. The full gate/refuge/family game is not yet built.**

- Previously referenced original playable foundation: `BriarwoodRefuge_v0.1_Windows_and_Source.zip` (Godot 4 / GDScript), reported as recovered from the user's ChatGPT Library in earlier work. **Not present as source in this repo.**
- Other historical implementation: `Honey, Please` (single-file HTML/CSS/JavaScript), provided and reviewed in an earlier chat. **Not present in this repo.**
- The later in-progress Godot UI/economy/guardianship fixes described in the Den Control conversation have **not yet been recovered as a source archive**.
- The user has approved the family canon: seven-year-old brown bear Mama, with six-month-old littermates Button and Hazel. Grandma (Mama's mother) cares for them outside school, but **deliberately enjoys emotional cruelty, threats, comfort neglect and humiliating dangerous dares, and both cubs justifiably hate her**. Mama knows she is mean, but relies on her because of work and money; ordinary replacement care requires a substantial storyline. Grandma lives nearby in her own home. Button prefers indoors, modern comforts, and human-like objects/technology over the outdoors; Hazel strongly dislikes being ordered around. Cubs stay in the den with Mama at 0–3 months, begin nursery at 4 months, and attend preschool from 6 months (roughly human three-year-old development). Both siblings attend the same school with distinct teachers and friends. They can fight, injure or emotionally hurt each other, become enemies or reconcile; bears visibly shed emotional tears. Aging advances continuously with the calendar. Their personalities are recorded in approved decisions.
- The repository contains a verified **P3 Godot home scene** under `game/scripts/home/`: visible Mama and two cubs, direct care and carrying, autonomous needs and intentions, sibling conflicts, memories, a finite demo pantry and save/load. The gate/refuge work shifts and the first connected two-day milestone remain unimplemented.
- The previous AI-invented 20-person Round 6 cast is **rejected in full**. **All new characters must be created individually with the user.** No prior invented classmates, coworkers or party leaders are approved. The 12–20 goal is an eventual count, not a ready-made roster.

Read [Dwargon-inspired Honeyhold architecture and Queen Ursula research](docs/DWARGON_INSPIRATION_AND_QUEEN_URSULA_RESEARCH.md) for a sourced reference brief (new layouts and character details remain proposals).

**P1–P3 engineering:** [P3 home code](game/scripts/home/) · [P3 checkpoint](docs/P3_CHECKPOINT.md) · [P3 Godot tests](game/tests/test_p3.gd) · [Godot source](game/) · [P2 world state](game/scripts/world/world_state.gd) · [P2 save system](game/scripts/world/save_store.gd) · [P2 checkpoint](docs/P2_CHECKPOINT.md) · [P2 state schema](docs/P2_STATE_SCHEMA.md) · [P2 test report](docs/P2_TEST_REPORT.md) · [P1 checkpoint](docs/P1_CHECKPOINT.md) · [Worldbuilding gate](docs/P1_WORLDBUILDING_GATE.md) · [Later revision gap matrix](docs/P1_LATER_REVISION_GAP_MATRIX.md)

**Production documents:** [Approved first production plan](docs/PRODUCTION_PLAN_V0_1.md) · [Source recovery and reuse audit](docs/SOURCE_RECOVERY_AND_REUSE_AUDIT.md) · [Recovered source manifest](docs/RECOVERED_SOURCE_MANIFEST.md)

**Project checkpoint and review:** [2026-11-07 audit and milestone checkpoint](docs/CHECKPOINT_2026-11-07.md) · [Reusable chat/GitHub review prompt](docs/CHAT_REVIEW_PROMPT_2026-11-07.md)

**Canonical references:** [Approved decisions](docs/APPROVED_DECISIONS.md) · [Queen Ursula's individual dossier](docs/characters/QUEEN_URSULA.md) · [Technical integration roadmap](docs/INTEGRATION_ROADMAP.md)

**Historical proposals (not canon):** [Round 3](docs/ROUND3_PROPOSALS.md) · [Round 4](docs/ROUND4_SYSTEMS_PROPOSALS.md) · [Round 5](docs/ROUND5_CITY_AND_CHARACTERS_PROPOSALS.md) · [Round 6 individual-character protocol](docs/ROUND6_CAST_AND_INSTITUTIONS_PROPOSALS.md) (former AI-made cast withdrawn).

## Game direction

The player is Mama Bear, a seven-year-old brown bear in **Honeyhold**: a government admissions officer, manager of a city-owned refuge, and mother of six-month-old brown bear littermates **Button** (clingy, emotional, bluntly honest, eager to help) and **Hazel** (curious, fiercely independent, increasingly involved with delinquent peers at cub school). Her city is a constitutional monarchy where the Queen can suspend most laws indefinitely during declared emergencies; it has two rival major parties (welfare/civil liberties vs royal authority/security), discriminatory practices despite official equality, competing media, punitive juvenile justice, a powerful Panda Mafia and difficult legal choices. The Queen is **Queen Ursula, a seven-year-old Kodiak brown bear**, crowned at six months after the **previous monarch died unexpectedly** (identity and cause of death not approved). She has held practical supreme power throughout her **six-year-six-month reign**. Her affection for subjects and their adoration is **genuine but possessive**: she sees the city almost as her own family/property and is dangerous when her authority is rejected. Household and refuge books are detailed in **Honey Marks (HM)**, while the city economy is simulated mainly in the background. Grandma was a **nursery teacher and was fired**; the reason and her personal name are undecided. Mama voluntarily applied for the second job; she works **3 fixed gate shifts, 3 fixed refuge-management shifts, and 1 day off** per week. Honeyhold has **seven connected districts** with explorable interiors and NPC routines. Its **mountain cave-city concept takes broad inspiration from Dwargon in Tensura**. The approved **hybrid layout** has a monumental central cavern and districts extending into major adjoining chambers and tunnels; the exact map, district allocation and technology remain unselected; the initial development target is **12–20 deeply simulated recurring characters**. Workdays alternate between gate inspection and managing Briarwood Refuge. Decisions persist in the lives of the people affected.

At the gate there is **no individual inspection deadline**. The game uses a **generous real-time shift timer** that **pauses during reading and menus**. A settings toggle disables it for **unlimited shift time**. Never import the HTML prototype's 120-second countdown unchanged. Reading and investigating must remain understandable; broader schedules and consequences create pressure.

This setting is **completely independent** of the user's other bear games. A possible late-game rebellion ends with Mama killing the queen and dying as a martyr; gameplay then continues from Button and Hazel's perspectives, with their family history preserved.

## Development principles

- Keep persistent animal IDs across gate, city, refuge, home, custody, and saves.
- All bears are quadrupedal. Animate locomotion and design physical interactions, classroom props, and office furniture for animals moving on all fours.
- Distinguish objective truth, evidence currently known, legal violations, player actions, and subsequent outcomes.
- Simulate visible day-to-day behavior and consequences, not just event text.
- Preserve existing working Godot source and test fixes before attempting any merge.
- Avoid copying `Papers, Please` art, assets, text, or exact puzzles; develop original family-centric mechanics.
- **Create every new NPC individually with the user**; never bulk-generate a character roster to meet a numerical count.
- Preserve the approved Button and Hazel identities and traits, their Grandma's malicious care and Mama's knowledge, and the chosen continuous aging. Do not assume unapproved appearances, surnames, Grandma name, or story events.
- The v0.1 legacy **Button** (cub) and **Hazel** (adult) are **OLD / BAD / DO NOT USE**. Do not adapt or import them into the merged game's canon or saves. Retain original source as a historical archive only; the approved siblings need new stable IDs.
- Keep a playable Godot Windows build, tests, and known-limitations report as real deliverables.

## P1 verification

- Seven Python foundation tests passed in the complete locally prepared P1 recovery package. The GitHub test subset can be run independently with Python/pytest.
- **GitHub Actions successfully executed the Godot headless tests** on an Ubuntu standard runner using official Godot 4.7.2: P1 **7 checks, 0 failures**; P2 **56 checks, 0 failures**. [Verified CI run](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42522146379). Windows launch and gameplay remain unverified.
- **Historical source is contained in the downloadable P1 recovery package, not yet in the GitHub legacy directory**; only its manifests and integrity hashes are in GitHub. The new clean shell is committed separately.

## Sources and provenance

This README and the design docs derive from the user's two uploaded game conversations, the supplied Claude HTML source, the recovered Briarwood v0.1 archive, and approved choices made in this ChatGPT conversation. They are **not** evidence that a new executable has been built or tested.

## P2 persistent-world foundation

The P2 source under `game/scripts/world/` now defines canonical identities and households, guardian/legal links separate from temporary care, independent gate and refuge status, day/phase calendar and 3-gate/3-refuge/1-off rotation, independent household/refuge Honey Marks ledgers with **unconfigured** opening balances and Mafia loan terms, a bounded shift clock, append-only event history and versioned JSON save/load with pre-validation and backups.

The system initializes only **Mama, Button, Hazel, Grandma and Queen Ursula**. Any anonymous test subject exists only in explicit QA mode. The old unrelated v0.1 Button and adult Hazel are **OLD / BAD / DO NOT USE**.

**Verification:** 19 Python static checks passed in the full local source package; the GitHub CI repository subset passed **17 tests**. The [GitHub Actions workflow](.github/workflows/foundation.yml) also passed official **Godot 4.7.2** headless validation: **P1 7/7, P2 56/56** ([run evidence](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42522146379)). Windows export and interactive gameplay remain unverified. **P3 home sandbox is verified; P4 gate, P5 refuge and P6 two-day game are not built.**

## P3 home sandbox — verified November 8, 2026

The new [interactive home scene](game/scripts/home/home_view.gd) uses the same [persistent P2 world model](game/scripts/world/world_state.gd) and [save service](game/scripts/world/save_store.gd). Mama can feed, cuddle, play, wash, carry, put down, make requests, separate siblings and offer first aid. Button and Hazel have distinct autonomous intentions and persistent needs, memories and sibling dynamics, with possible emotional conflict, refusal and injury. Their sibling relationship starts neutral as a **provisional baseline**, not canonized love or hatred; relatives and personality canon remain unchanged. Visual tears and four-legged poses are part of the simple procedural pixel art.

**Godot 4.7.2 CI verified:** P1 **7/7**, P2 **56/56**, P3 **67/67** assertions, **26/26 Python source tests**, headless editor import and main-scene boot — [verified Actions run](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42527012709). **No Windows executable, visual review, full childcare, gate or refuge shift yet.** The finite six-portion P3 pantry is a temporary gameplay test fixture, not approved HM starting inventory. Save schema version is now **3**, and P2 developer saves are not supported without a future explicit migration.

**Next milestone:** P4 gate workday (detailed cases plus routine arrivals) using the existing shared world state and no newly invented named characters.
