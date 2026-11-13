# P6 Visual Audit — Real Godot Screenshots, November 12, 2026

**Verified source/build:** [latest CI run 43362289966](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43362289966) on `main` at executable commit `07f0cd0c9d1a380e5fe982c60a1b4baa58495e4c`. Three **real Godot 4.7.2 rendered frames** (Home, Gate, Refuge) captured on a Linux virtual X display at 960×540. Images are the CI artifact `UnbearableConditions-P6-Visual-Screenshots`, artifact ID `14009160651`, on that run. Screenshots are an actual Godot renderer snapshot, **not AI mockups**, but are **not a human Windows gameplay/visual playtest**.

## Observations from inspected images

| View | Initial issue | Verified after repair | Still outstanding |
|---|---|---|---|
| **Home** | Work/Day navigation was buried below long cub-care controls; outdated P4 banner | All three work/navigation buttons are visible at top right, followed by cub selection and care controls; Mama and two quadrupedal cubs display in one style; P6 QA banner | Art is visibly simple pixel/block shapes, not polished; only one viewport captured; many buttons/metrics remain tightly packed, no direct school view |
| **Gate** | Paper text leaked beyond the paper frame; long inquiry reply clipped at sidebar edge; decision controls were below fold | Beige paper now contains bounded text; response is clipped and scrollable; AUTHORIZE/HOLD/DENY and reason selector are pinned in right-bottom panel and entirely in the 960×540 frame | Physical stamp manipulation not implemented; long document scroll/wheel, keyboard navigation, evidence comparison usability need human test; fixture-based case, not a deep authored story |
| **Refuge** | No confirmed clipping bug in initial capture, but essential controls scroll beneath tall content | First frame clearly shows admission, bed reservation, care, public supplies, work shift, and QA disclaimer; resident selection is visible | Uses anonymous QA IDs instead of character names; no hands-on review of full post-admission resident view; primitive placeholder art and small text |

## Verification performed

- [x] New `game/tests/test_p6_layout.gd` enforces viewport visibility of key Home/Gate controls, bounded paper/response widgets: **17/17 assertions**.
- [x] Final GitHub Actions workflow has **four passing jobs**: Linux Godot P1–P6 and layout (440 checks), Python (44 checks), Windows Godot engine tests/startup, and virtual-display screenshot capture.
- [x] Both updated artifacts (screenshots and Windows QA runner) produced from the latest green run. Windows ZIP verified intact locally and contains latest project, official Godot Windows executable, launch batch and license.
- [ ] Manual Windows mouse/keyboard interaction, UI scaling, screenshots across screen sizes, legibility, sound and extended play feel.
- [ ] Final visual/art style and authored character cases.

## Current download and instructions

Under the [successful workflow](https://github.com/importedcadaver-dotcom/den-control/actions/runs/43362289966), open **Artifacts** and download `UnbearableConditions-P6-QA-Windows`. Extract ZIP fully and double-click `PLAY_P6_QA.bat`. The included official Godot 4.7.2 Windows runtime runs the source project without needing editor installation; this is a developer QA package, not the final signed/exported game. Do not assume warnings from Windows Defender or other security tools are harmless. Inspect exact files/publisher if prompted.

The user can compare the results to `UnbearableConditions-P6-Visual-Screenshots` from the same run. Artifacts expire; source and tests remain under the GitHub repo.

## Release-readiness judgment

**P6 technical QA connected slice: verified. P6 authored, polished player release: not ready.** Next meaningful work is user Windows usability feedback, an individually approved recurring case, substantive school/Grandma interaction and consequences, plus a stable save/migration contract. No new named individuals or fictional legal/economic canon were added during visual QA.
