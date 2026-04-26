# ios-26

Canonical workspace for the iOS 26 web UI library in strict Figma mode.

Verification scope in this repository is strict and explicit:
- category-root coverage and canonical-child coverage are tracked separately
- nothing is labeled as category-root unless artifacts come from the category root node
- no assumed UI is allowed

## Core docs
- `COMPREHENSIVE_PLAN.md`: architecture and delivery strategy.
- `FIGMA_NODE_MANIFEST.md`: canonical Figma categories and node IDs.
- `ENGINEERING_GUARDRAILS.md`: strict no-assumption policy.

## Core state files
- `packages/components-html/src/catalog.json`: generated component catalog (1:1 with manifest).
- `figma-artifacts/verification.json`: verification status and artifact file pointers.
- `figma-artifacts/ARTIFACT_DIGESTS.json`: SHA-256 digest ledger for all verified artifact files.
- `figma-artifacts/canonical-nodes.json`: canonical child node chosen per category root.
- `figma-artifacts/full-coverage-workflow.json`: active category lock, completed categories, and strict sequencing.

## Commands
- `npm run sync:catalog`: regenerate strict catalog from manifest.
- `npm run sync:status`: regenerate `STRICT_STATUS.md` from verification + catalog.
- `npm run mode:full`: reset project into strict sequential verification mode (archives old verification state).
- `npm run record:artifact -- --categoryNode ...`: record artifacts and status updates without manual JSON edits.
  - to mark verified, require `--status verified --designContextPath ... --screenshotPath ... --variableDefsPath ... --fullCoverageConfirmed true`
  - only the active category in `figma-artifacts/full-coverage-workflow.json` can be marked verified
- `npm run artifacts:extract`: persist any in-session Figma screenshot payloads into local `.png` files.
- `npm run artifacts:extract:text`: persist in-session Figma text payloads (metadata/design-context/variables) into `figma-artifacts/raw/`.
- `npm run artifacts:hydrate:unverified`: hydrate unverified categories from already-saved raw MCP outputs into stable artifact files (no verification state promotion).
- `npm run artifacts:assemble:colors`: assemble full-coverage Colors category artifacts from persisted raw MCP outputs into stable category files.
- `npm run artifacts:finalize:ready-chain`: verify contiguous ready categories in strict sequence (requires active category to have 3/3 artifacts first).
  - use `node scripts/finalize-ready-chain.mjs --dryRun true` to preview what would be verified.
- `npm run assets:sync -- --nodeId <id> --assetsId <slug>`: download all `const img...` MCP asset URLs from latest saved design-context for a node into `figma-artifacts/assets/<slug>/` and write `asset-map.json`.
- `npm run native:scaffold`: generate missing native HTML/CSS category source files from persisted Figma evidence without overwriting handcrafted native files.
- `npm run artifacts:persist`: snapshot Figma artifacts plus generated project outputs/source into `figma-artifacts/snapshots/<timestamp>/`.
  - snapshot manifest now tags each file with `sourceType`: `figma`, `generated`, or `project`.
- `npm run artifacts:digests:update`: refresh artifact hash ledger from current verified artifacts.
- `npm run release:inventory`: generate release-ready inventory files with all categories, URLs, status, artifacts, and render paths.
  - inventory reports both category-root and canonical-child coverage explicitly
- `npm run release:native`: bundle native component sources and shared primitives into `release/native/` for distribution.
- `npm run check:release:native`: validate `release/native` integrity (manifest/component consistency, no preview/evidence links, bundled-asset coverage).
- `npm run release:verify`: run `release:native` then `check:release:native`.
- `npm run check:native`: enforce that every catalog category has a native HTML/CSS pair and no orphan native files.
- `npm run check:native:purity`: enforce native HTML/CSS purity (no remote URLs, no CSS `url(...)`, strict symbol/runtime invariants, and strict exception policy).
  - strict default: `figma-artifacts/native/STRICT_EXCEPTIONS.json` must be empty
  - emergency override: `IOS26_ALLOW_ASSET_BACKED_EXCEPTIONS=1 npm run check:native:purity`
- `npm run check:artifacts:digests`: enforce verified-artifact hash stability against `figma-artifacts/ARTIFACT_DIGESTS.json`.
- `npm run check:evidence:persistence`: enforce source-to-preview mirror integrity for verified Figma artifacts and rendered snapshot completeness.
- `npm run snapshots:rendered`: capture/refresh `preview/rendered/snapshots/*.png` for all categories and write manifest/report files.
- `npm run snapshots:fidelity`: capture component-only fidelity snapshots from `rendered/*.html?view=fidelity` into `preview/rendered/fidelity-snapshots/*.png`.
- `npm run report:fidelity`: compute SSIM-based visual-fidelity report from rendered snapshots vs persisted Figma screenshots.
- `npm run check`: strict checks + compile.
- `npm run preview:build`: run extraction + build evidence preview + build native HTML/CSS render preview + release inventory + final snapshot.
- `npm run preview:build:strict`: run `preview:build`, capture rendered snapshots, then enforce digest stability and persistence integrity checks.
- `npm run preview:serve`: serve preview on port `4173`.

## Preview outputs
- Evidence index: `preview/index.html`
- Rendered HTML index: `preview/rendered/index.html`
- Rendered snapshots report: `preview/rendered/snapshots/SNAPSHOT_REPORT.md`
- Rendered snapshots manifest: `preview/rendered/snapshots/index.json`
- Mirrored docs for browser navigation:
  - `preview/docs/STRICT_STATUS.md`
  - `preview/docs/RELEASE_INVENTORY.md`
  - `preview/docs/RESUME_QUEUE.md`
- Native source fragments: `preview/rendered/source/*.native.html` and `preview/rendered/source/*.native.css`
- Release inventory (markdown): `RELEASE_INVENTORY.md`
- Release inventory (json): `release/inventory.json`

## License
MIT (`LICENSE`)
