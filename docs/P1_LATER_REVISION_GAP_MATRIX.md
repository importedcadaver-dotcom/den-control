# P1 — Later Godot Revision Recovery Gap Matrix

**Status:** The later post-v0.1 Godot source was **not located** among conversation attachments and the Library results available in this pass. The record of a redesign exists as a transcript, not a later source package. The original v0.1 archive was inspected directly and preserved unchanged in the downloadable P1 package.

| Later revision claim (transcript) | What the inspected v0.1 code actually shows | Recovery conclusion | Next engineering action |
|---|---|---|---|
| Free cottage-food exploit repaired | `world.gd`'s manual `care(..., "feed")` reduces a shared food-stock value; autonomous cottage eating uses a separate money charge. Costs are inconsistent by action path. | Claimed later fix not recovered | Rebuild food accounting against one consistent household inventory/ledger contract and test both manual and autonomous feeding. |
| Repeated wages on empty post-campaign days repaired | `next_day()` unconditionally adds `35` coins each day, with no 3-gate/3-refuge/1-off job eligibility. | Claimed later fix not in v0.1 | Pay only from completed/qualifying work records. Test rest days and repeated extra days. |
| Follow-up overwriting adopted guardians repaired | `follow_up("rescue", ...)` directly reassigns `animals.thimble.guardian`; adoption likewise assigns `guardian="player"`. These use one mutable field rather than lawful transition records. | Historical claim remains unverified | Separate legal custody, parent links, guardian grants, city entry and refuge placement. Require explicit transition authority and regression tests. |
| Malformed saves rejected | `restore()` validates many required fields but assumes exactly six cases and original seed IDs. It is incompatible with a new Unbearable Conditions roster. | Not reusable as the new save schema; claimed later strengthening unverified | Versioned new-world schema, strict validation before mutation, backup and migration policy. |
| Reorganized document comparison UI | v0.1 `main.gd` places multiple fixed controls across 1280×800; the later redesigned scene is not available. | Can only use transcript as an idea and screenshot as a comparison | Create a new task-focused inspection UI, with readable documents and contextual explanations. |
| Daily budget preview added | No consistent separate household/refuge budgets exist in v0.1. | Claimed later preview not recoverable as source | Build separate Honey Marks ledgers, then a budget preview based on actual transactions. |
| Counterfeit-permit case added | The six v0.1 cases do not include the later described counterfeit-permit scenario. | Later authored story not recovered | Use anonymous test fixtures; do not invent a new recurring named character. |
| Full UI and settings improvement | v0.1 offers basic controls and a sound toggle but no approved shift timer on/off setting. | Later UI remains unavailable | Build a separate Settings menu and verify timer pause semantics. |

**Important:** This comparison does **not** prove the later fixes never existed. It establishes that the original v0.1 source does not provide them in a form that satisfies the new project's approved requirements, and the supposedly patched source is missing.

The clean project **must not** import v0.1's unrelated cub `button` or adult `hazel`. The new family IDs are `uc.family.button` and `uc.family.hazel`, with separate relationship data.

**Recovery status:** old source available and preserved; later patched source unavailable; no compatibility requirement for obsolete v0.1 save files was approved. Do not design a migration that invents unapproved character identities.
