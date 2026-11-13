# P6 Windows QA — Manual Playtest and Issue Checklist

This checklist is **not** a claim that someone has visually playtested the build. It tells a Windows player how to test the existing portable QA runner and report reproducible defects.

## Setup

1. Download **UnbearableConditions-P6-QA-Windows** from the [P6 GitHub Actions run](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43361027996), under **Artifacts**, or use the conversation's verified ZIP download if present.
2. Extract **all** files to a normal folder. Leave game/, Godot_v4.7.2-stable_win64.exe, PLAY_P6_QA.bat and the license together.
3. Double-click **PLAY_P6_QA.bat**. If Windows security software warns about an unknown script or publisher, inspect the batch file and confirm the official Godot executable before choosing whether to run it. Never bypass a security warning blindly.
4. Expect a **960×540 first-pass QA interface**. This is not the finished visual style. Test at native display scale and, if possible, 125%/150% Windows scaling.

## Basic two-day QA route

- **Home / Day 1:** Confirm Mama and exactly two cubs, Button and Hazel, are visible as quadrupedal bears. Select each cub. Feed once (decreases finite demo pantry), play, cuddle, try a direction Hazel may refuse, and verify the displayed needs, memories and sibling relationship.
- **Gate / Day 1:** Choose **Go to gate**. Inspect passes and identity documents, verify records when needed, and ask about purpose. Reading documents should pause the shift timer. Try an authorized routine arrival, a held unresolved case, and an incorrect decision; the game should store the actual choice rather than silently correcting it. Finish or end early; return home.
- **Return home:** Check the family and its retained needs. The calendar should be **evening**, and the gate record should remain saved. The care-schedule readout should show Mama home, not a fabricated new caregiver.
- **Refuge / Day 2:** Choose **Next day**, then **Go to refuge**. Authorized entrants are eligible but do **not** automatically occupy a bed. Choose one, reserve the available bed, and confirm the resident appears. Seed **80 HM public QA funds** only if desired; buy food and feed the resident. Costs must affect only the public refuge account. No guest should acquire custody of Button/Hazel.
- **Finish refuge / Return home:** Complete the refuge shift, return home, and verify both cubs remain present. Try Save, change a cub's state, then Load and check the saved state returns.
- **Repeat gate day:** Advance to Day 3 after evening and verify a **new** gate shift can begin without deleting Day 1 cases. The full seven-day week remains out of scope.

## Visual and interaction checks

- [ ] No missing or overlapping controls at 960×540.
- [ ] Gate sidebar scrolls and essential decisions are discoverable.
- [ ] Pass, identity, evidence and rulebook text is legible.
- [ ] Adult + cub visitor appear as separate animals when relevant.
- [ ] Buttons and clickable cubs respond at normal Windows scaling.
- [ ] Cub tears/stress and injuries display in intended situations.
- [ ] Input, UI refresh and feedback remain responsive through both workdays.
- [ ] Save/load works in a **new app launch** (reload manually using Load).
- [ ] No imported legacy v0.1 characters or unauthorized recurring NPC names appear.

## Known and intentionally unimplemented

- Anonymous visitor data and provisional laws/prices are **QA fixtures**, not canonical Honeyhold content.
- The 10-minute simulated preschool→Grandma transition is a **QA clock abstraction**, not an approved school timetable; it does not generate teachers, lessons, or Grandma cruelty events.
- No full city exploration, real school scene, complete politics, normal wages/debt payments or 25+ day campaign.
- The bundle includes the official Godot runtime plus source, **not** a final game export.
- No human Windows visual test was performed by the assistant.

## Reporting issues

For any error, capture: **screen and action**, **day/phase**, **expected versus actual behavior**, **Windows scaling**, a **screenshot**, and whether it reproduces after restarting. Save an unmodified copy of any useful test save before sharing it; save files may contain in-game relationship or story state. Don't include personal information or system credentials.
