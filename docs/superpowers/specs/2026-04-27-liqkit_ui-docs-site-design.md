# liqkit_ui docs site — design

**Date:** 2026-04-27
**Status:** approved (pending user review of this written spec)
**Goal:** Ship a forui.dev-equivalent documentation site for `liqkit_ui`
that hosts a sidebar of all 37 components, each with a live Preview and
a Dart Code tab.

This document is the canonical design. The implementation plan derived
from it lives at `docs/superpowers/plans/`.

---

## 1. Background

`liqkit_ui` is a 37-component Flutter library. Today, the only browsable
artifact is `apps/showcase/`, a hash-routed Flutter Web app whose pages
are *catalog* views (e.g. `#/buttons/catalog` shows ~60 button cells).
The showcase serves Playwright fidelity testing well, but is not a
documentation site for users.

The forui.dev site (Flutter, Fumadocs, Cloudflare) is the chosen
template. A direct audit of `forus-labs/forui@main` confirmed:

- Docs is a sibling app inside the same monorepo (`/docs/`) plus a
  separate small Flutter app for snippet iframes (`/docs_snippets/`).
- Stack: Next.js 16 (App Router) + React 19 + Fumadocs 16 + Tailwind 4
  + pnpm 10 + Node 24.
- Each MDX `<Widget name='button' variant='primary'/>` renders an
  iframe pointing at a separate Flutter Web build deployed to its own
  Cloudflare Pages project.
- Code snippets are JSON files emitted by a Dart `analyzer`-based tool
  reading `// {@highlight}` markers in `lib/examples/` source files.
- Deploy: Cloudflare Workers (docs) + Cloudflare Pages (snippets) via
  `@opennextjs/cloudflare`. No Vercel.
- Search: Fumadocs built-in (Orama). No Algolia.
- Sidebar: filesystem + per-folder `meta.json`.
- Latest-only docs, no version selector.

We adopt this pattern with deliberate variations called out below.

## 2. Constraints

- **Pure-Dart steady-state rule** in `CLAUDE.md` is updated, not
  abandoned. The rule continues to govern the token pipeline,
  components, showcase, demo, and playground. Node + pnpm is
  explicitly allowed *only* under `apps/docs/` (carve-out option A
  from the brainstorm).
- The existing `apps/showcase/` is **not** the iframe target. Showcase
  routes are catalog pages and stay that way for Playwright fidelity
  testing. Iframe targets are single-variant routes in a new
  `apps/docs_snippets/` app.
- The existing `.github/workflows/ci.yml` (Dart-only) is untouched.
  Docs CI lives in a new file.
- `docs/` directory is currently empty — the spec / plan tree is
  established by this commit.

## 3. Repo layout (after this spec ships)

```
liqkit_ui/
  apps/
    demo/                   (existing)
    playground/             (existing)
    showcase/               (existing — Playwright source-of-truth, untouched)
    docs/                   (NEW — Next.js + Fumadocs)
    docs_snippets/          (NEW — Flutter Web app, single-variant routes)
  packages/                 (existing — untouched)
  tooling/
    gen/
      gen_snippet_routes.dart      (NEW — single manifest → Flutter routes + MDX URL constants)
      snippet_generator/main.dart  (NEW — Dart analyzer → MDX-consumable JSON)
  docs/superpowers/specs/   (this file lives here)
  .github/workflows/
    ci.yml                  (existing — untouched)
    docs_deploy.yaml        (NEW)
  .nvmrc                    (NEW — pinning Node 24)
  pnpm-workspace.yaml       (NEW — only lists apps/docs)
```

## 4. Architecture

### 4.1 Two-app split

`apps/docs/` (Next.js) and `apps/docs_snippets/` (Flutter Web) are
deployed as **two separate Cloudflare projects** with two separate
hostnames. The docs site iframes the snippets site via an env-injected
base URL. This keeps:

- Flutter build artifacts entirely out of the Next bundle.
- Node tooling entirely out of `apps/docs_snippets/` (it's a normal
  Flutter app under the existing pub workspace).
- Independent caching and deploy lifecycles for the two surfaces.

### 4.2 Single-manifest route generation

forui maintains 260+ `auto_route` entries by hand in
`docs_snippets/lib/main.dart`. We avoid that drift class.

`tooling/gen/snippet_manifest.json` (committed) lists every
(component, variant, path, dartFile) tuple. A Dart generator emits:

- `apps/docs_snippets/lib/src/routes.g.dart` — the Flutter route table.
- `apps/docs/lib/snippet-routes.ts` — the MDX-side typed lookup of
  variant → URL path. MDX components consume this so a typo in a
  variant name fails the docs build.

### 4.3 Iframe contract

URL shape: `${SNIPPETS_URL}/${component}/${variant}?theme=light|dark`.

Examples:

- `/button/regular`
- `/button/glass`
- `/sheet/inspector-stacked`
- `/face-id/scanning`

