# Figma Extraction Worklist (Strict Mode)

No-assumption policy: a component is only `verified` after Figma artifacts are saved.

## Artifact requirements per verified component
1. `get_design_context` output saved under `figma-artifacts/<id>/design-context.txt`
2. `get_screenshot` evidence captured for the same node
3. `get_variable_defs` output (if variables exist)

## Current MCP behavior
- Category root nodes often fail for design context/variables.
- Concrete child symbol nodes work.
- Use `get_metadata` on category node, then select canonical symbol nodes for extraction.

## Verification update rules
- Keep status `unverified` until artifacts are complete.
- Set status `verified` only when artifacts are present and mapped in `figma-artifacts/verification.json`.

## Execution order
1. Foundations: Colors, Materials, Text styles, System (verified)
2. Core controls: Buttons, Text fields, Toggles, Segmented controls, Sliders, Steppers
3. Feedback + overlays + navigation
4. Extended surfaces

## Verified in strict mode (2026-02-17)
- Buttons (`507:24673`) canonical child `40:58690`
- Colors (`0:1746`) canonical child `0:4207`
- Materials (`215:105157`) canonical child `510:79110`
- Text styles (`0:2194`) canonical child `0:3040`
- System (`507:24688`) canonical child `106:60032`
- Text fields (`553:22762`) canonical child `5433:15646`
- Toggles (`507:24690`) canonical child `27:68905`
