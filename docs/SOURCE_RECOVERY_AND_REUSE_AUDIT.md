# Unbearable Conditions — Source Recovery and Reuse Audit

**Date:** 2026-11-07 (America/Los_Angeles)  
**Purpose:** Establish what is actually available from the original Godot and Claude prototypes before production architecture or feature work.  
**Status:** Both original implementation sources recovered from this conversation's attachments and inspected statically. **Neither has been merged into the active Unbearable Conditions project.**

## 1. Recovered source inventory

### A. Briarwood Refuge v0.1 — Godot 4 / GDScript

- **Original attachment:** BriarwoodRefuge_v0.1_Windows_and_Source.zip
- **Size:** 39,945,783 bytes.
- **SHA-256:** fd519df3f8e93d29c9b33c71029ae214d9204f946e71374fa3d8f72efa548eb8
- **Archive integrity:** unzip -t completed with no compressed-data errors.
- **Archive contents:** 28 entries, 110,116,452 uncompressed bytes. Includes a 109,326,984-byte Windows executable, source, test records and five screenshots.
- **Editable source:** 19 files, 76,033 bytes, under the source directory. A source-only archive was prepared for easier transfer; it excludes the Windows executable and screenshots.
- **Engine:** Godot 4.7.2 stable, Windows x86_64, Compatibility renderer, according to the included README and QA record. project.godot identifies Godot 4.7 / GL Compatibility.
- **Current repository status:** No Godot source files are yet tracked in den-control. This is a recovered attachment, not a GitHub source import.

Source layout:
- **scripts/world.gd** — persistent animal records, cases, needs, decisions, care, adoption, follow-ups, simulation tick and JSON save/restore.
- **scripts/main.gd** — dynamic Control-based UI, inspection/refuge/cottage/journal views, input, dialogs, cheats, save/load and sound.
- **scripts/art.gd** — procedural pixel drawing, room and booth presentation, animal sprites and hit-testing.
- **tests/test_world.gd** — simulation, decisions, follow-ups, adoption, needs, save/load and randomized histories.
- **tests/test_ui.gd** — input-driven interface walkthrough.
- **build.ps1**, project settings, export preset and stored result JSON are also present.

### B. Honey, Please — Layer 1 v3 — HTML/CSS/JavaScript

- **Recovered attachment:** Pasted text(20261107-050627).txt, containing the complete HTML document.
- **Extracted review copy:** honey-please-2.html.
- **Size:** 22,347 bytes.
- **SHA-256:** e6e3dd6a78b5559c81cb58f2d0176b8090f9cbc989ee1dd79a1d97000d141bb
- **Validation:** Extracted inline JavaScript passed node --check using Node 22.16.0. This confirms syntax only; it is not a browser playtest.
- **Current repository status:** Not tracked in den-control yet.

The HTML prototype contains a single inspection-booth screen, draggable document panels, field comparison, a regulations booklet, approve/deny stamps, a visitor queue, short dialogue, a daily Gazette headline, staged rule changes and a 120-second candle timer.

### C. Later Godot redesign — transcript evidence, source missing

The attached Den Control transcript records a later revision after v0.1:
- Reported fixes for free cottage food, repeated wages on empty post-campaign days, guardianship overwritten by a follow-up, and malformed saves.
- A redesigned inspection interface with explicit comparisons and an outcome panel.
- A daily budget preview and a counterfeit-permit case.
- A reported four-day story/playthrough test.

**The later Godot source archive or patch is not present among the recovered attachments.** These statements are transcript claims, not inspected code. Do not assume the fixes are in v0.1, and do not claim they are merged until the later source is recovered and compared.

## 2. What the Godot baseline actually provides

The v0.1 source is a genuine small game foundation, not merely a mockup. It includes:
- One persistent dictionary of 14 authored animals, with stable string IDs.
- Six fixed arrival cases and four gate outcomes: admit, exception, hold and deny.
- A refuge, cottage, inspection booth and journal.
- Basic animal needs (hunger, energy, comfort), individual memories, trust, affection and simple bonds.
- Autonomous action selection for exploring, playing, sleeping, eating, cuddling and seeking a guardian.
- Feeding, comfort, play, rest, conversations, adoption, supplies and bed purchases.
- Follow-up story threads and reopening held/denied cases.
- A cheat menu, manual/automatic saving and a previous-save backup.
- Procedural pixel artwork and simple generated interface sounds.

The screenshots show a recognizable first-pass pixel-art direction. The inspection view uses a fixed 1280×800 layout, three document cards, a side decision panel and a top strip with many controls. The refuge view shows two room levels, residents, needs and direct care buttons.

## 3. What is reusable

