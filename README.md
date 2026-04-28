# liqkit_ui

iOS 26 Liquid Glass design system for Flutter.

This repository is a Dart pub workspace containing the published
component library, design tokens, asset bundle, the showcase Flutter Web
app, the docs site under `apps/docs/`, the docs snippets app under
`apps/docs_snippets/`, and the design-data archive ported from `liqkit`.

See `docs/superpowers/specs/2026-04-26-liqkit_ui-design.md` for the full
design and `docs/superpowers/plans/` for implementation plans.

## Documentation

Once deployed, the live docs site lives at
**<https://liqkit-docs-prod.workers.dev>** (Cloudflare Workers) and
the iframed component previews at
**<https://liqkit-snippets-prod.pages.dev>** (Cloudflare Pages).

Deploy is wired in `.github/workflows/docs_deploy.yaml`. To activate,
add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` to the repo's
GitHub Actions secrets and push to `main`.

The custom domain (`liqkit.dev` → docs, `snippets.liqkit.dev` → iframe
origin) is wired in the plan but deferred until the domain is
registered.

## Status

Pre-1.0 — bootstrap in progress.

## License

MIT (see `LICENSE`).