Inside the snippets app, on each frame's first layout the Flutter app
posts `{ type: 'liq.height', px: <height> }` via
`window.parent.postMessage`. The Next-side wrapper installs a
`MessageEvent` listener filtered by `event.origin === SNIPPETS_URL`
and updates the iframe `height` attribute. This avoids forui's
hard-coded-height pitfall.

Theme is passed by query param (not postMessage) so the snippets app
can apply it during the very first frame and avoid a flash of
light theme.

### 4.4 Snippet code blocks

Source of truth is the actual Dart file used by the iframe variant
(e.g. `apps/docs_snippets/lib/snippets/button/regular.dart`).
`tooling/gen/snippet_generator/main.dart` parses each file with
`package:analyzer`, captures lines between `// {@highlight}` and
`// {@endhighlight}` markers, and emits one JSON file per variant
under `apps/docs/snippets/<component>/<variant>.json`. The JSON
contains: source string, language ("dart"), highlight ranges,
file path. MDX imports the JSON and passes it to a `<CodeSnippet>`
client component that runs Shiki at build time.

The `apps/docs/snippets/` directory is gitignored. CI runs the
generator before `pnpm build`. Local devs run the generator via the
top-level `melos run docs:snippets` command (added by this spec).

## 5. Components

| Unit | Responsibility | Depends on | How to verify |
|------|----------------|------------|---------------|
| `apps/docs_snippets/` | Flutter Web app, one route per variant. Reads `routes.g.dart`. Posts `liq.height` on layout. Reads `?theme=` and applies it to `LiqApp`. | `package:liqkit_ui` | `flutter build web` succeeds; visiting `/button/regular?theme=dark` renders the variant; `flutter test` covers the postMessage hook. |
| `apps/docs/` | Next.js + Fumadocs site, MDX content, search, navigation, deploy. | `apps/docs_snippets/` (URL only, runtime) | `pnpm build` succeeds; visiting `/docs/inputs/buttons` renders prose + iframe + code tab. |
| `tooling/gen/gen_snippet_routes.dart` | One manifest in, both route tables out. Pure function, no IO outside its declared inputs/outputs. | `tooling/gen/snippet_manifest.json` | Dart unit test pinned to a small fixture manifest. |
| `tooling/gen/snippet_generator/main.dart` | Parses Dart files, emits JSON for MDX. Honors `{@highlight}` markers. | `package:analyzer` | Dart unit test that parses a fixture file with markers and asserts output JSON. |
| `apps/docs/components/liq-preview.tsx` | Client component. Renders the iframe with theme query param + ResizeObserver-via-postMessage height sync. | `next-themes`, `apps/docs/lib/snippet-routes.ts` | React Testing Library — given a known component+variant, the rendered iframe `src` matches the manifest. |
| `apps/docs/components/code-snippet.tsx` | Renders generator JSON via Shiki at build time. Tabs across multiple snippets when applicable. | Shiki | Snapshot test. |

## 6. Content scope (v1)

**Pages shipped at v1:**

- 4 guide pages: Overview, Installation, Theming, Migrating from
  liqkit (the original CSS-based liqkit, distinct from
  `liqkit_ui_design_data`).
- 37 component pages, one per category in
  `packages/liqkit_ui/lib/src/components/`.

**Sidebar taxonomy** (`apps/docs/content/docs/meta.json` + per-folder):

```
Getting Started
  Overview
  Installation
  Theming
  Migrating from liqkit

Foundation
  Colors · Text Styles · Materials

Inputs
  Buttons · Toggles · Sliders · Steppers · Segmented Controls
  Page Controls · Color Pickers · Pickers · Text Fields

Containers
  Sheets · Alerts · Action Sheets · Notifications
  Popovers · Menu · Context Menu · Empty States

Navigation
  Top Bars · Toolbars · Sidebars · Lists · Popup Buttons

Status
  Status Bars · Progress + Spinners · Activity Views · Face ID

Decoration
  App Icons · Bezels · Keyboards · Widgets · Windows
  System · Examples · Kit Helpers
```

**Explicit non-goals at v1** (deferred to a later spec):

- No dartdoc-driven API reference.
- No tutorial / cookbook content.
- No per-version docs (latest only).
- No i18n.
- No OpenGraph card generator beyond the framework default.
- No live code editing (only iframe + static snippet).

## 7. Deploy

- **Docs site (`apps/docs/`):** deployed to Cloudflare Workers via
  `@opennextjs/cloudflare`. Worker name `liqkit-docs-prod`. Custom
  domain target: `liqkit.dev` (placeholder; if the domain isn't
  registered when the plan executes, deploy stays on the
  `*.workers.dev` default and the custom domain step is deferred).
- **Snippets app (`apps/docs_snippets/`):** deployed to Cloudflare
  Pages, project `liqkit-snippets-prod`. Custom domain target:
  `snippets.liqkit.dev`.
