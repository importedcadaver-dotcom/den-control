# Unbearable Conditions — P3 Home and Family Simulation

**Stage:** P3 functional home sandbox, separate from P4 gate and P5 refuge.

## Implementation

- `game/scripts/home/home_system.gd`: authoritative deterministic cub needs, intentions, autonomy, stress, memories, carrying, sibling relationship changes, emotional conflict, occasional physical injury, treatment, parent interactions and a bounded prototype pantry.
- `game/scripts/world/world_state.gd`: P2 persistent world now owns the home state and records significant home events. Saved-state schema bumped **2 → 3** (not compatible with earlier P2 developer save fixtures). No existing player saves were promised migration.
- `game/scripts/home/home_view.gd`: visible in-engine home space with consistent procedural pixel art, quadrupedal Mama and two visibly smaller cubs, selectable animals, care buttons, need/relationship readouts, autonomous timer, and save/load.
- `game/scripts/main.gd`: boots P3 home simulation only; it does **not** run school, work shifts or legal cases. Existing P2 backend remains accessible through its shared WorldState instance.
- `game/tests/test_p3.gd`: Godot behavioral acceptance tests for selection, direct interactions, food accounting, intentional refusals, autonomous activity, conflict, physical/emotional consequences, injury care, schema validation and save round trips.
- `tests/test_p3_static.py`: additional structural/canon checks; GitHub Actions updated to run headless P3 and a scene startup smoke check.

## Canon protection

- **Only approved identities:** Mama, Button, Hazel, Grandma (unnamed), Queen Ursula. Only Mama and the two cubs are rendered in this P3 home room. Nobody else is invented.
- Button and Hazel are six-month-old biological littermates. Both are quadrupedal and have visually distinct body shapes/color values (provisional palette, **not** user-approved coat markings).
- Button seeks Mama/indoors; Hazel explores, dislikes instructions, and can refuse. Both have persistent needs and intentions.
- Their relationship starts at a **neutral test baseline**, not predeclared hate. Independent behavior can create disputes, fights, emotional harm, possible minor physical injuries or opportunities to improve relations. Reconciliation is incremental and conditional, never forced.
- Tears are visible when a cub is distressed. Injury/health changes and memories survive save/load.
- Grandma's established cruelty and current childcare role are **preserved in canon**, not rewritten. P3 does **not** depict her care or events; the later scheduled family/childcare simulation must implement the approved consequences without inventing isolated historical incidents.
- The P3 pantry begins with **six prototype portions**, a provisional gameplay test fixture, not an approved household inventory or free food loop. Each feed consumes one; depletion blocks further feeding. No Honey Marks balance or Mafia debt amount is fabricated.

## Verification status

**Verified:** [GitHub Actions run 42527012709](https://github.com/importedcadaver-dotcom/den-control/actions/runs/42527012709) completed successfully with official **Godot 4.7.2**: P1 **7/7**, P2 **56/56**, P3 **67/67** behavioral assertions, plus a headless project import and main-scene startup smoke test. The GitHub Python CI suite passed **24/24** structural checks. The separate full local source package passed **26/26**, including two legacy-source integrity tests absent from the GitHub checkout. This is verified source behavior and scene startup, **not a Windows gameplay/visual playtest**. The local tool environment did not have Godot; testing ran in GitHub CI.

**P3 scope limitation:** this is a playable home *sandbox*, **not** the first approved complete production milestone (one gate day + refuge day + home). Animation is procedural and simple; no Windows export, sound, complete school, economy gameplay, Grandma care scenes, full city map or authored gate cases are included.

## Next engineering stage

P4: complete gate workday using the same persistent IDs and records. Preserve detailed+routine cases, no per-entrant timer, and original entry/legal/refuge separation. Author new recurring applicants only after individual user approval; anonymous test subjects are fine for QA.

## Fixes verified during P3 delivery

- An initial save/load equality check failed because Godot JSON parsing represents integer-valued JSON numbers as floating values (for example `0` → `0.0`). Tests now compare **JSON semantic values**, not raw Variant storage types; data and character memories still round-trip correctly. The malformed-state rejection tests remain in place.
- An independent test now advances new cubs autonomously through 64 simulation steps, without arranging a fight in advance, and verifies disagreements and eventual sibling conflict can occur naturally. The manually configured injury/regression case remains separately tested.
- The UI now shows each selected cub's most recent memory alongside needs and sibling relationship status, so consequences are discoverable rather than hidden behind an event counter.
- **No added recurring characters; no gate/refuge shifts.** The first P6 two-day release and Windows interactive playtest are still incomplete.

## Packaging

A separate downloadable `Unbearable_Conditions_P3_Home_Sandbox.zip` contains the Godot source, tests, P3 checkpoint and historical editable-source references. ZIP integrity was verified before delivery. It is **source code to open in Godot, not a Windows executable**.
