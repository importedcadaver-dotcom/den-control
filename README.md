# Unbearable Conditions

A standalone 2D pixel-art Honeyhold cave-city bureaucracy, family-life, and refuge-management game. Developed by combining the original Godot **Briarwood Refuge** prototype with the strongest mechanics and worldbuilding from the HTML **Honey, Please** prototype.

## Project status

**Design consolidation and source recovery. Not yet a merged playable build.**

- Original playable foundation: `BriarwoodRefuge_v0.1_Windows_and_Source.zip` (Godot 4 / GDScript), recovered from the user's ChatGPT Library.
- Other implementation: `Honey, Please` (single-file HTML/CSS/JavaScript), provided as an attachment and reviewed.
- The later in-progress Godot UI/economy/guardianship fixes described in the Den Control conversation have **not yet been recovered as a source archive**.
- The user has approved the family canon: seven-year-old brown bear Mama, with six-month-old littermates Button and Hazel. Grandma (Mama's mother) cares for them outside school, but **deliberately enjoys emotional cruelty, threats, comfort neglect and humiliating dangerous dares, and both cubs justifiably hate her**. Mama knows she is mean, but relies on her because of work and money; ordinary replacement care requires a substantial storyline. Grandma lives nearby in her own home. Button prefers indoors, modern comforts, and human-like objects/technology over the outdoors; Hazel strongly dislikes being ordered around. Cubs stay in the den with Mama at 0–3 months, begin nursery at 4 months, and attend preschool from 6 months (roughly human three-year-old development). Both siblings attend the same school with distinct teachers and friends. They can fight, injure or emotionally hurt each other, become enemies or reconcile; bears visibly shed emotional tears. Aging advances continuously with the calendar. Their personalities are recorded in approved decisions.
- This repository begins with canon and migration documentation, not a claim that the source/build has already been pushed.

Read [approved decisions](docs/APPROVED_DECISIONS.md) before changing core mechanics, [Round 4 historical proposals](docs/ROUND4_SYSTEMS_PROPOSALS.md) the [Round 5 historical city proposal](docs/ROUND5_CITY_AND_CHARACTERS_PROPOSALS.md), the [Round 6 recurring cast and institutions proposal](docs/ROUND6_CAST_AND_INSTITUTIONS_PROPOSALS.md) (not approved), and [integration roadmap](docs/INTEGRATION_ROADMAP.md) before porting code.

## Game direction

The player is Mama Bear, a seven-year-old brown bear in **Honeyhold**: a government admissions officer, manager of a city-owned refuge, and mother of six-month-old brown bear littermates **Button** (clingy, emotional, bluntly honest, eager to help) and **Hazel** (curious, fiercely independent, increasingly involved with delinquent peers at cub school). Her city is a constitutional monarchy where the Queen can suspend most laws indefinitely during declared emergencies; it has two rival major parties (welfare/civil liberties vs royal authority/security), discriminatory practices despite official equality, competing media, punitive juvenile justice, a powerful Panda Mafia and difficult legal choices. The Queen is specifically a **Kodiak brown bear**. Household and refuge books are detailed in **Honey Marks (HM)**, while the city economy is simulated mainly in the background. Mama voluntarily applied for the second job; she works **3 fixed gate shifts, 3 fixed refuge-management shifts, and 1 day off** per week. Honeyhold has **seven connected districts** with explorable interiors and NPC routines; the initial development target is **12–20 deeply simulated recurring characters**. Workdays alternate between gate inspection and managing Briarwood Refuge. Decisions persist in the lives of the people affected.

At the gate there is **no individual inspection deadline**. The game uses a **generous real-time shift timer** that **pauses during reading and menus**. A settings toggle disables it for **unlimited shift time**. Never import the HTML prototype's 120-second countdown unchanged. Reading and investigating must remain understandable; broader schedules and consequences create pressure.

This setting is **completely independent** of the user's other bear games. A possible late-game rebellion ends with Mama killing the queen and dying as a martyr; gameplay then continues from Button and Hazel's perspectives, with their family history preserved.

## Development principles

- Keep persistent animal IDs across gate, city, refuge, home, custody, and saves.
- All bears are quadrupedal. Animate locomotion and design physical interactions, classroom props, and office furniture for animals moving on all fours.
- Distinguish objective truth, evidence currently known, legal violations, player actions, and subsequent outcomes.
- Simulate visible day-to-day behavior and consequences, not just event text.
- Preserve existing working Godot source and test fixes before attempting any merge.
- Avoid copying `Papers, Please` art, assets, text, or exact puzzles; develop original family-centric mechanics.
- Preserve the approved Button and Hazel identities and traits, their Grandma's malicious care and Mama's knowledge, and the chosen continuous aging. Do not assume unapproved appearances, surnames, Grandma name, or story events.
- Detect existing Godot v0.1 **Button** (a cub) and **Hazel** (an adult bear) before assigning canonical player-family IDs; never merge by display name.
- Keep a playable Godot Windows build, tests, and known-limitations report as real deliverables.

## Sources and provenance

This README and the design docs derive from the user's two uploaded game conversations, the supplied Claude HTML source, the recovered Briarwood v0.1 archive, and approved choices made in this ChatGPT conversation. They are **not** evidence that a new executable has been built or tested.
