# P4 Gate Verification Matrix

| Area | Test or scenario | Failure to prevent |
|---|---|---|
| P1/P2/P3 regression | Foundation identity, legal status, finance, save/load and family autonomy suites still run | P4 changes breaking earlier modules |
| Gate initialization | Open one scheduled gate shift; block repeat starts | Duplicate case/visitor initialization |
| Anonymous QA subjects | Six unique `uc.qa.` IDs, no display names, five original characters unchanged | Unauthorized named NPCs or legacy ID collisions |
| Documents | Pass, identity, minor-care record and rulebook accessible | Automatic guesswork with no inspectable evidence |
| Questioning | Questions and calls return case-specific responses and are recorded | Hidden information not discoverable |
| Training rule audit | Correct and incorrect decisions are both recorded | Automatic perfect verdicts or silently overwritten mistakes |
| Investigation requirements | Registry/guardian check required for contested cases | Unjustified exception/guardian decision |
| Custody separation | Gate cannot change `guardian_links`, `temporary_care` or `refuge_placements` | The old follow-up guardian overwrite bug |
| Shift timer | Elapses only when active, pauses while reading, disable for unlimited shift | Per-entrant pressure or pause exploit |
| Shift completion | Six decisions or early close, skipped cases recorded | Silent false denials or infinite wage loops |
| Persistence | Save/load of full gate state, case records, decisions and event sequence | Detached case identities or lost legal outcomes |
| Tamper rejection | Modified fixture truth, decisions, audit, cursor, legal status and QA provenance rejected | Forged save state or cast |
| UI smoke | P3 home to P4 gate to P3 evening on same WorldState | Detached scenes or duplicate worlds |

**Validation levels:** Python `pytest` checks source fixtures and code contracts; Godot `test_p4.gd` tests actual behaviors; Godot `test_p4_ui.gd` instantiates actual UI. A Windows manual test is still separately required.
