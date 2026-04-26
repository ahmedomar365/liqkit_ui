# iOS 26 Web UI Library (Shadcn-Style) - Comprehensive Plan

## 1) Objective
Build a reusable, versioned iOS 26 web UI library with HTML/CSS-first components and optional framework adapters later.

Target outcome: each Figma component family becomes a production-ready web component with:
- token-driven styling
- clear variant/state API
- accessibility behavior
- tests and docs

## 2) Source of Truth
- Figma file key: `zaxcqZr1Vg7oSf38Vrhulx`
- Canonical node catalog: `FIGMA_NODE_MANIFEST.md`
- Do not run discovery-style MCP crawling; use known node IDs directly.

## 3) Low-Call MCP Strategy (Quota Safe)
Use MCP only for work that is actively being implemented in the current sprint.

Per component family, default call budget:
1. `get_design_context` on the family node (required)
2. `get_screenshot` on the same node (required)
3. `get_variable_defs` only if token mapping is unclear (optional)

Rules:
- No repeated calls for the same node unless Figma changed.
- Save extracted measurements/tokens in local docs once.
- Start with foundations (colors/materials/text styles), then components.

## 4) Product Shape (Future-Proof)
Monorepo structure:
- `packages/tokens`
- `packages/primitives`
- `packages/components-html`
- `packages/components-react` (phase 2)
- `packages/icons`
- `apps/docs`
- `apps/playground`

Non-negotiable rule: tokens are the single source of truth.

## 5) Component Contract
Each component ships with:
- semantic HTML structure
- class naming (`ios26-*`)
- data attribute API (`data-variant`, `data-size`, `data-state`)
- keyboard and ARIA support
- visual and interaction tests

Example variant API (button):
- `data-variant="solid|tinted|ghost|destructive"`
- `data-size="sm|md|lg"`
- `data-shape="rounded|pill|square"`

## 6) Token Strategy
Token layers:
1. Foundation: raw color, type, spacing, radius, blur, shadow, motion
2. Semantic: `--ui-bg-surface`, `--ui-fg-primary`, `--ui-border-subtle`
3. Component: `--button-bg`, `--button-radius`, `--textfield-ring-color`

Implementation detail:
- CSS custom properties in `@layer tokens`
- no hardcoded component colors unless explicitly justified

## 7) Build Sequence
Phase A: Foundations
- Colors
- Materials/elevation/blur
- Text styles
- System primitives

Phase B: Core controls
- Buttons
- Text fields
- Toggles
- Segmented controls
- Sliders
- Steppers

Phase C: Feedback + lists
- Alerts
- Progress indicators
- Lists
- Notifications
- Empty states

Phase D: Overlays + navigation
- Action sheets
- Activity views
- Popovers
- Menus/context menus
- Top bars/toolbars/status bars/page controls

Phase E: Extended surfaces
- Sidebars
- Pickers/color pickers
- Keyboards
- App icons/widgets/windows

## 8) Quality Gates
Definition of done for each component:
1. Visual match against Figma screenshot
2. Full state coverage (default/hover/active/focus/disabled/selected/loading when relevant)
3. Keyboard and screen reader behavior
4. Mobile and desktop behavior
5. Docs with anatomy, variants, and accessibility notes
6. Unit + visual regression tests passing

## 9) Versioning and Governance
- SemVer across all packages
- changelog with migration notes
- token alias policy for backwards compatibility
- deprecation period: at least one minor release

## 10) Immediate Execution Plan
1. Freeze and use `FIGMA_NODE_MANIFEST.md` as the extraction queue.
2. Extract foundations first (colors, materials, text styles, system).
3. Implement `Button` as the golden reference component.
4. Lock conventions from Button (naming, token usage, docs format, test shape).
5. Scale family-by-family with the same template.
