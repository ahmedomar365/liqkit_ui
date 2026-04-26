# liqkit_ui_design_data

Frozen, read-only archive of the original `liqkit` iOS 26 design system.
Imported once at migration via `tooling/scripts/import_liqkit.sh`.
Provenance recorded in `PROVENANCE.md` (sha256 manifest of every file).

This package is **never published**. It is depended on as a
`dev_dependency` by:
- `packages/liqkit_ui` (for goldens and reference assets in tests)
- `apps/showcase` (for example fixtures)
- `tooling/playwright/` (for SSIM baselines)

It is **not** a runtime dependency of any published package.
