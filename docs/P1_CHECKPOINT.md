# Unbearable Conditions — P1 Source Preservation and Clean Project Setup

**Status:** Clean project source and test harness committed; legacy source preserved verbatim in the separate downloadable P1 recovery package. Godot engine test execution remains unverified.

## Completed
- Verified original Briarwood v0.1 ZIP integrity and source SHA-256; copied its full editable source unchanged to a separate legacy folder in the P1 downloadable package.
- Recovered unchanged Honey, Please Layer 1 v3 HTML for reference; full reference included in the separate P1 downloadable package.
- Examined the later redesign transcript; no complete revised Godot source was recovered.
- Created a separate clean Godot 4.7.2 project shell under `game/`, without importing any v0.1 world state.
- Seeded exactly five user-approved individuals with new IDs: Mama, Button, Hazel, Grandma (personal name not chosen), Ursula.
- Added headless GDScript foundation contract tests and Python structural/canon tests.
- Audited the worldbuilding dependency gate: none of the remaining royal biography or district/party naming questions block P1.

## Verification and limits
- **Seven Python tests passed** in the complete P1 recovery bundle, including individual bytewise legacy-source hashes (SHA-256 inventory: `legacy/BriarwoodRefuge_v0.1/SOURCE_SHA256SUMS.json`).
- The GitHub test subset is designed to run without the large historical source archive.
- Godot executable is not available in the current sandbox; the GDScript tests are written but **not executed**.
- This remains **P1 project setup**, not a playable home, gate or refuge game.
- **The entire legacy source is in the downloadable P1 recovery package, not yet uploaded to the GitHub legacy directory.** Its archival README and hashes are committed here to avoid falsely claiming otherwise.

## Next: P2
Implement a persistent world state, event/case identity, household and guardianship/custody transitions, shift/calendar clocks, separate Honey Marks ledgers and versioned save/load. The next narrative case can use anonymous test records until the user individually approves any recurring new characters.

## Delivery verification

- Clean Godot shell committed as [`ddf1385`](https://github.com/importedcadaver-dotcom/den-control/commit/ddf1385f72fbef5dd583b5f0be8486750e1d1a4d).
- Complete source-and-legacy ZIP generated, ZIP integrity checked; SHA-256 `a9b9eb9d7eb4fa320428a559067f594d38499505a756df61bae03a5da935581c`.
- Python/pytest: **7 passed, 0 failed** on the complete recovery bundle.
- GitHub live files independently verified for canonical IDs, schedule, main-scene references, test presence and absence of legacy source imports.
- Godot runtime tests and Windows export: **not run**. No claim of a working game build.
