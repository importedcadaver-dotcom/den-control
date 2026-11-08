# Recovered source package — manifest and handling rules

This document records the exact source material recovered for Unbearable Conditions production preparation.

## Files and checksums

| Artifact | Size | SHA-256 | Handling |
|---|---:|---|---|
| Original BriarwoodRefuge_v0.1_Windows_and_Source.zip | 39,945,783 bytes | fd519df3f8e93d29c9b33c71029ae214d9204f946e71374fa3d8f72efa548eb8 | Preserve original; contains Windows executable, source, QA and screenshots |
| Prepared BriarwoodRefuge_v0.1_source_only.zip | 65 KB | 31a765af2842073122be197bd7243ade0a164ee5f7f4a181ab0ba57f7e1ec42d | Source-only copy; excludes executable and screenshots |
| Extracted Honey, Please Layer 1 v3 HTML | 22,347 bytes | e6e3dd6a78b5559c81cb58f2d0176b8090f9cbc989ee1dd79a1d97000d141bb | Reference only; JavaScript syntax checked, not browser-playtested |

## Provenance

- Godot source came from the current conversation attachment BriarwoodRefuge_v0.1_Windows_and_Source.zip.
- Honey, Please source came from the full HTML attachment Pasted text(20261107-050627).txt, which contains the Layer 1 v3 document. The transcript also refers to the artifact as honey-please-2.html.
- Pasted text(20261107-044120).txt records the original Den Control development and later UI/economy/guardianship redesign claims. It is a transcript, not the later Godot source archive.

## Handling rules

- The old Godot source is an immutable legacy reference until a new clean project is established.
- Do not copy the old seed cast into new game data. The v0.1 Button cub and adult Hazel are explicitly **OLD / BAD / DO NOT USE**.
- Do not import Honey, Please's Hibernia setting, Supervisor Honeywell, generated names, random families or 120-second shift timer.
- Do not claim later Godot fixes are present in v0.1.
- Do not report the stored test results as newly rerun.
- The active den-control GitHub repository remains documentation-only until source files are deliberately imported. These recovered archives are currently attached to the conversation and available for production work; they have not yet been committed into the repository.

## Verification

- Original ZIP integrity check: passed.
- Godot source: statically inspected; no Godot runtime was available in this Linux environment, so GDScript tests and the Windows executable were not rerun.
- Honey, Please JavaScript: passed Node syntax check; no browser playtest was completed.