- Iframe origin: `apps/docs/` reads `NEXT_PUBLIC_SNIPPETS_URL` at
  build time. CI injects it. A `next.config.mjs` build-time check
  fails the docs build if the env var is missing or doesn't match
  `https://...`.
- Both projects deploy from the same commit on every push to `main`,
  ensuring the iframe contract stays consistent.

## 8. CI

`.github/workflows/docs_deploy.yaml` (NEW):

```
on:
  push:
    branches: [main]
    tags: ['liqkit_ui-v*']
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - checkout
      - setup-flutter (stable channel)
      - setup-node (.nvmrc → 24)
      - setup-pnpm (10)
      - run snippet route generator (Dart)
      - run snippet code generator (Dart)
      - flutter build web (apps/docs_snippets)
      - wrangler pages deploy (snippets)
      - cd apps/docs && pnpm install --frozen-lockfile
      - pnpm build (with NEXT_PUBLIC_SNIPPETS_URL injected)
      - wrangler deploy (docs Worker)
```

The existing Dart-only `ci.yml` is unchanged.

## 9. Tech pins

- Node 24 (`.nvmrc`)
- pnpm 10 (`packageManager` in `apps/docs/package.json`)
- Next.js 16 (App Router)
- React 19
- Fumadocs UI / MDX / Core 16.x
- Tailwind 4 + `@tailwindcss/postcss`
- TypeScript 5.9
- `@opennextjs/cloudflare` 1.x
- Shiki 4 for code highlighting
- Orama 3.x for built-in search
- Flutter (stable channel; whatever ships in the snippets app's
  `pubspec.yaml`)

These are forui's exact pins. We will track Renovate/Dependabot
later — out of scope for v1.

## 10. Versioning, search, telemetry

- **Versioning:** latest only. Documented decision; revisit at v1.0.
- **Search:** Fumadocs built-in (Orama). Configured in
  `apps/docs/app/api/search/route.ts`.
- **Telemetry / analytics:** none at v1. (Not even Cloudflare Web
  Analytics; reconsider once we have measurable traffic.)

## 11. Error handling

- Snippet manifest entries that don't resolve to a Dart file fail the
  generator with a non-zero exit and a precise file:line error.
- MDX pages that import a snippet path not in the manifest fail the
  Next build at type-check time (the lookup table is typed).
- Snippets app routes that aren't in the manifest fail the Flutter
  build via the generator's `routes.g.dart` output.
- Iframe height messages from the wrong origin are dropped silently.
- The docs build refuses to proceed without a valid
  `NEXT_PUBLIC_SNIPPETS_URL`.

## 12. Testing

- Dart: unit test for `gen_snippet_routes.dart` (small fixture
  manifest in/out) and for `snippet_generator/main.dart` (fixture
  Dart file with `{@highlight}` markers). These plug into the
  existing `melos run test`.
- Flutter: widget test for the snippets app's postMessage hook —
  pump a test root, assert the height message is posted exactly once
  per layout pass.
- React: component test for `liq-preview.tsx` asserting the iframe
  `src` and the height handler. Run via Vitest, configured in
  `apps/docs/`.
- E2E: a single Playwright spec in `apps/docs/tests/` that loads
  three representative MDX pages and asserts the iframe iframes
  successfully and the code tab renders. Reuses the existing
  `tooling/playwright/` config in spirit but lives under
  `apps/docs/` to keep concerns separate.

## 13. Migration / rollout

- Phase 1 (this spec → next plan): scaffolding, two empty apps, CI
  green. Ship one component page (Buttons) end-to-end as a
  reference. Approve.
- Phase 2: the other 36 component pages + 4 guide pages. Bulk work,
  parallelizable per page.
- Phase 3: domain + DNS, replace `*.workers.dev` URLs with
  `liqkit.dev` and `snippets.liqkit.dev`.
- Pub.dev publishing (existing pending Task #15) and the docs site
  deploy are independent — either can ship first.

## 14. Open / explicit-defer list

- Domain registration. If `liqkit.dev` isn't registered at deploy
  time, ship on the Cloudflare defaults; cut over later. **Decision
  recorded; no further brainstorming needed.**
- Per-version docs. Deferred to post-1.0. **Decision recorded.**
- API reference (dartdoc). Deferred to a later spec. **Decision
  recorded.**

## 15. CLAUDE.md change

Replace the current "Don'ts" entry…

> The whole steady-state toolchain is pure Dart — Node is no longer
> used at any point.

…with:

> The steady-state Dart toolchain is pure Dart — Node is not used
> for token generation, components, the showcase, the demo, the
> playground, or any of the existing CI under `ci.yml`. Node, pnpm,
> and Next.js are used exclusively under `apps/docs/`. The
> snippets app at `apps/docs_snippets/` is a normal Flutter Web app
> in the pub workspace and follows the Dart-only rules.

This change is part of the Phase 1 implementation.
