# Unbearable Conditions

A standalone 2D pixel-art Honeyhold cave-city bureaucracy, family-life, and refuge-management game. Developed by combining the original Godot **Briarwood Refuge** prototype with the strongest mechanics and worldbuilding from the HTML **Honey, Please** prototype.

## Project status

**Design consolidation and source recovery. Not yet a merged playable build.**

- Original playable foundation: `BriarwoodRefuge_v0.1_Windows_and_Source.zip` (Godot 4 / GDScript), recovered from the user's ChatGPT Library.
- Other implementation: `Honey, Please` (single-file HTML/CSS/JavaScript), provided as an attachment and reviewed.
- The later in-progress Godot UI/economy/guardianship fixes described in the Den Control conversation have **not yet been recovered as a source archive**.
- The user has approved the family canon: seven-year-old brown bear Mama, with six-month-old littermates Button and Hazel. Grandma (Mama's mother) cares for them outside school, but **deliberately enjoys emotional cruelty, threats, comfort neglect and humiliating dangerous dares, and both cubs justifiably hate her**. Mama knows she is mean, but relies on her because of work and money; ordinary replacement care requires a substantial storyline. Grandma lives nearby in her own home. Button prefers indoors, modern comforts, and human-like objects/technology over the outdoors; Hazel strongly dislikes being ordered around. Cubs stay in the den with Mama at 0–3 months, begin nursery at 4 months, and attend preschool from 6 months (roughly human three-year-old development). Both siblings attend the same school with distinct teachers and friends. They can fight, injure or emotionally hurt each other, become enemies or reconcile; bears visibly shed emotional tears. Aging advances continuously with the calendar. Their personalities are recorded in approved decisions.
- This repository begins with canon and migration documentation, not a claim that the source/build has already been pushed.
- The previous AI-invented 20-person Round 6 cast is **rejected in full**. **All new characters must be created individually with the user.** No prior invented classmates, coworkers or party leaders are approved. The 12–20 goal is an eventual count, not a ready-made roster.

Read [Dwargon-inspired Honeyhold architecture and Queen Ursula research](docs/DWARGON_INSPIRATION_AND_QUEEN_URSULA_RESEARCH.md) for a sourced reference brief (new layouts and character details remain proposals).

Read [approved decisions](docs/APPROVED_DECISIONS.md) before changing core mechanics, [Round 4 historical proposals](docs/ROUND4_SYSTEMS_PROPOSALS.md) the [Round 5 historical city proposal](docs/ROUND5_CITY_AND_CHARACTERS_PROPOSALS.md), the [Round 6 individual-character design protocol](docs/ROUND6_CAST_AND_INSTITUTIONS_PROPOSALS.md) (former AI-made cast withdrawn), and [integration roadmap](docs/INTEGRATION_ROADMAP.md) before porting code.

## Game direction

The player is Mama Bear, a seven-year-old brown bear in **Honeyhold**: a government admissions officer, manager of a city-owned refuge, and mother of six-month-old brown bear littermates **Button** (clingy, emotional, bluntly honest, eager to help) and **Hazel** (curious, fiercely independent, increasingly involved with delinquent peers at cub school). Her city is a constitutional monarchy where the Queen can suspend most laws indefinitely during declared emergencies; it has two rival major parties (welfare/civil liberties vs royal authority/security), discriminatory practices despite official equality, competing media, punitive juvenile justice, a powerful Panda Mafia and difficult legal choices. The Queen is specifically **Queen Ursula, a Kodiak brown bear**, publicly affectionate and privately ruthless. Household and refuge books are detailed in **Honey Marks (HM)**, while the city economy is simulated mainly in the background. Grandma was a **nursery teacher and was fired**; the reason and her personal name are undecided. Mama voluntarily applied for the second job; she works **3 fixed gate shifts, 3 fixed refuge-management shifts, and 1 day off** per week. Honeyhold has **seven connected districts** with explorable interiors and NPC routines. Its **mountain cave-city concept takes broad inspiration from Dwargon in Tensura**, while its exact layout and technology remain to be selected; the initial development target is **12–20 deeply simulated recurring characters**. Workdays alternate between gate inspection and managing Briarwood Refuge. Decisions persist in the lives of the people affected.

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

## Sources and provenance

This README and the design docs derive from the user's two uploaded game conversations, the supplied Claude HTML source, the recovered Briarwood v0.1 archive, and approved choices made in this ChatGPT conversation. They are **not** evidence that a new executable has been built or tested.