| Existing element | Reuse decision | Reason / required treatment |
|---|---|---|
| Godot 4.7.2 project baseline and Windows export configuration | Reuse as an engine/version reference; preserve original project unchanged | It is a known source baseline. Confirm the target machine's installed version before building. |
| Stable identity idea and persistent animal registry | Reuse the principle, redesign the schema | IDs must be independent of display names, scenes, households and case templates. |
| Memories, relationship values and follow-up threads | Reuse selectively | Keep event history, but model relationships and legal/guardian state separately. |
| Basic needs and autonomous action prototype | Reuse as a behavior proof-of-concept | Replace the simple trait/threshold selector with persistent intentions and needs-aware decisions. |
| Care, feeding and adoption action patterns | Reuse concepts, rewrite rules | Separate private household costs, public refuge costs and legal placement authority. |
| Save/restore and backup approach | Reuse the safety goals, redesign implementation | New schema, validation, backups, recovery tests and explicit migration policy required. |
| SceneTree simulation and input-driven UI test approach | Reuse and expand | Add deterministic seeds, integration acceptance tests and edge-case coverage. |
| Procedural pixel-art drawing technique | Reuse as a temporary production technique/reference | New bear/cub anatomy, quadrupedal poses, consistent perspective and a coherent art pipeline are required. |
| Main scene's dynamic Control-based UI | Reuse selectively | Reorganize into clear work surfaces and contextual panels; do not preserve the crowded layout. |

## 4. What must be rebuilt or redesigned

### Godot v0.1
- **Seeded characters and stories:** discard from active canon. The v0.1 Button is an unrelated cub; v0.1 Hazel is an adult bear. Both are **OLD / BAD / DO NOT USE** for the new game. Do not merge by display name.
- **World model:** world.gd is a large mixed responsibility script. Separate identity, household, legal rights, case state, schedules, finance, behavior and presentation.
- **Legal model:** entry permission, guardianship, custody, refuge eligibility and actual refuge placement must be independent states. v0.1 does not provide the complete distinctions required by canon.
- **Economy:** v0.1 has one shared coin balance, one food stock, fixed prices and a repeated daily payment. Rebuild for Honey Marks, separate household and city-owned refuge accounts, job wages, expenses and a distinct debt liability.
- **Calendar and work:** v0.1 advances generic days and ages residents by one day in selected locations. It does not implement the approved 3 gate / 3 refuge / 1 off schedule or a real-time shift clock.
- **Family:** no Mama, approved Button/Hazel siblings, Grandma, preschool routine or childcare dependency is implemented.
- **Autonomy:** current behavior is a small threshold/trait heuristic. It is not a persistent intention system.
- **UI:** fixed-position layout and too many always-visible controls need a new hierarchy, clearer labels and contextual explanation.
- **Art:** current source procedurally draws bears and cats only. It does not yet meet the approved quadrupedal bear society, cub/adult anatomy, red panda population or production-quality animation requirements.
- **Settings:** sound toggle exists in the menu, but the approved shift-timer settings and a complete settings screen do not.
- **Long-term systems:** seven-district navigation, school, government, employment, courts, media, Panda Mafia debt, campaign and rebellion are not implemented.

### Honey, Please HTML
- Do not use it as the production engine or merge its JavaScript game loop into Godot.
- Do not import its 120-second timer; current canon requires a generous shift-level timer that pauses during reading/menus and can be disabled.
- Do not import Hibernia, Supervisor Honeywell, its randomly generated named cast, species list, family stories or Gazette copy as canon.
- Its binary approve/deny validator is too simple for documented exceptions, holds, moral choices, false evidence and separate entry/refuge decisions.
- Its random adult-plus-cubs party generator does not create persistent people or reliable kinship histories.
- It has no save system, refuge, home, household economy, resident simulation or multi-day family continuity.

**Useful presentation/design references from HTML:** the tactile desk composition, movable documents, physical-feeling stamps, visible rulebook, Gazette/newspaper framing and concise visitor dialogue. Reinterpret these in the original Honeyhold setting and the approved UI hierarchy; do not copy its timer or content.

## 5. Static inspection findings and verification limits

- The Godot archive passed ZIP integrity testing.
- The stored QA record reports **1,336 simulation assertions**, including 30 seeded alternate histories, and **18 input-driven UI assertions**. The stored export record reports a Windows x86_64 Godot 4.7.2 export and scene checks.
- These are **historical stored results**. They were not rerun in this environment.
- The current Linux runner has no godot or godot4 executable on PATH, so GDScript parsing, Godot test execution and Windows executable launch could not be repeated here.
- The HTML inline JavaScript passed a Node syntax check; no browser interaction or usability playtest was completed in this audit.
- The transcript reports later Godot fixes, but the later source was not recovered.

## 6. Production conclusion

Use **Godot 4.7.2 / GDScript** as the provisional production baseline because the existing playable foundation is already built in that engine and has a documented Windows export. Preserve v0.1 unchanged as a legacy reference, create a clean Unbearable Conditions project, and port only verified reusable systems after their data contracts are rewritten.

Treat Honey, Please as a focused reference for booth presentation and document interactions, not as a second game to combine line-by-line.

The first production milestone is now the approved connected slice: **one complete gate day, one complete refuge day and home/family gameplay**, with detailed gate cases, hands-on refuge care plus management, directly interactive yet autonomous cubs, coherent first-pass pixel art, save/load and cheats.

No source code was modified during this inspection.