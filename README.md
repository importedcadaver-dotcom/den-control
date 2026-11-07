# Den Control

A standalone 2D pixel-art cave-city bureaucracy, family-life, and refuge-management game. Developed by combining the original Godot **Briarwood Refuge** prototype with the strongest mechanics and worldbuilding from the HTML **Honey, Please** prototype.

## Project status

**Design consolidation and source recovery. Not yet a merged playable build.**

- Original playable foundation: `BriarwoodRefuge_v0.1_Windows_and_Source.zip` (Godot 4 / GDScript), recovered from the user's ChatGPT Library.
- Other implementation: `Honey, Please` (single-file HTML/CSS/JavaScript), provided as an attachment and reviewed.
- The later in-progress Godot UI/economy/guardianship fixes described in the Den Control conversation have **not yet been recovered as a source archive**.
- The user's more detailed Mama-cub choices reportedly live in the **full Claude chat**, but those passages have not been provided in the available transcript extracts.
- This repository begins with canon and migration documentation, not a claim that the source/build has already been pushed.

Read [approved decisions](docs/APPROVED_DECISIONS.md) before changing core mechanics, and [integration roadmap](docs/INTEGRATION_ROADMAP.md) before porting code.

## Game direction

The player is Mama Bear: a government admissions officer, the manager of a city-owned refuge, and mother of two same-age biological cubs. Her city is a constitutional monarchy with changing rules, social factions, organized crime, and difficult legal choices. Workdays alternate between gate inspection and managing Briarwood Refuge. Decisions persist in the lives of the people affected.

At the gate there is **no real-time inspection countdown**. Reading and investigating must be understandable; the broader day schedule, costs, obligations, and consequences create pressure.

This setting is **completely independent** of the user's other bear games.

## Development principles

- Keep persistent animal IDs across gate, city, refuge, home, custody, and saves.
- Distinguish objective truth, evidence currently known, legal violations, player actions, and subsequent outcomes.
- Simulate visible day-to-day behavior and consequences, not just event text.
- Preserve existing working Godot source and test fixes before attempting any merge.
- Avoid copying `Papers, Please` art, assets, text, or exact puzzles; develop original family-centric mechanics.
- Do not fill missing cub canon with guessed names or traits.
- Keep a playable Godot Windows build, tests, and known-limitations report as real deliverables.

## Sources and provenance

This README and the design docs derive from the user's two uploaded game conversations, the supplied Claude HTML source, the recovered Briarwood v0.1 archive, and approved choices made in this ChatGPT conversation. They are **not** evidence that a new executable has been built or tested.
