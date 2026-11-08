# P2 Persistent World State — Data Contract v2

**This is an implementation data contract, not new worldbuilding canon.** The initial world contains exactly Mama, Button, Hazel, Grandma (unnamed) and Queen Ursula; the game does **not** load old Briarwood v0.1 characters.

## State sections

| Section | Type and responsibility | Invariant |
|---|---|---|
| `schema_version` | Integer, fixed at 2 | Any other version is rejected on load; no v0.1 migration is assumed |
| `world_id` | Namespace identifier | Stable world identity for future persistent save records |
| `qa_mode` | Boolean, off in new games | Anonymous QA subjects may be registered only in explicit QA mode |
| `calendar` | `day_index` + `phase` | Nonnegative day, phases `morning → daytime → evening → next morning`; fixed 3/3/1 work duty |
| `characters` | Dictionary keyed by stable `uc.` IDs | Five immutable approved core identities; QA-only subjects have blank names and `uc.qa.` IDs |
| `households` | Member links | Household membership is not the same as custody or temporary childcare |
| `guardian_links` | Child → guardian legal links | A change requires a unique approved, explicitly guardianship-scoped order |
| `temporary_care` | Child → current caretaker | Does not change `guardian_links` |
| `legal_orders` | Authorized guardianship change records | A generic case follow-up has no authority to mutate a guardian |
| `case_records` | Investigation/case facts | Independent of the resulting gate decision |
| `entry_permissions` | Subject → authorization/hold/denial | An entry decision does not automatically place someone in Briarwood |
| `refuge_placements` | Subject → placed/released + case | Placement requires authorized entry plus a separate decision; never silently changes guardian |
| `financials.ledgers.household` | Opening balance, balance, transactions | No personal expense is charged to the public refuge account |
| `financials.ledgers.refuge` | Separate public ledger | No refuge expense is charged to Mama's personal account |
| `financials.mafia_debt` | Principal/outstanding/interest/due/status | Unapproved amounts are `null`; payments use household funds only |
| `shift_clock` | Duration/elapsed/running/enabled/pause reasons | Duration unset until configured, no per-entrant countdown, pauses during reading/menus and can be disabled |
| `events` | Append-only chronological event records | Monotonic event sequence, calendar phase and subject/reference info |
| `next_event_sequence` | Integer | Must be one greater than the last event sequence |

## Explicit non-decisions

- Household opening HM, refuge budget, loan principal, interest, due-day and exact shift duration are deliberately **not canonized**. Numeric values configured in automated QA are **test fixtures only**, not user approvals.
- Calendar records a day index and advances daily; exact month length, birthdays and developmental thresholds beyond starting age are not implemented here.
- The `approved=true` test-order record is a technical gate, **not** a simulated court, welfare institution or due-process system. Formal legal authority must be designed before narrative use.
- Godot UI, Mama/cub autonomous behavior, gate cases and refuge management are P3–P5, **not** implemented by this model.
- QA fixtures are anonymous, explicitly marked and absent from normal game initialization. No new named NPC was created.

## Save policy and testing

`SaveStore` validates a snapshot before saving, writes a temporary file, verifies its contents, backs up the prior valid file before replacement and refuses overwriting an already invalid save. Loading validates the full snapshot before replacing the active world. Restore/corruption/backups are covered by `test_p2.gd` **but those behavioral tests require a Godot runtime and have not been executed here**.

To run when Godot 4.7.2 is available:

```sh
godot --headless --path game --script res://tests/test_p1.gd
godot --headless --path game --script res://tests/test_p2.gd
python -m pytest -q tests/test_p1_static.py tests/test_p2_static.py
```

The Python tests are static source/fixture checks, not evidence that GDScript runs successfully.
