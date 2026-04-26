# Playwright fidelity tooling

Visual-fidelity tests for the `liqkit_ui` showcase. SSIM-compares
screenshots from the deployed showcase against reference images at
`packages/liqkit_ui_design_data/rendered/fidelity-snapshots/`.

## Status

Scaffolding only. Per-component fidelity specs land in the per-batch
component plans. The single `tests/sanity.spec.ts` here verifies the
showcase serves a page and signals `window.liqShowcaseReady`.

## Running locally

```bash
# 1. Build the showcase
cd ../../apps/showcase
flutter build web --wasm --release

# 2. Serve it (any static server that supports COOP/COEP headers
#    — without those Skwasm falls back to CanvasKit, which is fine
#    for the sanity test).
cd build/web
python3 -m http.server 4173

# 3. In another terminal, install deps + run tests
cd tooling/playwright
npm install
npm test
```

## Configuration

- `playwright.config.ts` — viewports (393x852@3 for iPhone, 1024x768@2
  for iPad/desktop), trace + screenshot on failure.
- `thresholds.json` — per-category SSIM and pixel-diff thresholds.
  Non-glass components default to 0.95 / 0.02; glass surfaces to 0.90 /
  0.03; foundation grids tuned individually.
- `ssim.ts` — wrapper around `ssim.js` + `pixelmatch`. Per-component
  specs call `compareSsim(actualPath, expectedPath, diffPath)`.

## What lands later

- One `tests/<category>.spec.ts` per liqkit category. Each loads
  `/#/<category>/<example>`, screenshots both viewports, runs SSIM
  against the matching baseline in
  `packages/liqkit_ui_design_data/rendered/fidelity-snapshots/`, and
  asserts SSIM ≥ `thresholds.json[<category>].ssimMin`.
- A `__diffs__/` directory (gitignored) holding pixelmatch diffs for
  any failed compare. CI uploads these as artifacts.
