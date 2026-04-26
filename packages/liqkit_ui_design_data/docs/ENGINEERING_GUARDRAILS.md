# Engineering Guardrails (Strict Figma Mode)

## 1) Single Source of Truth
- Figma manifest: `FIGMA_NODE_MANIFEST.md`
- Generated strict catalog: `packages/components-html/src/catalog.json`
- Verification state + artifact pointers: `figma-artifacts/verification.json`

## 2) No-Assumption Rule
- Unverified components must not ship assumed HTML/CSS behavior.
- A component can only be marked `verified` after artifact capture from Figma:
  - design context
  - screenshot
  - variable definitions (if relevant)
- If artifacts are missing, status must stay `unverified`.

## 3) Compile and Consistency Gates
- `npm run sync:catalog` must run before checks/build.
- `npm run check:contracts` enforces 1:1 parity with manifest rows.
- Duplicate ids/node ids are blocked.
- `verified` entries without artifact files are blocked.

## 4) Strict Delivery Contract
- Preview page is a verification matrix first.
- Visual UI output in the library is allowed only for `verified` components.
- Any speculative implementation belongs in archive/prototype, not in strict surface.
