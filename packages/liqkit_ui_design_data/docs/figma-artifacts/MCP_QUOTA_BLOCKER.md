# Figma MCP Quota Blocker

- Date: 2026-02-18
- Scope: strict extraction for iOS 26 web kit
- Current blocker: Figma MCP call limit reached while completing active category Sliders (`507:24685`, canonical `5661:43611`)

## Verified progress at block
- Verified categories: 27/37
- Active category: 507:24685 (Sliders)

## Current pending state
- Sliders (`507:24685`) has:
  - design-context: ready (`5661:43611`)
  - variable-defs: ready (`5661:43611`)
  - screenshot: missing (`get_screenshot` still quota blocked)
- Steppers (`507:24687`) canonical candidate already staged:
  - `507:24687` -> `5661:43368` (design-context ready, vars ready, screenshot missing)
- Additional canonical candidates staged from saved raw design-context:
  - `507:24689` -> `5661:41970` (Top bars)
  - `507:25993` -> `5735:66270` (Toolbars)
  - `507:26511` -> `775:13152` (Widgets)
  - `5413:10149` -> `5589:4058` (Windows)
- Text fields and Toggles remain fully ready in cache but sequence-blocked:
  - `553:22762` -> `5433:15646` (design, vars, screenshot ready)
  - `507:24690` -> `27:68905` (design, vars, screenshot ready)
  - status label: `ready_to_verify (blocked by active)`

## Next required MCP calls after reset
1. `get_screenshot` for `5661:43611`.
2. Finalize `507:24685` from `5661:43611`.

## Notes
- Sidebars was completed and verified from real MCP artifacts:
  - `507:26013` -> `5726:29555`.
- Native HTML/CSS currently implemented in:
  - `figma-artifacts/native/buttons.html`
  - `figma-artifacts/native/buttons.css`
  - `figma-artifacts/native/segmented-controls.html`
  - `figma-artifacts/native/segmented-controls.css`
  - `figma-artifacts/native/sheets.html`
  - `figma-artifacts/native/sheets.css`
  - `figma-artifacts/native/sidebars.html`
  - `figma-artifacts/native/sidebars.css`
  - `figma-artifacts/native/sliders.html`
  - `figma-artifacts/native/sliders.css`
  - `figma-artifacts/native/steppers.html`
  - `figma-artifacts/native/steppers.css`
  - `figma-artifacts/native/text-fields.html`
  - `figma-artifacts/native/text-fields.css`
  - `figma-artifacts/native/toggles.html`
  - `figma-artifacts/native/toggles.css`
  - `figma-artifacts/native/top-bars.html`
  - `figma-artifacts/native/top-bars.css`
  - `figma-artifacts/native/toolbars.html`
  - `figma-artifacts/native/toolbars.css`
  - `figma-artifacts/native/widgets.html`
  - `figma-artifacts/native/widgets.css`
  - `figma-artifacts/native/windows.html`
  - `figma-artifacts/native/windows.css`
  - `figma-artifacts/native/status-bars.html`
  - `figma-artifacts/native/status-bars.css`
  - `figma-artifacts/native/kit-helpers.html`
  - `figma-artifacts/native/kit-helpers.css`
- Persisted local asset packs:
  - `figma-artifacts/assets/sidebars/*`
  - `figma-artifacts/assets/sliders/*`
  - `figma-artifacts/assets/steppers/*`
  - `figma-artifacts/assets/top-bars/*`
  - `figma-artifacts/assets/toolbars/*`
  - `figma-artifacts/assets/widgets/*`
  - `figma-artifacts/assets/windows/*`
- Reusable local asset sync utility added:
  - `scripts/sync-assets-from-design-context.mjs`
  - `npm run assets:sync -- --nodeId <id> --assetsId <slug>`
- Unverified hydration utility added (from saved raw MCP outputs):
  - `scripts/hydrate-unverified-from-raw.mjs`
  - `npm run artifacts:hydrate:unverified`
- Strict chain finalization utility added:
  - `scripts/finalize-ready-chain.mjs`
  - `npm run artifacts:finalize:ready-chain`
  - dry-run: `node scripts/finalize-ready-chain.mjs --dryRun true`
- Native baseline scaffold utility added:
  - `scripts/scaffold-native-from-artifacts.mjs`
  - `npm run native:scaffold`
  - `npm run check:native`
- Rendered pages now persist screenshot-block diagnostics when image is missing:
  - `Open screenshot status note` link in `preview/rendered/*.html`
- Sliders in-progress evidence persisted:
  - `figma-artifacts/sliders/5661-43611.design-context.txt`
  - `figma-artifacts/sliders/5661-43611.variable-defs.json`
  - `figma-artifacts/sliders/5661-43611.screenshot.blocked.txt`
- Steppers in-progress evidence persisted:
  - `figma-artifacts/steppers/5661-43368.design-context.txt`
  - `figma-artifacts/steppers/5661-43368.variable-defs.json`
  - `figma-artifacts/steppers/5661-43368.screenshot.pending.txt`
- Snapshot retention was reduced (kept latest snapshots) to resolve disk-full (`ENOSPC`) during persistence.
- Latest context snapshot path is recorded in `figma-artifacts/LATEST_SNAPSHOT`.
