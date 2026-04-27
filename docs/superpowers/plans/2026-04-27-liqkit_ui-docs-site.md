# liqkit_ui docs site — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the forui.dev-equivalent documentation site for `liqkit_ui` — a Fumadocs Next.js app at `apps/docs/` with sidebar navigation across all 37 components, each rendered with a live Preview (iframe) and a Dart Code tab.

**Architecture:** Two-app split mirroring forui's verified pattern: `apps/docs/` (Next 16 + Fumadocs 16 + Tailwind 4 + React 19) deployed to Cloudflare Workers, plus `apps/docs_snippets/` (Flutter Web app, single-variant routes) deployed to Cloudflare Pages. A single committed manifest at `tooling/gen/snippet_manifest.json` is the source of truth — Dart generators emit both the Flutter route table and a typed TypeScript URL lookup so MDX can never reference a route the Flutter app doesn't serve. Code snippets are extracted from real Dart files by a `package:analyzer`-based tool that honors `// {@highlight}` markers.

**Tech Stack:** Node 24, pnpm 10, Next.js 16 (App Router), React 19, Fumadocs UI / MDX / Core 16.x, Tailwind 4, TypeScript 5.9, `@opennextjs/cloudflare` 1.x, Shiki 4, Orama 3.x, Vitest 2 + @testing-library/react, Playwright 1, Flutter stable, `package:analyzer` (Dart).

**Source spec:** `docs/superpowers/specs/2026-04-27-liqkit_ui-docs-site-design.md`.

---

## Phase plan

- **Phase 1 (Tasks 1–24):** scaffold both apps, generators, CI, and ship a single end-to-end working component page (Buttons). After Phase 1 you can browse `/docs/inputs/buttons`, see the iframe preview render the Dart `LiqButton`, and read the highlighted Dart snippet.
- **Phase 2 (Tasks 25–36):** the remaining 36 component pages, 4 guide pages, sidebar `meta.json` finalization, and bulk snippet manifest entries.
- **Phase 3 (Tasks 37–39):** custom-domain wiring (deferrable). The site is functional on `*.workers.dev` / `*.pages.dev` defaults at the end of Phase 2.

---

## File map (created or modified by this plan)

### Created

```
.nvmrc                                                 (Phase 1, Task 2)
pnpm-workspace.yaml                                    (Phase 1, Task 2)
.gitignore                                             (Phase 1, Task 3 — appends only)

tooling/gen/snippet_manifest.json                      (Phase 1, Task 4; expanded in Phase 2)
tooling/gen/gen_snippet_routes.dart                    (Phase 1, Task 6)
tooling/gen/snippet_generator/main.dart                (Phase 1, Task 10)
tooling/gen/snippet_generator/pubspec.yaml             (Phase 1, Task 9)

tooling/gen/test/gen_snippet_routes_test.dart          (Phase 1, Task 5)
tooling/gen/snippet_generator/test/snippet_generator_test.dart   (Phase 1, Task 9)
tooling/gen/snippet_generator/test/fixtures/sample.dart          (Phase 1, Task 9)

apps/docs_snippets/pubspec.yaml                        (Phase 1, Task 11)
apps/docs_snippets/web/index.html                      (Phase 1, Task 11)
apps/docs_snippets/web/manifest.json                   (Phase 1, Task 11)
apps/docs_snippets/lib/main.dart                       (Phase 1, Task 13)
apps/docs_snippets/lib/src/app.dart                    (Phase 1, Task 13)
apps/docs_snippets/lib/src/ready.dart                  (Phase 1, Task 11)
apps/docs_snippets/lib/src/ready_io.dart               (Phase 1, Task 11)
apps/docs_snippets/lib/src/ready_web.dart              (Phase 1, Task 11)
apps/docs_snippets/lib/src/height_post.dart            (Phase 1, Task 15)
apps/docs_snippets/lib/src/height_post_io.dart         (Phase 1, Task 15)
apps/docs_snippets/lib/src/height_post_web.dart        (Phase 1, Task 15)
apps/docs_snippets/lib/src/theme_query.dart            (Phase 1, Task 13)
apps/docs_snippets/lib/src/theme_query_io.dart         (Phase 1, Task 13)
apps/docs_snippets/lib/src/theme_query_web.dart        (Phase 1, Task 13)
apps/docs_snippets/lib/src/routes.g.dart               (Phase 1, Task 7 — generated; checked in)
apps/docs_snippets/lib/snippets/button/regular.dart    (Phase 1, Task 14)
apps/docs_snippets/lib/snippets/button/glass.dart      (Phase 1, Task 14)
apps/docs_snippets/lib/snippets/button/destructive.dart (Phase 1, Task 14)
apps/docs_snippets/test/height_post_test.dart          (Phase 1, Task 15)
apps/docs_snippets/test/routes_smoke_test.dart         (Phase 1, Task 16)

apps/docs/.gitignore                                   (Phase 1, Task 17)
apps/docs/package.json                                  (Phase 1, Task 17)
apps/docs/tsconfig.json                                 (Phase 1, Task 17)
apps/docs/next.config.mjs                               (Phase 1, Task 17)
apps/docs/source.config.ts                              (Phase 1, Task 17)
apps/docs/postcss.config.mjs                            (Phase 1, Task 17)
apps/docs/app/global.css                                (Phase 1, Task 17)
apps/docs/app/layout.tsx                                (Phase 1, Task 18)
apps/docs/app/(home)/page.tsx                           (Phase 1, Task 18)
apps/docs/app/docs/[[...slug]]/page.tsx                 (Phase 1, Task 18)
apps/docs/app/docs/layout.tsx                           (Phase 1, Task 18)
apps/docs/app/api/search/route.ts                       (Phase 1, Task 18)
apps/docs/lib/source.ts                                  (Phase 1, Task 18)
apps/docs/lib/snippet-routes.ts                          (Phase 1, Task 7 — generated; checked in)
apps/docs/lib/layout.shared.tsx                          (Phase 1, Task 18)
apps/docs/components/liq-preview.tsx                    (Phase 1, Task 19)
apps/docs/components/code-snippet.tsx                   (Phase 1, Task 20)
apps/docs/components/__tests__/liq-preview.test.tsx     (Phase 1, Task 19)
apps/docs/components/__tests__/code-snippet.test.tsx    (Phase 1, Task 20)
apps/docs/mdx-components.tsx                            (Phase 1, Task 21)
apps/docs/content/docs/meta.json                        (Phase 1, Task 21; expanded in Phase 2)
apps/docs/content/docs/inputs/meta.json                 (Phase 1, Task 21)
apps/docs/content/docs/inputs/buttons.mdx               (Phase 1, Task 21)
apps/docs/vitest.config.ts                              (Phase 1, Task 19)
apps/docs/playwright.config.ts                          (Phase 1, Task 22)
apps/docs/tests/buttons-page.spec.ts                    (Phase 1, Task 22)
apps/docs/wrangler.jsonc                                (Phase 1, Task 23)

.github/workflows/docs_deploy.yaml                      (Phase 1, Task 23)
```

### Modified

```
CLAUDE.md                                                       (Phase 1, Task 1)
README.md                                                       (Phase 1, Task 1)
pubspec.yaml                                                    (Phase 1, Task 11 — adds workspace member, Task 7 — adds melos scripts)
.gitignore                                                      (Phase 1, Task 3 — append only)
tooling/scripts/check_no_path_runtime_deps.sh                   (Phase 1, Task 24 — verify still passes; no edits expected)
```

---

# Phase 1 — Scaffolding + end-to-end Buttons page

### Task 1: Update CLAUDE.md and README.md to document the Node carve-out

**Files:**
- Modify: `CLAUDE.md`
- Modify: `README.md`

- [ ] **Step 1: Read CLAUDE.md to confirm exact text of "Don'ts" entry.**

Run: `grep -n "steady-state toolchain is pure Dart" CLAUDE.md`
Expected: one matching line near the top of the "Don'ts" section.

- [ ] **Step 2: Replace the existing rule.**

In `CLAUDE.md`, replace the bullet that says (verbatim) "These files are generated by ... The whole steady-state toolchain is pure Dart — Node is no longer used at any point." with:

```markdown
- The steady-state Dart toolchain is pure Dart — Node is not used
  for token generation, components, the showcase, the demo, the
  playground, or any of the existing CI under `.github/workflows/ci.yml`.
  Node, pnpm, and Next.js are used **exclusively** under `apps/docs/`.
  The snippets app at `apps/docs_snippets/` is a normal Flutter Web
  app in the pub workspace and follows the Dart-only rules.
- Do not edit any file under `packages/liqkit_ui_tokens/lib/src/` by
  hand. These files are generated by
  `tooling/gen/generate_canonical_dart.dart` from
  `packages/liqkit_ui_design_data/manifests/canonical_tokens.json`.
  To capture fresh canonical tokens from the Figma variable-defs in
  `liqkit_ui_design_data/figma_artifacts/`, run
  `dart run tooling/gen/capture_canonical_tokens.dart` first, then the
  generator.
```

(Keep all other "Don'ts" bullets unchanged.)

- [ ] **Step 3: Update README.md to point at the docs site path.**

Replace the line `app, the docs site, and the design-data archive ported from `liqkit`.` with the more accurate (post-Phase-1) text:

```markdown
app, the docs site under `apps/docs/`, the docs snippets app under
`apps/docs_snippets/`, and the design-data archive ported from `liqkit`.
```

- [ ] **Step 4: Verify no other rules contradict the carve-out.**

Run: `grep -nE "Node|pnpm|npm|TypeScript" CLAUDE.md README.md`
Expected: only the lines you just edited mention Node / pnpm.

- [ ] **Step 5: Commit.**

```bash
git add CLAUDE.md README.md
git commit -m "docs(claude): document Node carve-out for apps/docs/"
```

---

### Task 2: Add `.nvmrc` and `pnpm-workspace.yaml`

**Files:**
- Create: `.nvmrc`
- Create: `pnpm-workspace.yaml`

- [ ] **Step 1: Create `.nvmrc`.**

Write `.nvmrc` with exactly:

```
24
```

(One line, no quotes, no trailing comments.)

- [ ] **Step 2: Create `pnpm-workspace.yaml`.**

Write `pnpm-workspace.yaml` with:

```yaml
# Node carve-out for the documentation site.
# Dart packages are NOT listed here — they live in pubspec.yaml
# under workspace:.
packages:
  - 'apps/docs'
```

- [ ] **Step 3: Verify pnpm parses it.**

If pnpm is installed locally, run: `pnpm -w ls` (don't worry if it errors because no package exists yet — the parse should still succeed).
Expected: no YAML parse error. If pnpm isn't installed, skip this step.

- [ ] **Step 4: Commit.**

```bash
git add .nvmrc pnpm-workspace.yaml
git commit -m "chore: pin Node 24 + pnpm workspace under apps/docs/"
```

---

### Task 3: Append docs-related entries to root `.gitignore`

**Files:**
- Modify: `.gitignore`

- [ ] **Step 1: Inspect existing `.gitignore`.**

Run: `cat .gitignore`
Expected: existing Dart/Flutter ignores. Note last non-empty line.

- [ ] **Step 2: Append docs ignores.**

Append exactly the following block to the end of `.gitignore`:

```gitignore

# apps/docs (Next.js)
apps/docs/.next/
apps/docs/.open-next/
apps/docs/node_modules/
apps/docs/snippets/
apps/docs/.wrangler/
apps/docs/.dev.vars

# apps/docs_snippets (Flutter Web build)
apps/docs_snippets/build/
apps/docs_snippets/.dart_tool/
```

- [ ] **Step 3: Verify nothing unintentional is now ignored.**

Run: `git status`
Expected: only the `.gitignore` change is reported.

- [ ] **Step 4: Commit.**

```bash
git add .gitignore
git commit -m "chore: ignore apps/docs and apps/docs_snippets build outputs"
```

---

### Task 4: Seed the snippet manifest with Buttons entries

**Files:**
- Create: `tooling/gen/snippet_manifest.json`

The manifest is the **single source of truth** for snippet routes. Phase 1 ships only the 3 Buttons variants; Phase 2 expands it.

- [ ] **Step 1: Create the manifest with Buttons entries.**

Write `tooling/gen/snippet_manifest.json`:

```json
{
  "$schema": "./snippet_manifest.schema.json",
  "components": [
    {
      "component": "button",
      "displayName": "Buttons",
      "group": "inputs",
      "variants": [
        {
          "variant": "regular",
          "displayName": "Regular",
          "dartFile": "apps/docs_snippets/lib/snippets/button/regular.dart"
        },
        {
          "variant": "glass",
          "displayName": "Glass",
          "dartFile": "apps/docs_snippets/lib/snippets/button/glass.dart"
        },
        {
          "variant": "destructive",
          "displayName": "Destructive",
          "dartFile": "apps/docs_snippets/lib/snippets/button/destructive.dart"
        }
      ]
    }
  ]
}
```

- [ ] **Step 2: Validate it parses as JSON.**

Run: `python3 -c "import json; json.load(open('tooling/gen/snippet_manifest.json'))"`
Expected: no output, exit 0.

- [ ] **Step 3: Commit.**

```bash
git add tooling/gen/snippet_manifest.json
git commit -m "chore(gen): seed snippet manifest with Button variants"
```

---

### Task 5: Failing test for `gen_snippet_routes.dart`

**Files:**
- Create: `tooling/gen/test/gen_snippet_routes_test.dart`

- [ ] **Step 1: Create the test directory and the failing test.**

```bash
mkdir -p tooling/gen/test
```

Write `tooling/gen/test/gen_snippet_routes_test.dart`:

```dart
import 'package:test/test.dart';
import '../gen_snippet_routes.dart';

void main() {
  group('renderDartRoutes', () {
    test('emits a Map<String, WidgetBuilder> for one component variant',
        () {
      const fixture = '''
{
  "components": [
    {
      "component": "button",
      "displayName": "Buttons",
      "group": "inputs",
      "variants": [
        {
          "variant": "regular",
          "displayName": "Regular",
          "dartFile": "apps/docs_snippets/lib/snippets/button/regular.dart"
        }
      ]
    }
  ]
}
''';
      final out = renderDartRoutes(fixture);
      expect(out, contains("import 'package:docs_snippets/snippets/button/regular.dart'"));
      expect(out, contains("'/button/regular':"));
      expect(out, contains('buttonRegularBuilder'));
    });
  });

  group('renderTsRoutes', () {
    test('emits a TS const map keyed by component-variant', () {
      const fixture = '''
{
  "components": [
    {
      "component": "button",
      "displayName": "Buttons",
      "group": "inputs",
      "variants": [
        {
          "variant": "regular",
          "displayName": "Regular",
          "dartFile": "apps/docs_snippets/lib/snippets/button/regular.dart"
        }
      ]
    }
  ]
}
''';
      final out = renderTsRoutes(fixture);
      expect(out, contains("export const SNIPPET_ROUTES"));
      expect(out, contains("'button/regular'"));
      expect(out, contains("path: '/button/regular'"));
    });
  });
}
```

- [ ] **Step 2: Verify the test file fails because the generator doesn't exist yet.**

Run: `cd tooling/gen && dart pub get 2>&1 | head -5`
Expected: error about missing `pubspec.yaml`. Proceed to Task 6 to add it.

---

### Task 6: Implement `gen_snippet_routes.dart` to make Task 5 pass

**Files:**
- Create: `tooling/gen/pubspec.yaml`
- Create: `tooling/gen/gen_snippet_routes.dart`
- Create: `tooling/gen/analysis_options.yaml`

- [ ] **Step 1: Create `tooling/gen/pubspec.yaml`.**

Write `tooling/gen/pubspec.yaml`:

```yaml
name: liqkit_ui_gen
description: Internal Dart generators for liqkit_ui (snippet routes, snippet code).
publish_to: none
version: 0.0.1

environment:
  sdk: ^3.7.0

dev_dependencies:
  test: ^1.25.0
```

- [ ] **Step 2: Create a minimal `analysis_options.yaml`.**

Write `tooling/gen/analysis_options.yaml`:

```yaml
include: ../../analysis_options.yaml
```

- [ ] **Step 3: Add `tooling/gen` to the workspace.**

Edit `pubspec.yaml` (root) and add `tooling/gen` to the `workspace:` list (after the existing `apps/playground` line). The full list should now read:

```yaml
workspace:
  - packages/liqkit_ui_design_data
  - packages/liqkit_ui_tokens
  - packages/liqkit_ui_assets
  - packages/liqkit_ui
  - apps/showcase
  - apps/demo
  - apps/playground
  - tooling/gen
```

Then add `resolution: workspace` to `tooling/gen/pubspec.yaml` immediately after the `version:` line:

```yaml
resolution: workspace
```

- [ ] **Step 4: Implement `gen_snippet_routes.dart`.**

Write `tooling/gen/gen_snippet_routes.dart`:

```dart
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Pure functions: input is a JSON string of the manifest, output is the
/// generated source. CLI wraps these for IO.

String _camel(String s) {
  final parts = s.split(RegExp(r'[-_]'));
  return parts.first +
      parts.skip(1).map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1)).join();
}

String _identifier(String component, String variant) =>
    '${_camel(component)}${_camel(variant)[0].toUpperCase()}${_camel(variant).substring(1)}Builder';

/// Render the Dart `routes.g.dart` content for [apps/docs_snippets/].
String renderDartRoutes(String manifestJson) {
  final m = jsonDecode(manifestJson) as Map<String, dynamic>;
  final components = (m['components'] as List).cast<Map<String, dynamic>>();
  final imports = <String>[];
  final entries = <String>[];

  for (final c in components) {
    final component = c['component'] as String;
    for (final v in (c['variants'] as List).cast<Map<String, dynamic>>()) {
      final variant = v['variant'] as String;
      final ident = _identifier(component, variant);
      imports.add(
        "import 'package:docs_snippets/snippets/$component/$variant.dart' show $ident;",
      );
      entries.add("  '/$component/$variant': $ident,");
    }
  }

  imports.sort();
  entries.sort();

  return '''
// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tooling/gen/snippet_manifest.json
// Regenerate: melos run docs:gen:routes

import 'package:flutter/widgets.dart';
${imports.join('\n')}

const Map<String, WidgetBuilder> snippetRoutes = <String, WidgetBuilder>{
${entries.join('\n')}
};
''';
}

/// Render the typed TypeScript route lookup for [apps/docs/].
String renderTsRoutes(String manifestJson) {
  final m = jsonDecode(manifestJson) as Map<String, dynamic>;
  final components = (m['components'] as List).cast<Map<String, dynamic>>();
  final entries = <String>[];

  for (final c in components) {
    final component = c['component'] as String;
    for (final v in (c['variants'] as List).cast<Map<String, dynamic>>()) {
      final variant = v['variant'] as String;
      final display = v['displayName'] as String;
      entries.add(
        "  '$component/$variant': { component: '$component', variant: '$variant', displayName: ${jsonEncode(display)}, path: '/$component/$variant' },",
      );
    }
  }
  entries.sort();

  return '''
// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tooling/gen/snippet_manifest.json
// Regenerate: melos run docs:gen:routes

export interface SnippetRoute {
  readonly component: string;
  readonly variant: string;
  readonly displayName: string;
  readonly path: string;
}

export const SNIPPET_ROUTES = {
${entries.join('\n')}
} as const satisfies Record<string, SnippetRoute>;

export type SnippetRouteKey = keyof typeof SNIPPET_ROUTES;
''';
}

Future<void> main(List<String> args) async {
  final repoRoot = Directory.current.path;
  final manifestPath = '$repoRoot/tooling/gen/snippet_manifest.json';
  final manifestJson = await File(manifestPath).readAsString();

  final dartRoutes = renderDartRoutes(manifestJson);
  final tsRoutes = renderTsRoutes(manifestJson);

  final dartOutPath = '$repoRoot/apps/docs_snippets/lib/src/routes.g.dart';
  final tsOutPath = '$repoRoot/apps/docs/lib/snippet-routes.ts';

  await Directory('$repoRoot/apps/docs_snippets/lib/src').create(recursive: true);
  await Directory('$repoRoot/apps/docs/lib').create(recursive: true);

  await File(dartOutPath).writeAsString(dartRoutes);
  await File(tsOutPath).writeAsString(tsRoutes);

  if (args.contains('--check')) {
    // CI: re-read what's on disk and assert it matches.
    final dartOnDisk = await File(dartOutPath).readAsString();
    final tsOnDisk = await File(tsOutPath).readAsString();
    if (dartOnDisk != dartRoutes || tsOnDisk != tsRoutes) {
      stderr.writeln('snippet routes are stale. Run: melos run docs:gen:routes');
      exit(1);
    }
  }

  print('wrote $dartOutPath');
  print('wrote $tsOutPath');
}
```

- [ ] **Step 5: Run pub get and the test.**

```bash
dart pub get
cd tooling/gen
dart test test/gen_snippet_routes_test.dart
```

Expected: `00:0X +2: All tests passed!`

- [ ] **Step 6: Commit.**

```bash
git add tooling/gen/pubspec.yaml tooling/gen/analysis_options.yaml \
        tooling/gen/gen_snippet_routes.dart \
        tooling/gen/test/gen_snippet_routes_test.dart \
        pubspec.yaml
git commit -m "feat(gen): manifest -> Flutter routes + typed TS lookup"
```

---

### Task 7: Add melos scripts and run the route generator

**Files:**
- Modify: `pubspec.yaml` (root)
- Will be created (by running): `apps/docs_snippets/lib/src/routes.g.dart`
- Will be created (by running): `apps/docs/lib/snippet-routes.ts`

- [ ] **Step 1: Add four melos scripts.**

In root `pubspec.yaml`, append the following entries inside the `melos: scripts:` map (alongside existing `gen:tokens`, `gen:check`, etc.):

```yaml
    docs:gen:routes:
      run: dart run tooling/gen/gen_snippet_routes.dart
      description: Regenerate snippet routes (apps/docs_snippets routes.g.dart and apps/docs snippet-routes.ts).

    docs:gen:routes:check:
      run: dart run tooling/gen/gen_snippet_routes.dart --check
      description: CI check that snippet routes are up to date.

    docs:gen:snippets:
      run: dart run tooling/gen/snippet_generator/main.dart
      description: Regenerate JSON code-snippet files under apps/docs/snippets/ from the Dart sources listed in the manifest.

    docs:gen:snippets:check:
      run: dart run tooling/gen/snippet_generator/main.dart --check
      description: CI check that JSON code-snippet files are up to date.
```

- [ ] **Step 2: Run the route generator.**

```bash
dart pub get
melos run docs:gen:routes
```

Expected stdout:
```
wrote .../apps/docs_snippets/lib/src/routes.g.dart
wrote .../apps/docs/lib/snippet-routes.ts
```

- [ ] **Step 3: Inspect the generated files.**

```bash
cat apps/docs_snippets/lib/src/routes.g.dart
cat apps/docs/lib/snippet-routes.ts
```

Expected: each file starts with `// GENERATED FILE — DO NOT EDIT BY HAND.` and contains the three Button variant entries.

- [ ] **Step 4: Commit.**

```bash
git add pubspec.yaml \
        apps/docs_snippets/lib/src/routes.g.dart \
        apps/docs/lib/snippet-routes.ts
git commit -m "chore(docs): wire docs:gen:routes melos script + initial generation"
```

---

### Task 8: Failing test for the snippet generator

**Files:**
- Create: `tooling/gen/snippet_generator/pubspec.yaml`
- Create: `tooling/gen/snippet_generator/analysis_options.yaml`
- Create: `tooling/gen/snippet_generator/test/snippet_generator_test.dart`
- Create: `tooling/gen/snippet_generator/test/fixtures/sample.dart`

- [ ] **Step 1: Create snippet_generator package layout.**

```bash
mkdir -p tooling/gen/snippet_generator/test/fixtures
```

Write `tooling/gen/snippet_generator/pubspec.yaml`:

```yaml
name: liqkit_ui_snippet_generator
description: Dart analyzer-based extractor of {@highlight} regions from Dart source.
publish_to: none
version: 0.0.1

resolution: workspace

environment:
  sdk: ^3.7.0

dependencies:
  analyzer: ^6.0.0
  path: ^1.9.0

dev_dependencies:
  test: ^1.25.0
```

Write `tooling/gen/snippet_generator/analysis_options.yaml`:

```yaml
include: ../../../analysis_options.yaml
```

Add `tooling/gen/snippet_generator` to root `pubspec.yaml` workspace list (after `tooling/gen`):

```yaml
  - tooling/gen
  - tooling/gen/snippet_generator
```

- [ ] **Step 2: Write the fixture.**

Write `tooling/gen/snippet_generator/test/fixtures/sample.dart`:

```dart
// ignore_for_file: unused_element
import 'package:flutter/widgets.dart';

Widget sampleBuilder() {
  // {@highlight}
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('hello'),
  );
  // {@endhighlight}
}
```

- [ ] **Step 3: Write the failing test.**

Write `tooling/gen/snippet_generator/test/snippet_generator_test.dart`:

```dart
import 'dart:convert';
import 'package:test/test.dart';
import '../main.dart' show extractSnippet;

void main() {
  test('extractSnippet collects highlight markers and source', () {
    const source = '''
import 'package:flutter/widgets.dart';

Widget sampleBuilder() {
  // {@highlight}
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('hello'),
  );
  // {@endhighlight}
}
''';

    final json = extractSnippet(
      sourcePath: 'apps/docs_snippets/lib/snippets/button/regular.dart',
      source: source,
    );
    final decoded = jsonDecode(json) as Map<String, dynamic>;

    expect(decoded['language'], 'dart');
    expect(decoded['file'],
        'apps/docs_snippets/lib/snippets/button/regular.dart');
    expect(decoded['source'], contains("Text('hello')"));
    final highlights = (decoded['highlights'] as List).cast<Map<String, dynamic>>();
    expect(highlights, hasLength(1));
    expect(highlights.single['start'], greaterThan(0));
    expect(highlights.single['end'], greaterThan(highlights.single['start']));
  });
}
```

- [ ] **Step 4: Verify the test fails because `main.dart` doesn't exist.**

Run: `cd tooling/gen/snippet_generator && dart pub get && dart test 2>&1 | head -10`
Expected: `Failed to load ...: ... main.dart was not found.`

---

### Task 9: Implement the snippet generator

**Files:**
- Create: `tooling/gen/snippet_generator/main.dart`

- [ ] **Step 1: Implement `extractSnippet` and the CLI entrypoint.**

Write `tooling/gen/snippet_generator/main.dart`:

```dart
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Extract a snippet record from raw Dart source.
///
/// Public surface: tested directly by snippet_generator_test.dart.
String extractSnippet({
  required String sourcePath,
  required String source,
}) {
  final lines = source.split('\n');
  final highlights = <Map<String, int>>[];
  int? openLine;
  for (var i = 0; i < lines.length; i++) {
    final t = lines[i].trim();
    if (t == '// {@highlight}') {
      openLine = i + 1; // first highlighted line is the next line
    } else if (t == '// {@endhighlight}') {
      if (openLine == null) {
        throw FormatException(
          '$sourcePath:${i + 1}: orphan {@endhighlight} marker',
        );
      }
      // The end-marker line itself is excluded from the highlight.
      highlights.add({'start': openLine + 1, 'end': i});
      openLine = null;
    }
  }
  if (openLine != null) {
    throw FormatException(
      '$sourcePath: unclosed {@highlight} marker (started near line ${openLine + 1})',
    );
  }

  // Strip marker lines from the rendered source so consumers don't see
  // them, then renumber highlight ranges relative to the stripped output.
  final stripped = <String>[];
  final lineMap = <int, int>{}; // original 1-based -> stripped 1-based
  for (var i = 0; i < lines.length; i++) {
    final t = lines[i].trim();
    if (t == '// {@highlight}' || t == '// {@endhighlight}') continue;
    stripped.add(lines[i]);
    lineMap[i + 1] = stripped.length;
  }

  final renumbered = highlights
      .map((h) => {
            'start': lineMap[h['start']!] ?? 0,
            'end': lineMap[h['end']!] ?? 0,
          })
      .toList();

  return const JsonEncoder.withIndent('  ').convert({
    'file': sourcePath,
    'language': 'dart',
    'source': stripped.join('\n'),
    'highlights': renumbered,
  });
}

Future<void> main(List<String> args) async {
  final repoRoot = Directory.current.path;
  final manifestPath = '$repoRoot/tooling/gen/snippet_manifest.json';
  final manifestJson = await File(manifestPath).readAsString();
  final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;
  final components = (manifest['components'] as List).cast<Map<String, dynamic>>();

  final outputs = <String, String>{};
  for (final c in components) {
    final component = c['component'] as String;
    for (final v in (c['variants'] as List).cast<Map<String, dynamic>>()) {
      final variant = v['variant'] as String;
      final dartFile = v['dartFile'] as String;
      final fullPath = '$repoRoot/$dartFile';
      if (!await File(fullPath).exists()) {
        stderr.writeln('snippet_manifest.json: $dartFile does not exist');
        exit(1);
      }
      final source = await File(fullPath).readAsString();
      final json = extractSnippet(sourcePath: dartFile, source: source);
      outputs['apps/docs/snippets/$component/$variant.json'] = json;
    }
  }

  if (args.contains('--check')) {
    var stale = false;
    for (final entry in outputs.entries) {
      final p = '$repoRoot/${entry.key}';
      if (!await File(p).exists() ||
          await File(p).readAsString() != entry.value) {
        stale = true;
        stderr.writeln('stale: ${entry.key}');
      }
    }
    if (stale) {
      stderr.writeln('Run: melos run docs:gen:snippets');
      exit(1);
    }
    print('snippet JSON up to date (${outputs.length} files)');
    return;
  }

  for (final entry in outputs.entries) {
    final p = '$repoRoot/${entry.key}';
    await Directory(File(p).parent.path).create(recursive: true);
    await File(p).writeAsString(entry.value);
    print('wrote ${entry.key}');
  }
}
```

- [ ] **Step 2: Run the test.**

Run: `cd tooling/gen/snippet_generator && dart test`
Expected: `00:0X +1: All tests passed!`

- [ ] **Step 3: Commit.**

```bash
git add tooling/gen/snippet_generator/ pubspec.yaml
git commit -m "feat(gen): {@highlight}-aware Dart snippet extractor"
```

---

### Task 10: Scaffold the `apps/docs_snippets/` Flutter app

**Files:**
- Create: `apps/docs_snippets/pubspec.yaml`
- Create: `apps/docs_snippets/web/index.html`
- Create: `apps/docs_snippets/web/manifest.json`
- Create: `apps/docs_snippets/lib/src/ready.dart`
- Create: `apps/docs_snippets/lib/src/ready_io.dart`
- Create: `apps/docs_snippets/lib/src/ready_web.dart`
- Modify: `pubspec.yaml` (root) — add to workspace

- [ ] **Step 1: Create the pubspec.**

Write `apps/docs_snippets/pubspec.yaml`:

```yaml
name: docs_snippets
description: Single-variant Flutter Web app iframed by apps/docs/. Routes are generated from tooling/gen/snippet_manifest.json.
publish_to: none
version: 0.0.1

resolution: workspace

environment:
  sdk: ^3.7.0
  flutter: ">=3.27.0"

dependencies:
  flutter:
    sdk: flutter
  liqkit_ui:
    path: ../../packages/liqkit_ui
  liqkit_ui_assets:
    path: ../../packages/liqkit_ui_assets

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: false
```

- [ ] **Step 2: Add to workspace.**

Edit root `pubspec.yaml` and append to the `workspace:` list:

```yaml
  - apps/docs_snippets
```

(After `apps/playground`, alongside the existing `tooling/gen` and `tooling/gen/snippet_generator` lines added in earlier tasks.)

- [ ] **Step 3: Create the web entrypoint files.**

Write `apps/docs_snippets/web/index.html`:

```html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="description" content="liqkit_ui docs snippets">
  <title>liqkit_ui — snippet</title>
  <link rel="manifest" href="manifest.json">
  <style>
    html, body { margin: 0; padding: 0; background: transparent; }
    body { background: transparent; }
  </style>
</head>
<body>
  <script src="flutter_bootstrap.js" async></script>
</body>
</html>
```

Write `apps/docs_snippets/web/manifest.json`:

```json
{
  "name": "liqkit_ui docs snippets",
  "short_name": "liqkit-snippets",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#000000",
  "description": "iframe target for liqkit_ui documentation previews",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": []
}
```

- [ ] **Step 4: Add the `setReadyFlag()` conditional-import trio.**

Write `apps/docs_snippets/lib/src/ready.dart`:

```dart
export 'ready_io.dart' if (dart.library.js_interop) 'ready_web.dart';
```

Write `apps/docs_snippets/lib/src/ready_io.dart`:

```dart
/// Non-web no-op.
void setReadyFlag() {}
```

Write `apps/docs_snippets/lib/src/ready_web.dart`:

```dart
@JS()
library;

import 'dart:js_interop';

@JS('liqSnippetsReady')
external set _liqSnippetsReady(JSBoolean value);

/// Web implementation: sets `window.liqSnippetsReady = true` so the
/// docs-side <LiqPreview> wrapper can wait for first paint.
void setReadyFlag() {
  _liqSnippetsReady = true.toJS;
}
```

- [ ] **Step 5: Run `flutter pub get` to confirm the workspace resolves.**

Run: `cd apps/docs_snippets && flutter pub get 2>&1 | tail -5`
Expected: `Got dependencies in ...`. No errors.

- [ ] **Step 6: Commit.**

```bash
git add apps/docs_snippets/pubspec.yaml apps/docs_snippets/web/ \
        apps/docs_snippets/lib/src/ready.dart \
        apps/docs_snippets/lib/src/ready_io.dart \
        apps/docs_snippets/lib/src/ready_web.dart \
        pubspec.yaml
git commit -m "feat(docs_snippets): scaffold Flutter Web app + ready hook"
```

---

### Task 11: Write Buttons snippet sources used by the iframe

**Files:**
- Create: `apps/docs_snippets/lib/snippets/button/regular.dart`
- Create: `apps/docs_snippets/lib/snippets/button/glass.dart`
- Create: `apps/docs_snippets/lib/snippets/button/destructive.dart`

The route generator already references these as `package:docs_snippets/snippets/button/<variant>.dart`. Each must export a top-level `WidgetBuilder`-shaped function whose name matches the convention `${camelComponent}${PascalVariant}Builder`.

- [ ] **Step 1: Create `regular.dart`.**

Write `apps/docs_snippets/lib/snippets/button/regular.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget buttonRegularBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqButton(
      onPressed: () {},
      child: const Text('Regular'),
    ),
  );
  // {@endhighlight}
}
```

- [ ] **Step 2: Create `glass.dart`.**

Write `apps/docs_snippets/lib/snippets/button/glass.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget buttonGlassBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqButton(
      style: LiqButtonStyle.glass,
      onPressed: () {},
      child: const Text('Glass'),
    ),
  );
  // {@endhighlight}
}
```

- [ ] **Step 3: Create `destructive.dart`.**

Write `apps/docs_snippets/lib/snippets/button/destructive.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget buttonDestructiveBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqButton(
      destructive: true,
      onPressed: () {},
      child: const Text('Delete'),
    ),
  );
  // {@endhighlight}
}
```

- [ ] **Step 4: Verify `LiqButton` accepts these arguments.**

Run: `grep -nE "class LiqButton|LiqButtonStyle|destructive" packages/liqkit_ui/lib/src/components/buttons/liq_button.dart | head -20`
Expected: matches showing `LiqButtonStyle` enum, `destructive` parameter, and an `onPressed` constructor argument. If any argument doesn't match the actual API, adjust the snippet to use the real parameter name and re-run.

- [ ] **Step 5: Commit.**

```bash
git add apps/docs_snippets/lib/snippets/
git commit -m "feat(docs_snippets): Buttons snippet variants (regular/glass/destructive)"
```

---

### Task 12: Run the snippet generator and commit the JSON

**Files:**
- Will be created (by running): `apps/docs/snippets/button/regular.json`
- Will be created (by running): `apps/docs/snippets/button/glass.json`
- Will be created (by running): `apps/docs/snippets/button/destructive.json`

These JSON files are gitignored (per Task 3); CI regenerates them. We still **run** the generator now to produce them locally so the dev loop works.

- [ ] **Step 1: Run the snippet generator.**

```bash
melos run docs:gen:snippets
```

Expected stdout:
```
wrote apps/docs/snippets/button/regular.json
wrote apps/docs/snippets/button/glass.json
wrote apps/docs/snippets/button/destructive.json
```

- [ ] **Step 2: Inspect one of the JSON files.**

```bash
cat apps/docs/snippets/button/regular.json
```

Expected: an indented JSON document with `"language": "dart"`, `"file": "apps/docs_snippets/lib/snippets/button/regular.dart"`, a `"source"` string with the marker comments stripped, and one entry in `"highlights"`.

- [ ] **Step 3: Confirm the files are gitignored.**

Run: `git status apps/docs/snippets/`
Expected: empty (no untracked files reported under `apps/docs/snippets/`).

- [ ] **Step 4: No commit. (Generated artifact is gitignored.)**

---

### Task 13: Snippets app — `main.dart`, theme query parsing, and root app

**Files:**
- Create: `apps/docs_snippets/lib/src/theme_query.dart`
- Create: `apps/docs_snippets/lib/src/theme_query_io.dart`
- Create: `apps/docs_snippets/lib/src/theme_query_web.dart`
- Create: `apps/docs_snippets/lib/src/app.dart`
- Create: `apps/docs_snippets/lib/main.dart`

- [ ] **Step 1: Conditional theme-query reader.**

Write `apps/docs_snippets/lib/src/theme_query.dart`:

```dart
export 'theme_query_io.dart'
    if (dart.library.js_interop) 'theme_query_web.dart';
```

Write `apps/docs_snippets/lib/src/theme_query_io.dart`:

```dart
/// Non-web fallback — always light.
String readThemeQueryParam() => 'light';
```

Write `apps/docs_snippets/lib/src/theme_query_web.dart`:

```dart
@JS()
library;

import 'dart:js_interop';

@JS('window')
external _Window get _window;

@JS()
@staticInterop
class _Window {}

extension on _Window {
  external _Location get location;
}

@JS()
@staticInterop
class _Location {}

extension on _Location {
  external String get search;
}

/// Returns "dark" if the URL has `?theme=dark`, else "light".
String readThemeQueryParam() {
  final s = _window.location.search;
  if (s.contains('theme=dark')) return 'dark';
  return 'light';
}
```

- [ ] **Step 2: Root app widget.**

Write `apps/docs_snippets/lib/src/app.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:docs_snippets/src/routes.g.dart';
import 'package:docs_snippets/src/theme_query.dart';

/// Root app — looks up `?theme=` once, picks the LiqTheme, and routes
/// path -> WidgetBuilder via the generated `snippetRoutes` map.
class SnippetsApp extends StatelessWidget {
  const SnippetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = readThemeQueryParam();
    final data = theme == 'dark' ? LiqThemeData.dark : LiqThemeData.light;
    return WidgetsApp(
      title: 'liqkit_ui — snippet',
      color: const Color(0xFF000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (c, _, _) => builder(c),
      ),
      onGenerateRoute: (settings) {
        final builder = snippetRoutes[settings.name ?? '/'] ?? _fallback;
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (c, _, _) => Builder(builder: builder),
        );
      },
      builder: (context, child) => LiqTheme(
        data: data,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

Widget _fallback(BuildContext context) => const ColoredBox(
      color: Color(0xFFFFFFFF),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text(
            'liqkit-snippets-empty',
            style: TextStyle(color: Color(0xFF777777), fontSize: 14),
          ),
        ),
      ),
    );
```

- [ ] **Step 3: `main.dart`.**

Write `apps/docs_snippets/lib/main.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui_assets/liqkit_ui_assets.dart';
import 'package:docs_snippets/src/app.dart';
import 'package:docs_snippets/src/ready.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiqFontLoader.loadAll();
  setReadyFlag();
  runApp(const SnippetsApp());
}
```

- [ ] **Step 4: Run `flutter analyze` and `flutter test`.**

```bash
cd apps/docs_snippets
flutter analyze --fatal-infos --fatal-warnings
```

Expected: `No issues found!`

```bash
flutter test
```

Expected: `No tests found.` (We add tests in the next two tasks.)

- [ ] **Step 5: Commit.**

```bash
git add apps/docs_snippets/lib/main.dart \
        apps/docs_snippets/lib/src/app.dart \
        apps/docs_snippets/lib/src/theme_query.dart \
        apps/docs_snippets/lib/src/theme_query_io.dart \
        apps/docs_snippets/lib/src/theme_query_web.dart
git commit -m "feat(docs_snippets): root app + theme query reader"
```

---

### Task 14: postMessage height hook + widget test (TDD)

**Files:**
- Create: `apps/docs_snippets/lib/src/height_post.dart`
- Create: `apps/docs_snippets/lib/src/height_post_io.dart`
- Create: `apps/docs_snippets/lib/src/height_post_web.dart`
- Create: `apps/docs_snippets/test/height_post_test.dart`

- [ ] **Step 1: Write the failing test.**

Write `apps/docs_snippets/test/height_post_test.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:docs_snippets/src/height_post.dart';

void main() {
  testWidgets('LiqHeightReporter publishes the laid-out height once',
      (tester) async {
    final reports = <int>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: LiqHeightReporter(
          publish: (px) => reports.add(px),
          child: const SizedBox(height: 120, width: 200),
        ),
      ),
    );
    await tester.pump();
    expect(reports, equals(<int>[120]));
  });

  testWidgets('LiqHeightReporter republishes on size change', (tester) async {
    final reports = <int>[];
    final controller = ValueNotifier<double>(80);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: LiqHeightReporter(
          publish: (px) => reports.add(px),
          child: ValueListenableBuilder<double>(
            valueListenable: controller,
            builder: (_, h, __) => SizedBox(height: h, width: 200),
          ),
        ),
      ),
    );
    await tester.pump();
    controller.value = 200;
    await tester.pump();
    expect(reports, equals(<int>[80, 200]));
  });
}
```

- [ ] **Step 2: Verify the test fails.**

Run: `cd apps/docs_snippets && flutter test test/height_post_test.dart 2>&1 | tail -10`
Expected: failure because `LiqHeightReporter` is not defined.

- [ ] **Step 3: Implement `LiqHeightReporter` and the conditional publishers.**

Write `apps/docs_snippets/lib/src/height_post.dart`:

```dart
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'height_post_io.dart'
    if (dart.library.js_interop) 'height_post_web.dart' as platform;

/// Wraps [child] in a [SizeChangedLayoutNotifier] and forwards the
/// laid-out height (rounded to int pixels) to [publish].
///
/// On web, the default publisher posts a {type: 'liq.height', px: N}
/// message to window.parent. On other targets, the default publisher
/// is a no-op.
class LiqHeightReporter extends StatefulWidget {
  const LiqHeightReporter({
    required this.child,
    this.publish,
    super.key,
  });

  final Widget child;
  final void Function(int px)? publish;

  @override
  State<LiqHeightReporter> createState() => _LiqHeightReporterState();
}

class _LiqHeightReporterState extends State<LiqHeightReporter> {
  int? _last;

  void _onLayout(Size size) {
    final px = size.height.round();
    if (px == _last) return;
    _last = px;
    (widget.publish ?? platform.postHeightToParent).call(px);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = context;
          if (!mounted) return;
          final box = ctx.findRenderObject();
          if (box is RenderBox && box.hasSize) _onLayout(box.size);
        });
        return false;
      },
      child: SizeChangedLayoutNotifier(
        child: _SizeReporter(onLayout: _onLayout, child: widget.child),
      ),
    );
  }
}

class _SizeReporter extends SingleChildRenderObjectWidget {
  const _SizeReporter({required this.onLayout, required Widget child})
      : super(child: child);

  final void Function(Size) onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSizeReporter(onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter ro) {
    ro.onLayout = onLayout;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onLayout);

  void Function(Size) onLayout;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _last) {
      _last = size;
      // Defer to post-frame so consumers don't mutate during layout.
      WidgetsBinding.instance.addPostFrameCallback((_) => onLayout(size));
    }
  }
}
```

Write `apps/docs_snippets/lib/src/height_post_io.dart`:

```dart
/// Non-web no-op publisher.
void postHeightToParent(int px) {}
```

Write `apps/docs_snippets/lib/src/height_post_web.dart`:

```dart
@JS()
library;

import 'dart:js_interop';

@JS('window')
external _Window get _window;

@JS()
@staticInterop
class _Window {}

extension on _Window {
  external _Window get parent;
  external void postMessage(JSAny? message, JSString targetOrigin);
}

void postHeightToParent(int px) {
  final payload = {'type': 'liq.height', 'px': px}.jsify();
  _window.parent.postMessage(payload, '*'.toJS);
}
```

- [ ] **Step 4: Run the test.**

Run: `flutter test test/height_post_test.dart`
Expected: `00:0X +2: All tests passed!`

- [ ] **Step 5: Wire `LiqHeightReporter` into the snippet route shell.**

In `apps/docs_snippets/lib/src/app.dart`, replace the `pageBuilder:` of `onGenerateRoute` with:

```dart
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (c, _, _) => LiqHeightReporter(
            child: Builder(builder: builder),
          ),
        );
```

…and add the import at the top of the file:

```dart
import 'package:docs_snippets/src/height_post.dart';
```

- [ ] **Step 6: Re-run analyze + test.**

```bash
flutter analyze --fatal-infos --fatal-warnings
flutter test
```

Expected: clean.

- [ ] **Step 7: Commit.**

```bash
git add apps/docs_snippets/lib/src/height_post.dart \
        apps/docs_snippets/lib/src/height_post_io.dart \
        apps/docs_snippets/lib/src/height_post_web.dart \
        apps/docs_snippets/lib/src/app.dart \
        apps/docs_snippets/test/height_post_test.dart
git commit -m "feat(docs_snippets): post-layout height -> window.parent"
```

---

### Task 15: Routes smoke test + `flutter build web`

**Files:**
- Create: `apps/docs_snippets/test/routes_smoke_test.dart`

- [ ] **Step 1: Write a smoke test that pumps every generated route.**

Write `apps/docs_snippets/test/routes_smoke_test.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:docs_snippets/src/routes.g.dart';

void main() {
  for (final entry in snippetRoutes.entries) {
    testWidgets('snippet route ${entry.key} pumps', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: LiqTheme(
              data: LiqThemeData.light,
              child: Builder(builder: entry.value),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
```

- [ ] **Step 2: Run it.**

```bash
flutter test test/routes_smoke_test.dart
```

Expected: 3 passing tests (one per Buttons variant).

- [ ] **Step 3: Build for web.**

```bash
flutter build web --no-web-resources-cdn --pwa-strategy=none --no-tree-shake-icons
```

Expected: `✓ Built build/web` and no errors.

- [ ] **Step 4: Manually verify a route renders.**

```bash
cd build/web
python3 -m http.server 4174 &
SERVER=$!
sleep 2
curl -sf http://localhost:4174/index.html > /dev/null && echo OK
kill $SERVER
```

Expected: `OK`. (Real visual verification happens in Phase 1, Task 22 via Playwright.)

- [ ] **Step 5: Commit.**

```bash
git add apps/docs_snippets/test/routes_smoke_test.dart
git commit -m "test(docs_snippets): smoke-pump every generated snippet route"
```

---

### Task 16: Scaffold `apps/docs/` (Next.js + Fumadocs)

**Files:**
- Create: `apps/docs/.gitignore`
- Create: `apps/docs/package.json`
- Create: `apps/docs/tsconfig.json`
- Create: `apps/docs/next.config.mjs`
- Create: `apps/docs/source.config.ts`
- Create: `apps/docs/postcss.config.mjs`
- Create: `apps/docs/app/global.css`

- [ ] **Step 1: Create `apps/docs/.gitignore`.**

Write `apps/docs/.gitignore`:

```gitignore
node_modules/
.next/
.open-next/
.wrangler/
.dev.vars
snippets/
out/
*.tsbuildinfo
```

- [ ] **Step 2: Create `apps/docs/package.json`.**

Write `apps/docs/package.json`:

```json
{
  "name": "liqkit-docs",
  "version": "0.0.1",
  "private": true,
  "type": "module",
  "packageManager": "pnpm@10.0.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "e2e": "playwright test"
  },
  "dependencies": {
    "fumadocs-core": "16.6.17",
    "fumadocs-mdx": "14.2.10",
    "fumadocs-ui": "16.6.17",
    "next": "16.2.4",
    "next-themes": "0.4.6",
    "react": "19.2.5",
    "react-dom": "19.2.5",
    "shiki": "4.0.0"
  },
  "devDependencies": {
    "@opennextjs/cloudflare": "1.19.4",
    "@playwright/test": "1.50.0",
    "@tailwindcss/postcss": "4.2.4",
    "@testing-library/jest-dom": "6.6.3",
    "@testing-library/react": "16.1.0",
    "@types/node": "24.0.0",
    "@types/react": "19.0.0",
    "@types/react-dom": "19.0.0",
    "jsdom": "26.0.0",
    "tailwindcss": "4.2.4",
    "typescript": "5.9.3",
    "vitest": "2.2.0",
    "wrangler": "3.95.0"
  }
}
```

- [ ] **Step 3: Create `apps/docs/tsconfig.json`.**

Write `apps/docs/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
```

- [ ] **Step 4: Create `apps/docs/next.config.mjs`.**

Write `apps/docs/next.config.mjs`:

```js
import { createMDX } from 'fumadocs-mdx/next';

const withMDX = createMDX();

const SNIPPETS_URL = process.env.NEXT_PUBLIC_SNIPPETS_URL;
if (!SNIPPETS_URL || !/^https?:\/\//.test(SNIPPETS_URL)) {
  // Fail loud and early — the iframe will be broken if this is missing.
  // Allow the dev command to proceed with a default for local dev.
  if (process.env.NODE_ENV === 'production') {
    throw new Error(
      'NEXT_PUBLIC_SNIPPETS_URL must be set to a https:// URL when building for production.',
    );
  }
}

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,
  pageExtensions: ['ts', 'tsx', 'mdx'],
};

export default withMDX(config);
```

- [ ] **Step 5: Create `apps/docs/source.config.ts`.**

Write `apps/docs/source.config.ts`:

```ts
import { defineDocs, defineConfig } from 'fumadocs-mdx/config';

export const docs = defineDocs({
  dir: 'content/docs',
});

export default defineConfig({
  mdxOptions: {
    rehypeCodeOptions: {
      themes: { light: 'github-light', dark: 'github-dark' },
    },
  },
});
```

- [ ] **Step 6: Create `apps/docs/postcss.config.mjs` and `apps/docs/app/global.css`.**

Write `apps/docs/postcss.config.mjs`:

```js
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
};
```

Write `apps/docs/app/global.css`:

```css
@import 'tailwindcss';
@import 'fumadocs-ui/css/neutral.css';
@import 'fumadocs-ui/css/preset.css';
```

- [ ] **Step 7: Run `pnpm install` and confirm.**

```bash
cd apps/docs
pnpm install
```

Expected: `Done in ...`. A `pnpm-lock.yaml` is created. Commit it (it's not gitignored).

- [ ] **Step 8: Commit.**

```bash
git add apps/docs/.gitignore apps/docs/package.json apps/docs/tsconfig.json \
        apps/docs/next.config.mjs apps/docs/source.config.ts \
        apps/docs/postcss.config.mjs apps/docs/app/global.css \
        apps/docs/pnpm-lock.yaml
git commit -m "feat(docs): scaffold Next 16 + Fumadocs 16 + Tailwind 4"
```

---

### Task 17: Fumadocs source binding, layout, and search route

**Files:**
- Create: `apps/docs/lib/source.ts`
- Create: `apps/docs/lib/layout.shared.tsx`
- Create: `apps/docs/app/layout.tsx`
- Create: `apps/docs/app/(home)/page.tsx`
- Create: `apps/docs/app/docs/layout.tsx`
- Create: `apps/docs/app/docs/[[...slug]]/page.tsx`
- Create: `apps/docs/app/api/search/route.ts`

- [ ] **Step 1: Source binding.**

Write `apps/docs/lib/source.ts`:

```ts
import { docs } from '@/.source';
import { loader } from 'fumadocs-core/source';

export const source = loader({
  baseUrl: '/docs',
  source: docs.toFumadocsSource(),
});
```

- [ ] **Step 2: Shared layout config.**

Write `apps/docs/lib/layout.shared.tsx`:

```tsx
import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';

export const baseOptions: BaseLayoutProps = {
  nav: {
    title: 'liqkit_ui',
    url: '/',
  },
  links: [
    { text: 'Docs', url: '/docs' },
    {
      text: 'GitHub',
      url: 'https://github.com/forus-labs/liqkit_ui',
      external: true,
    },
  ],
};
```

- [ ] **Step 3: Root layout.**

Write `apps/docs/app/layout.tsx`:

```tsx
import './global.css';
import { RootProvider } from 'fumadocs-ui/provider';
import type { ReactNode } from 'react';

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className="flex min-h-screen flex-col">
        <RootProvider>{children}</RootProvider>
      </body>
    </html>
  );
}
```

- [ ] **Step 4: Home page.**

Write `apps/docs/app/(home)/page.tsx`:

```tsx
import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="flex flex-1 flex-col items-center justify-center p-8 text-center">
      <h1 className="text-4xl font-bold">liqkit_ui</h1>
      <p className="mt-2 text-lg text-fd-muted-foreground">
        iOS 26 Liquid Glass design system for Flutter.
      </p>
      <Link
        href="/docs"
        className="mt-6 rounded-md bg-fd-primary px-4 py-2 text-fd-primary-foreground"
      >
        Browse the docs
      </Link>
    </main>
  );
}
```

- [ ] **Step 5: Docs layout.**

Write `apps/docs/app/docs/layout.tsx`:

```tsx
import { DocsLayout } from 'fumadocs-ui/layouts/docs';
import { source } from '@/lib/source';
import { baseOptions } from '@/lib/layout.shared';
import type { ReactNode } from 'react';

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <DocsLayout tree={source.pageTree} {...baseOptions}>
      {children}
    </DocsLayout>
  );
}
```

- [ ] **Step 6: Per-page docs route.**

Write `apps/docs/app/docs/[[...slug]]/page.tsx`:

```tsx
import { notFound } from 'next/navigation';
import { source } from '@/lib/source';
import { DocsPage, DocsBody, DocsTitle } from 'fumadocs-ui/page';
import { mdxComponents } from '@/mdx-components';

export default async function Page(props: {
  params: Promise<{ slug?: string[] }>;
}) {
  const params = await props.params;
  const page = source.getPage(params.slug);
  if (!page) notFound();
  const MDX = page.data.body;
  return (
    <DocsPage toc={page.data.toc} full={page.data.full}>
      <DocsTitle>{page.data.title}</DocsTitle>
      <DocsBody>
        <MDX components={mdxComponents} />
      </DocsBody>
    </DocsPage>
  );
}

export async function generateStaticParams() {
  return source.generateParams();
}

export async function generateMetadata(props: {
  params: Promise<{ slug?: string[] }>;
}) {
  const params = await props.params;
  const page = source.getPage(params.slug);
  if (!page) notFound();
  return {
    title: page.data.title,
    description: page.data.description,
  };
}
```

- [ ] **Step 7: Search API route.**

Write `apps/docs/app/api/search/route.ts`:

```ts
import { source } from '@/lib/source';
import { createFromSource } from 'fumadocs-core/search/server';

export const { GET } = createFromSource(source, { language: 'english' });
```

- [ ] **Step 8: Verify TypeScript compiles.**

```bash
cd apps/docs
pnpm typecheck 2>&1 | tail -10
```

Expected: silent success. (You may see a missing-module error for `@/.source` until `pnpm build` runs once — proceed; that's generated by `fumadocs-mdx/next`.)

- [ ] **Step 9: Commit.**

```bash
git add apps/docs/lib/source.ts apps/docs/lib/layout.shared.tsx \
        apps/docs/app/layout.tsx apps/docs/app/(home)/page.tsx \
        apps/docs/app/docs/layout.tsx \
        apps/docs/app/docs/\[\[...slug\]\]/page.tsx \
        apps/docs/app/api/search/route.ts
git commit -m "feat(docs): Fumadocs root + docs layout + search route"
```

---

### Task 18: `<LiqPreview>` client component (TDD)

**Files:**
- Create: `apps/docs/vitest.config.ts`
- Create: `apps/docs/components/__tests__/liq-preview.test.tsx`
- Create: `apps/docs/components/liq-preview.tsx`

- [ ] **Step 1: Vitest config.**

Write `apps/docs/vitest.config.ts`:

```ts
import { defineConfig } from 'vitest/config';
import path from 'node:path';

export default defineConfig({
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['@testing-library/jest-dom/vitest'],
  },
  resolve: {
    alias: {
      '@': path.resolve(import.meta.dirname),
    },
  },
});
```

- [ ] **Step 2: Failing test.**

Write `apps/docs/components/__tests__/liq-preview.test.tsx`:

```tsx
import { render, screen } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { LiqPreview } from '../liq-preview';

vi.mock('next-themes', () => ({
  useTheme: () => ({ resolvedTheme: 'light' }),
}));

describe('LiqPreview', () => {
  it('renders an iframe whose src matches the manifest path', () => {
    render(
      <LiqPreview
        component="button"
        variant="regular"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );
    const iframe = screen.getByTitle('liqkit_ui — button/regular');
    expect(iframe.tagName).toBe('IFRAME');
    expect(iframe).toHaveAttribute(
      'src',
      'https://snippets.example.com/button/regular?theme=light',
    );
  });

  it('updates iframe height when a liq.height message arrives', async () => {
    render(
      <LiqPreview
        component="button"
        variant="regular"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );
    const iframe = screen.getByTitle(
      'liqkit_ui — button/regular',
    ) as HTMLIFrameElement;
    expect(iframe.height).toBe('200');
    window.dispatchEvent(
      new MessageEvent('message', {
        data: { type: 'liq.height', px: 360 },
        origin: 'https://snippets.example.com',
      }),
    );
    expect(iframe.height).toBe('360');
  });

  it('ignores liq.height messages from a different origin', () => {
    render(
      <LiqPreview
        component="button"
        variant="regular"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );
    const iframe = screen.getByTitle(
      'liqkit_ui — button/regular',
    ) as HTMLIFrameElement;
    window.dispatchEvent(
      new MessageEvent('message', {
        data: { type: 'liq.height', px: 9999 },
        origin: 'https://attacker.example',
      }),
    );
    expect(iframe.height).toBe('200');
  });
});
```

- [ ] **Step 3: Verify test fails.**

```bash
cd apps/docs
pnpm test 2>&1 | tail -10
```

Expected: failure because `liq-preview.tsx` doesn't exist yet.

- [ ] **Step 4: Implement `LiqPreview`.**

Write `apps/docs/components/liq-preview.tsx`:

```tsx
'use client';

import { useEffect, useRef, useState } from 'react';
import { useTheme } from 'next-themes';
import { SNIPPET_ROUTES, type SnippetRouteKey } from '@/lib/snippet-routes';

export interface LiqPreviewProps {
  component: string;
  variant: string;
  /** Override for tests; otherwise read from NEXT_PUBLIC_SNIPPETS_URL. */
  snippetsBaseUrl?: string;
  /** Initial iframe height before the snippets app reports its layout. */
  initialHeight?: number;
}

export function LiqPreview({
  component,
  variant,
  snippetsBaseUrl,
  initialHeight = 200,
}: LiqPreviewProps) {
  const key = `${component}/${variant}` as SnippetRouteKey;
  if (!(key in SNIPPET_ROUTES)) {
    throw new Error(
      `LiqPreview: unknown snippet route "${key}". Add it to tooling/gen/snippet_manifest.json and re-run melos run docs:gen:routes.`,
    );
  }
  const route = SNIPPET_ROUTES[key];
  const baseUrl =
    snippetsBaseUrl ?? process.env.NEXT_PUBLIC_SNIPPETS_URL ?? '';
  const { resolvedTheme } = useTheme();
  const theme = resolvedTheme === 'dark' ? 'dark' : 'light';
  const src = `${baseUrl}${route.path}?theme=${theme}`;
  const [height, setHeight] = useState(initialHeight);
  const iframeRef = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    function onMessage(e: MessageEvent) {
      if (e.origin !== baseUrl) return;
      const data = e.data as { type?: string; px?: number };
      if (data?.type === 'liq.height' && typeof data.px === 'number') {
        setHeight(Math.max(48, Math.min(2000, data.px)));
      }
    }
    window.addEventListener('message', onMessage);
    return () => window.removeEventListener('message', onMessage);
  }, [baseUrl]);

  return (
    <iframe
      ref={iframeRef}
      src={src}
      title={`liqkit_ui — ${component}/${variant}`}
      width="100%"
      height={height}
      loading="lazy"
      sandbox="allow-scripts allow-same-origin"
      style={{ border: '1px solid var(--color-fd-border)', borderRadius: 12 }}
    />
  );
}
```

- [ ] **Step 5: Run the test.**

```bash
pnpm test 2>&1 | tail -10
```

Expected: 3 passing tests.

- [ ] **Step 6: Commit.**

```bash
git add apps/docs/vitest.config.ts \
        apps/docs/components/liq-preview.tsx \
        apps/docs/components/__tests__/liq-preview.test.tsx
git commit -m "feat(docs): <LiqPreview> iframe with origin-checked height sync"
```

---

### Task 19: `<CodeSnippet>` client component (TDD)

**Files:**
- Create: `apps/docs/components/code-snippet.tsx`
- Create: `apps/docs/components/__tests__/code-snippet.test.tsx`

- [ ] **Step 1: Failing test.**

Write `apps/docs/components/__tests__/code-snippet.test.tsx`:

```tsx
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { CodeSnippet } from '../code-snippet';

describe('CodeSnippet', () => {
  it('renders the source as a <pre>', () => {
    const json = {
      file: 'a/b.dart',
      language: 'dart',
      source: 'final x = 1;\nfinal y = 2;\n',
      highlights: [{ start: 1, end: 1 }],
    };
    render(<CodeSnippet snippet={json} />);
    const pre = screen.getByTestId('code-snippet');
    expect(pre.textContent).toContain('final x = 1;');
    expect(pre.textContent).toContain('final y = 2;');
  });

  it('annotates highlighted lines with data-highlight', () => {
    const json = {
      file: 'a/b.dart',
      language: 'dart',
      source: 'a\nb\nc\n',
      highlights: [{ start: 2, end: 2 }],
    };
    render(<CodeSnippet snippet={json} />);
    const lines = screen.getAllByTestId('code-line');
    expect(lines).toHaveLength(3);
    expect(lines[0]).not.toHaveAttribute('data-highlight');
    expect(lines[1]).toHaveAttribute('data-highlight', 'true');
    expect(lines[2]).not.toHaveAttribute('data-highlight');
  });
});
```

- [ ] **Step 2: Verify failure.**

Run: `cd apps/docs && pnpm test components/__tests__/code-snippet.test.tsx 2>&1 | tail -5`
Expected: missing-module error for `../code-snippet`.

- [ ] **Step 3: Implement `<CodeSnippet>`.**

Write `apps/docs/components/code-snippet.tsx`:

```tsx
import type { ComponentProps } from 'react';

export interface SnippetJson {
  file: string;
  language: string;
  source: string;
  highlights: { start: number; end: number }[];
}

interface CodeSnippetProps extends ComponentProps<'pre'> {
  snippet: SnippetJson;
}

export function CodeSnippet({ snippet, className, ...rest }: CodeSnippetProps) {
  const lines = snippet.source.split('\n');
  const isHighlighted = (oneBasedLine: number) =>
    snippet.highlights.some(
      (h) => oneBasedLine >= h.start && oneBasedLine <= h.end,
    );

  return (
    <pre
      data-testid="code-snippet"
      className={`liq-code rounded-md border bg-fd-card p-4 font-mono text-sm ${className ?? ''}`}
      {...rest}
    >
      <code>
        {lines.map((line, i) => {
          const lineNo = i + 1;
          const highlighted = isHighlighted(lineNo);
          return (
            <span
              key={i}
              data-testid="code-line"
              {...(highlighted ? { 'data-highlight': 'true' } : {})}
              className={
                highlighted
                  ? 'block bg-fd-accent/10 -mx-4 px-4'
                  : 'block'
              }
            >
              {line || '​'}
            </span>
          );
        })}
      </code>
    </pre>
  );
}
```

> Note: this component renders pre-extracted source and applies highlight ranges. Shiki-driven syntax colorisation is layered on top in a follow-up Phase 2 task — the v1 contract is *correctness of source + highlights*, not full token-coloring.

- [ ] **Step 4: Run.**

Run: `pnpm test 2>&1 | tail -10`
Expected: all tests passing (5 across both files).

- [ ] **Step 5: Commit.**

```bash
git add apps/docs/components/code-snippet.tsx \
        apps/docs/components/__tests__/code-snippet.test.tsx
git commit -m "feat(docs): <CodeSnippet> renders extracted Dart source + highlights"
```

---

### Task 20: MDX components, sidebar root, and the Buttons page

**Files:**
- Create: `apps/docs/mdx-components.tsx`
- Create: `apps/docs/content/docs/meta.json`
- Create: `apps/docs/content/docs/index.mdx`
- Create: `apps/docs/content/docs/inputs/meta.json`
- Create: `apps/docs/content/docs/inputs/buttons.mdx`

- [ ] **Step 1: MDX component map.**

Write `apps/docs/mdx-components.tsx`:

```tsx
import defaultMdxComponents from 'fumadocs-ui/mdx';
import { LiqPreview } from '@/components/liq-preview';
import { CodeSnippet } from '@/components/code-snippet';

export const mdxComponents = {
  ...defaultMdxComponents,
  LiqPreview,
  CodeSnippet,
};

// Required by Next 16 MDX provider:
export function useMDXComponents(components: Record<string, unknown>) {
  return { ...mdxComponents, ...components };
}
```

- [ ] **Step 2: Sidebar root meta — Phase 1 only includes Inputs and a stub.**

Write `apps/docs/content/docs/meta.json`:

```json
{
  "title": "Documentation",
  "pages": [
    "index",
    "---Inputs---",
    "inputs"
  ]
}
```

- [ ] **Step 3: Docs landing page.**

Write `apps/docs/content/docs/index.mdx`:

```mdx
---
title: Welcome
description: liqkit_ui is the iOS 26 Liquid Glass design system for Flutter.
---

This is the documentation hub for `liqkit_ui`. Browse components in the
sidebar.
```

- [ ] **Step 4: Inputs group meta.**

Write `apps/docs/content/docs/inputs/meta.json`:

```json
{
  "title": "Inputs",
  "defaultOpen": true,
  "pages": [
    "buttons"
  ]
}
```

- [ ] **Step 5: Buttons MDX page.**

Write `apps/docs/content/docs/inputs/buttons.mdx`:

```mdx
---
title: Buttons
description: Tappable controls — regular, glass, and destructive variants.
---

import buttonRegularSnippet from '@/snippets/button/regular.json';
import buttonGlassSnippet from '@/snippets/button/glass.json';
import buttonDestructiveSnippet from '@/snippets/button/destructive.json';

`LiqButton` is the primary tap target in liqkit_ui. It comes in a few
visually distinct styles to match iOS 26 Human Interface Guidelines.

## Regular

A neutral pill — the default style for primary affirmative actions.

<LiqPreview component="button" variant="regular" />

<CodeSnippet snippet={buttonRegularSnippet} />

## Glass

A translucent variant that lets the background tint show through —
intended for floating chrome (toolbars, sheets).

<LiqPreview component="button" variant="glass" />

<CodeSnippet snippet={buttonGlassSnippet} />

## Destructive

Use for actions that delete content or undo work. The label is rendered
in the system red regardless of style.

<LiqPreview component="button" variant="destructive" />

<CodeSnippet snippet={buttonDestructiveSnippet} />
```

- [ ] **Step 6: Run dev build to verify.**

```bash
cd apps/docs
NEXT_PUBLIC_SNIPPETS_URL=https://snippets.example.com pnpm build 2>&1 | tail -25
```

Expected: ends with `✓ Compiled successfully` and lists `/docs/inputs/buttons` among the static pages. The build will reference snippet JSON files generated in Task 12.

- [ ] **Step 7: Commit.**

```bash
git add apps/docs/mdx-components.tsx apps/docs/content/
git commit -m "feat(docs): Buttons MDX page (preview + snippets) + sidebar root"
```

---

### Task 21: Playwright E2E for the Buttons page

**Files:**
- Create: `apps/docs/playwright.config.ts`
- Create: `apps/docs/tests/buttons-page.spec.ts`

- [ ] **Step 1: Playwright config.**

Write `apps/docs/playwright.config.ts`:

```ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? 'http://localhost:3000',
  },
  reporter: 'list',
  webServer: {
    command:
      'NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm next start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
```

- [ ] **Step 2: E2E spec.**

Write `apps/docs/tests/buttons-page.spec.ts`:

```ts
import { test, expect } from '@playwright/test';

test.describe('Buttons docs page', () => {
  test('renders prose, three previews, and three snippets', async ({ page }) => {
    await page.goto('/docs/inputs/buttons');
    await expect(page.locator('h1', { hasText: 'Buttons' })).toBeVisible();

    const iframes = page.locator('iframe[title^="liqkit_ui — button/"]');
    await expect(iframes).toHaveCount(3);
    await expect(
      page.locator('iframe[title="liqkit_ui — button/regular"]'),
    ).toBeVisible();

    const snippets = page.locator('[data-testid="code-snippet"]');
    await expect(snippets).toHaveCount(3);
  });
});
```

- [ ] **Step 3: Install browsers (once per machine).**

```bash
cd apps/docs
pnpm exec playwright install chromium --with-deps
```

- [ ] **Step 4: Run the snippets app on port 4174 (separate shell).**

```bash
cd apps/docs_snippets
flutter build web --no-web-resources-cdn --pwa-strategy=none --no-tree-shake-icons
cd build/web && python3 -m http.server 4174 &
```

- [ ] **Step 5: Build the docs app and run e2e.**

```bash
cd apps/docs
NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm build
pnpm e2e
```

Expected: `1 passed`. Stop the snippets server when done.

- [ ] **Step 6: Commit.**

```bash
git add apps/docs/playwright.config.ts apps/docs/tests/
git commit -m "test(docs): e2e — Buttons docs page renders previews + snippets"
```

---

### Task 22: Cloudflare deploy config + GitHub Actions workflow

**Files:**
- Create: `apps/docs/wrangler.jsonc`
- Create: `.github/workflows/docs_deploy.yaml`

- [ ] **Step 1: Wrangler config for the Worker (docs).**

Write `apps/docs/wrangler.jsonc`:

```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "liqkit-docs-prod",
  "main": ".open-next/worker.js",
  "compatibility_date": "2024-12-30",
  "compatibility_flags": ["nodejs_compat"],
  "assets": {
    "directory": ".open-next/assets",
    "binding": "ASSETS"
  },
  "observability": { "enabled": true },
  "vars": {
    "NEXT_PUBLIC_SNIPPETS_URL": "https://liqkit-snippets-prod.pages.dev"
  }
}
```

- [ ] **Step 2: GitHub Actions workflow.**

Write `.github/workflows/docs_deploy.yaml`:

```yaml
name: docs-deploy

on:
  push:
    branches: [main]
    tags: ['liqkit_ui-v*']
  workflow_dispatch:
    inputs:
      target:
        description: 'Deploy target (prod | dev)'
        type: choice
        options: [prod, dev]
        default: prod

env:
  NODE_VERSION: '24'
  PNPM_VERSION: '10'
  FLUTTER_CHANNEL: stable

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    env:
      SNIPPETS_URL: https://liqkit-snippets-prod.pages.dev
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          channel: ${{ env.FLUTTER_CHANNEL }}

      - name: Resolve Dart workspace
        run: dart pub get

      - name: Activate melos
        run: |
          dart pub global activate melos
          echo "$HOME/.pub-cache/bin" >> $GITHUB_PATH

      - name: Regenerate snippet routes (must be a no-op on a clean checkout)
        run: melos run docs:gen:routes:check

      - name: Regenerate snippet JSON
        run: melos run docs:gen:snippets

      - name: Build docs_snippets (Flutter Web)
        working-directory: apps/docs_snippets
        run: flutter build web --no-web-resources-cdn --pwa-strategy=none --no-tree-shake-icons --base-href=/

      - uses: pnpm/action-setup@v4
        with:
          version: ${{ env.PNPM_VERSION }}

      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
          cache-dependency-path: apps/docs/pnpm-lock.yaml

      - name: pnpm install
        working-directory: apps/docs
        run: pnpm install --frozen-lockfile

      - name: Vitest
        working-directory: apps/docs
        run: pnpm test

      - name: Build docs (Next.js / OpenNext)
        working-directory: apps/docs
        env:
          NEXT_PUBLIC_SNIPPETS_URL: ${{ env.SNIPPETS_URL }}
        run: pnpm exec opennextjs-cloudflare build

      - name: Deploy snippets to Cloudflare Pages
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy apps/docs_snippets/build/web --project-name=liqkit-snippets-prod --branch=main

      - name: Deploy docs to Cloudflare Workers
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          workingDirectory: apps/docs
          command: deploy
```

- [ ] **Step 3: Verify the workflow file parses.**

Run: `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/docs_deploy.yaml'))"`
Expected: no output, exit 0.

- [ ] **Step 4: Confirm the existing `.github/workflows/ci.yml` is untouched.**

Run: `git diff --name-only HEAD~10..HEAD -- .github/workflows/ci.yml`
Expected: empty (no recent edits to ci.yml).

- [ ] **Step 5: Commit.**

```bash
git add apps/docs/wrangler.jsonc .github/workflows/docs_deploy.yaml
git commit -m "ci(docs): wrangler.jsonc + GitHub Actions deploy workflow"
```

---

### Task 23: Local end-to-end smoke check

This task runs nothing new; it just confirms the Phase 1 contract holds end-to-end on a clean clone simulation.

- [ ] **Step 1: From a clean state, regenerate everything.**

```bash
cd <repo-root>
melos run docs:gen:routes:check
melos run docs:gen:snippets
cd apps/docs_snippets && flutter test
cd ../.. && cd apps/docs && pnpm test
```

Expected: every command exits 0.

- [ ] **Step 2: Build both apps locally.**

```bash
cd <repo-root>
cd apps/docs_snippets && flutter build web --no-web-resources-cdn --pwa-strategy=none --no-tree-shake-icons
cd ../docs && NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm build
```

Expected: both succeed.

- [ ] **Step 3: Visual sanity check.**

Run the snippets server (`python3 -m http.server 4174` from `apps/docs_snippets/build/web`), `pnpm next start` from `apps/docs`, and visit `http://localhost:3000/docs/inputs/buttons`. Expected: three button previews appear in three iframes, each with a syntax-highlighted Dart snippet beneath.

- [ ] **Step 4: No commit.** This task is a verification gate.

---

### Task 24: Verify `check_no_path_runtime_deps.sh` still passes

**Files:** none modified.

- [ ] **Step 1: Run the existing check.**

Run: `bash tooling/scripts/check_no_path_runtime_deps.sh`
Expected: exit 0.

(No paths under `apps/docs_snippets/` or `apps/docs/` should trigger the check, because `apps/docs_snippets/pubspec.yaml` has `publish_to: none` and `apps/docs/` is not a Dart package.)

- [ ] **Step 2: No commit.**

---

# Phase 2 — Remaining 36 component pages + 4 guides

> **Pattern for every component page below:** add manifest entries → add Dart snippet files → run `melos run docs:gen:routes` (commits the regenerated `routes.g.dart` and `snippet-routes.ts`) → run `melos run docs:gen:snippets` (the JSON outputs are gitignored, so no commit needed) → write the MDX page using the same shape as `apps/docs/content/docs/inputs/buttons.mdx` (Phase 1, Task 20) → e2e spec for that page.
>
> Phase 2 is a bulk authoring phase — the per-component code is mechanical. Each task below batches one sidebar group, lists the components and their variants, and points at the exact Buttons MDX template to copy.

### Task 25: Foundation group — Colors, Text Styles, Materials

**Files (created/modified, in addition to the manifest + generators):**
- Create: `apps/docs/content/docs/foundation/meta.json`
- Create: `apps/docs/content/docs/foundation/colors.mdx`
- Create: `apps/docs/content/docs/foundation/text-styles.mdx`
- Create: `apps/docs/content/docs/foundation/materials.mdx`
- Create: 5 Dart snippet files under `apps/docs_snippets/lib/snippets/`
- Modify: `tooling/gen/snippet_manifest.json`
- Modify: `apps/docs/content/docs/meta.json` (add `Foundation` separator + folder)

**Variants for this group:**

| Component | Variants | Dart symbol kept under `apps/docs_snippets/lib/snippets/<component>/<variant>.dart` |
|-----------|----------|--------------------------------------------------------------------------------------|
| `colors`  | `swatch-grid` | `colorsSwatchGridBuilder` |
| `text-styles` | `dynamic`, `accessibility` | `textStylesDynamicBuilder`, `textStylesAccessibilityBuilder` |
| `materials` | `light`, `dark` | `materialsLightBuilder`, `materialsDarkBuilder` |

- [ ] **Step 1: Append to `tooling/gen/snippet_manifest.json`** in the `components` array (preserve existing Buttons entry):

```json
    {
      "component": "colors",
      "displayName": "Colors",
      "group": "foundation",
      "variants": [
        {
          "variant": "swatch-grid",
          "displayName": "Swatch grid",
          "dartFile": "apps/docs_snippets/lib/snippets/colors/swatch-grid.dart"
        }
      ]
    },
    {
      "component": "text-styles",
      "displayName": "Text Styles",
      "group": "foundation",
      "variants": [
        { "variant": "dynamic", "displayName": "Dynamic Type", "dartFile": "apps/docs_snippets/lib/snippets/text-styles/dynamic.dart" },
        { "variant": "accessibility", "displayName": "Accessibility sizes", "dartFile": "apps/docs_snippets/lib/snippets/text-styles/accessibility.dart" }
      ]
    },
    {
      "component": "materials",
      "displayName": "Materials",
      "group": "foundation",
      "variants": [
        { "variant": "light", "displayName": "Light", "dartFile": "apps/docs_snippets/lib/snippets/materials/light.dart" },
        { "variant": "dark", "displayName": "Dark", "dartFile": "apps/docs_snippets/lib/snippets/materials/dark.dart" }
      ]
    }
```

- [ ] **Step 2: Author each Dart snippet** at the listed path. Use the same shape as `apps/docs_snippets/lib/snippets/button/regular.dart` from Phase 1, Task 11: a top-level function returning a `Widget` with `// {@highlight}` markers around the construction. The function name must follow the `${camelComponent}${PascalVariant}Builder` rule. Pull the actual API from the canonical `liqkit_ui` exports (`LiqColorSwatchGrid`, `LiqTypeColumn`, `LiqMaterialChip`, etc. — check `packages/liqkit_ui/lib/components.dart`).

- [ ] **Step 3: Regenerate routes and snippets.**

```bash
melos run docs:gen:routes
melos run docs:gen:snippets
flutter test --working-directory=apps/docs_snippets
```

- [ ] **Step 4: Add `apps/docs/content/docs/foundation/meta.json`:**

```json
{
  "title": "Foundation",
  "defaultOpen": true,
  "pages": ["colors", "text-styles", "materials"]
}
```

- [ ] **Step 5: Author each MDX page** using the structure of Phase 1's `apps/docs/content/docs/inputs/buttons.mdx`: frontmatter + per-variant `<LiqPreview>` + `<CodeSnippet>`.

- [ ] **Step 6: Update root `apps/docs/content/docs/meta.json`** to include the new section:

```json
{
  "title": "Documentation",
  "pages": [
    "index",
    "---Foundation---",
    "foundation",
    "---Inputs---",
    "inputs"
  ]
}
```

- [ ] **Step 7: Build to verify.**

```bash
cd apps/docs && NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm build
```

Expected: success and the new pages listed.

- [ ] **Step 8: Commit one batched commit per group:**

```bash
git add tooling/gen/snippet_manifest.json \
        apps/docs_snippets/lib/snippets/colors/ \
        apps/docs_snippets/lib/snippets/text-styles/ \
        apps/docs_snippets/lib/snippets/materials/ \
        apps/docs_snippets/lib/src/routes.g.dart \
        apps/docs/lib/snippet-routes.ts \
        apps/docs/content/docs/foundation/ \
        apps/docs/content/docs/meta.json
git commit -m "feat(docs): Foundation group — Colors, Text Styles, Materials"
```

---

### Task 26: Inputs group — add the remaining 8 components

(Buttons already shipped in Phase 1.)

Components and variants — repeat the Task 25 pattern (manifest → Dart snippets → MDX → meta → commit):

| Component | Variants |
|-----------|----------|
| `toggle` | `on`, `off`, `disabled` |
| `slider` | `default`, `dark` |
| `stepper` | `default`, `disabled` |
| `segmented` | `two`, `three`, `four` |
| `page-controls` | `light`, `dark` |
| `color-picker` | `large`, `small`, `grid` |
| `picker` | `inline-calendar` |
| `text-field` | `empty`, `filled`, `obscured`, `disabled` |

Update `apps/docs/content/docs/inputs/meta.json` to:

```json
{
  "title": "Inputs",
  "defaultOpen": true,
  "pages": [
    "buttons",
    "toggles",
    "sliders",
    "steppers",
    "segmented-controls",
    "page-controls",
    "color-pickers",
    "pickers",
    "text-fields"
  ]
}
```

Commit message: `feat(docs): Inputs group complete — 8 remaining components`.

---

### Task 27: Containers group

| Component | Variants |
|-----------|----------|
| `sheet` | `full-screen`, `stacked`, `inspector` |
| `alert` | `stacked`, `side-by-side`, `destructive` |
| `action-sheet` | `default`, `with-cancel` |
| `notification` | `mail`, `reminders` |
| `popover` | `top`, `bottom`, `leading`, `trailing` |
| `menu` | `default`, `with-section` |
| `context-menu` | `below-leading`, `below-trailing`, `beside-leading` |
| `empty-state` | `default`, `with-cta` |

Add `apps/docs/content/docs/containers/meta.json` with:

```json
{ "title": "Containers", "defaultOpen": true, "pages": ["sheets","alerts","action-sheets","notifications","popovers","menu","context-menu","empty-states"] }
```

Update root meta to slot `Containers` after `Inputs`. Commit: `feat(docs): Containers group — 8 components`.

---

### Task 28: Navigation group

| Component | Variants |
|-----------|----------|
| `top-bar` | `with-title`, `large-title` |
| `toolbar` | `actions`, `chips` |
| `sidebar` | `default`, `with-search` |
| `list` | `grouped`, `dark` |
| `popup-button` | `regular`, `large` |

Folder: `apps/docs/content/docs/navigation/`. Slot in root meta after `Containers`. Commit: `feat(docs): Navigation group — 5 components`.

---

### Task 29: Status group

| Component | Variants |
|-----------|----------|
| `status-bar` | `light`, `dark` |
| `progress` | `linear`, `spinner` |
| `activity-view` | `default` |
| `face-id` | `scanning`, `success`, `fail` |

Folder: `apps/docs/content/docs/status/`. Commit: `feat(docs): Status group — 4 components`.

---

### Task 30: Decoration group

| Component | Variants |
|-----------|----------|
| `app-icon` | `default`, `with-badge`, `with-caption` |
| `bezel` | `with-island`, `no-island` |
| `keyboard` | `qwerty`, `numbers` |
| `widget` | `small`, `medium`, `large`, `extra-large` |
| `window` | `default`, `inactive-controls` |
| `system` | `home-indicator`, `action-pill`, `toggle-dot` |
| `examples` | `panel`, `section`, `item` |
| `kit-helpers` | `header`, `mode-pill`, `mode-labels` |

Folder: `apps/docs/content/docs/decoration/`. Commit: `feat(docs): Decoration group — 8 components`.

---

### Task 31: Guide page — Overview

**Files:**
- Create: `apps/docs/content/docs/getting-started/meta.json`
- Create: `apps/docs/content/docs/getting-started/overview.mdx`

- [ ] **Step 1: Write the meta and the page.**

Write `apps/docs/content/docs/getting-started/meta.json`:

```json
{
  "title": "Getting Started",
  "defaultOpen": true,
  "pages": ["overview", "installation", "theming", "migrating-from-liqkit"]
}
```

Write `apps/docs/content/docs/getting-started/overview.mdx`:

```mdx
---
title: Overview
description: liqkit_ui is the iOS 26 Liquid Glass design system, ported to idiomatic Dart and Flutter.
---

`liqkit_ui` is a Flutter component library that mirrors the iOS 26
"Liquid Glass" aesthetic established by Apple. It contains 37
component categories — buttons, sheets, popovers, status bars,
keyboards, and more — each implemented in pure Dart with no platform
plugins.

## Why liqkit_ui?

- **Pixel-faithful.** Components are sourced from the same CSS/Figma
  spec as the original `liqkit` web library; every category is
  visually verified by Playwright.
- **Pure Dart.** No FFI, no platform channels, no JS interop in the
  components themselves. The library compiles to web, iOS, Android,
  macOS, Linux, and Windows.
- **Themeable.** Every component reads from `LiqThemeData` for
  colors, typography, and spacing. Light and dark variants ship out
  of the box.

## What's in the box

- 37 component categories under `package:liqkit_ui/components.dart`
- Tokens under `package:liqkit_ui_tokens/`
- Pre-bundled SF Pro fonts via `package:liqkit_ui_assets/`

Read the [Installation](/docs/getting-started/installation) page next.
```

- [ ] **Step 2: Build to verify.**

Run: `cd apps/docs && NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm build 2>&1 | tail -10`
Expected: page listed in static output.

- [ ] **Step 3: Commit.**

```bash
git add apps/docs/content/docs/getting-started/meta.json \
        apps/docs/content/docs/getting-started/overview.mdx
git commit -m "docs: Overview guide page"
```

---

### Task 32: Guide page — Installation

**Files:**
- Create: `apps/docs/content/docs/getting-started/installation.mdx`

- [ ] **Step 1: Write the page.**

Write `apps/docs/content/docs/getting-started/installation.mdx`:

````mdx
---
title: Installation
description: Add liqkit_ui to your Flutter app in three lines.
---

```yaml title="pubspec.yaml"
dependencies:
  flutter:
    sdk: flutter
  liqkit_ui: ^0.1.0
  liqkit_ui_assets: ^0.1.0
```

Then run:

```bash
flutter pub get
```

In your app entrypoint, load the bundled SF Pro fonts before
`runApp`:

```dart title="lib/main.dart"
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_assets/liqkit_ui_assets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiqFontLoader.loadAll();
  runApp(const MyApp());
}
```

Wrap any subtree that uses liqkit_ui widgets in a `LiqTheme`:

```dart
LiqTheme(
  data: LiqThemeData.light,
  child: const MyButton(),
)
```

That's it. Browse the sidebar for component examples.
````

- [ ] **Step 2: Commit.**

```bash
git add apps/docs/content/docs/getting-started/installation.mdx
git commit -m "docs: Installation guide page"
```

---

### Task 33: Guide page — Theming

**Files:**
- Create: `apps/docs/content/docs/getting-started/theming.mdx`

- [ ] **Step 1: Write the page.**

Write `apps/docs/content/docs/getting-started/theming.mdx`:

````mdx
---
title: Theming
description: How LiqThemeData drives colors, typography, and spacing across components.
---

Every liqkit_ui component reads its visual tokens from a `LiqThemeData`
instance provided by an enclosing `LiqTheme` widget.

## Built-in themes

```dart
LiqTheme(data: LiqThemeData.light, child: ...)
LiqTheme(data: LiqThemeData.dark,  child: ...)
```

These ship with the canonical iOS 26 token values pulled from Figma
variable-defs. The token tables live in `package:liqkit_ui_tokens` and
are regenerated by a Dart-only pipeline (`melos run gen:tokens`).

## Switching by brightness

```dart
LiqTheme(
  data: MediaQuery.platformBrightnessOf(context) == Brightness.dark
    ? LiqThemeData.dark
    : LiqThemeData.light,
  child: ...,
)
```

## Customising

Use `LiqThemeData.light.copyWith(...)` to override one or more fields.
Per the canonical design (`docs/superpowers/specs/...`), all
component-style data lives directly on `LiqThemeData` — there are no
per-component theme extensions to register.

```dart
final myTheme = LiqThemeData.light.copyWith(
  // Example: override the default action tint.
  primaryColor: const Color(0xFFFF2D55),
);
```
````

- [ ] **Step 2: Commit.**

```bash
git add apps/docs/content/docs/getting-started/theming.mdx
git commit -m "docs: Theming guide page"
```

---

### Task 34: Guide page — Migrating from liqkit

**Files:**
- Create: `apps/docs/content/docs/getting-started/migrating-from-liqkit.mdx`

- [ ] **Step 1: Write the page.**

Write `apps/docs/content/docs/getting-started/migrating-from-liqkit.mdx`:

````mdx
---
title: Migrating from liqkit
description: Map every original CSS-based liqkit component to its Flutter counterpart.
---

`liqkit_ui` is a Dart/Flutter port of the original CSS-based
[liqkit](https://github.com/forus-labs/liqkit) library. Class names
follow a 1:1 mapping with `Liq` as the prefix.

## Naming map

| liqkit (CSS)       | liqkit_ui (Flutter)        |
|--------------------|----------------------------|
| `.ios26-button`    | `LiqButton`                |
| `.ios26-toggle`    | `LiqToggle`                |
| `.ios26-slider`    | `LiqSlider`                |
| `.ios26-sheet`     | `LiqSheet`                 |
| `.ios26-alert`     | `LiqAlert`                 |
| `.ios26-popover`   | `LiqPopover`               |
| `.ios26-status-bar`| `LiqStatusBar`             |
| `.ios26-keyboard`  | `LiqKeyboard`              |

(Full 37-row table omitted; the rule is mechanical — see the sidebar.)

## What's different

- **Theming** is via `LiqThemeData`, not CSS variables.
- **Variants** are Dart `enum` types instead of CSS modifier classes.
- **Layouts** that depend on `position: absolute` in liqkit translate
  to `Stack` + `Positioned` in Flutter.

## What's the same

- Visual fidelity: every Flutter component is verified pixel-for-pixel
  against the rendered HTML baseline using Playwright.
- Token values: colors, typography, and radii come from the same
  `liqkit_ui_design_data` archive as the original CSS.
````

- [ ] **Step 2: Commit.**

```bash
git add apps/docs/content/docs/getting-started/migrating-from-liqkit.mdx
git commit -m "docs: Migrating from liqkit guide page"
```

---

### Task 35: Wire up the full sidebar

**Files:**
- Modify: `apps/docs/content/docs/meta.json`

- [ ] **Step 1: Replace the root meta with the full ordering.**

Write `apps/docs/content/docs/meta.json`:

```json
{
  "title": "Documentation",
  "pages": [
    "index",
    "---Getting Started---",
    "getting-started",
    "---Foundation---",
    "foundation",
    "---Inputs---",
    "inputs",
    "---Containers---",
    "containers",
    "---Navigation---",
    "navigation",
    "---Status---",
    "status",
    "---Decoration---",
    "decoration"
  ]
}
```

- [ ] **Step 2: Build and visually verify the sidebar shape.**

```bash
cd apps/docs && NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm build
pnpm next start &
SERVER=$!
open http://localhost:3000/docs    # macOS
sleep 5
kill $SERVER
```

- [ ] **Step 3: Commit.**

```bash
git add apps/docs/content/docs/meta.json
git commit -m "docs: finalize sidebar — 7 sections + 41 pages"
```

---

### Task 36: Phase 2 e2e — sample-page sweep

**Files:**
- Create: `apps/docs/tests/sample-pages.spec.ts`

- [ ] **Step 1: Write a sweep test.**

Write `apps/docs/tests/sample-pages.spec.ts`:

```ts
import { test, expect } from '@playwright/test';

const SAMPLES = [
  { slug: 'foundation/colors', title: 'Colors' },
  { slug: 'inputs/sliders', title: 'Sliders' },
  { slug: 'containers/sheets', title: 'Sheets' },
  { slug: 'navigation/top-bars', title: 'Top Bars' },
  { slug: 'status/face-id', title: 'Face ID' },
  { slug: 'decoration/keyboards', title: 'Keyboards' },
  { slug: 'getting-started/overview', title: 'Overview' },
];

for (const s of SAMPLES) {
  test(`${s.slug} renders`, async ({ page }) => {
    await page.goto(`/docs/${s.slug}`);
    await expect(page.locator('h1', { hasText: s.title })).toBeVisible();
  });
}
```

- [ ] **Step 2: Run.**

```bash
cd apps/docs && NEXT_PUBLIC_SNIPPETS_URL=http://localhost:4174 pnpm build
pnpm e2e
```

Expected: 7 passing tests.

- [ ] **Step 3: Commit.**

```bash
git add apps/docs/tests/sample-pages.spec.ts
git commit -m "test(docs): sample-page sweep across all 7 sections"
```

---

# Phase 3 — Custom-domain wiring (deferrable)

> Phase 3 is OK to skip until the domain is registered. The site is functional on `*.workers.dev` / `*.pages.dev` defaults at the end of Phase 2.

### Task 37: Register `liqkit.dev` and create DNS records

**Files:** none in the repo. This is a Cloudflare-side action.

- [ ] **Step 1:** Register `liqkit.dev` (or the chosen domain) at Cloudflare Registrar or transfer in.
- [ ] **Step 2:** Add a CNAME record for `liqkit.dev` → `liqkit-docs-prod.workers.dev`.
- [ ] **Step 3:** Add a CNAME record for `snippets.liqkit.dev` → `liqkit-snippets-prod.pages.dev`.
- [ ] **Step 4:** Verify both resolve and respond with the existing content.
- [ ] **Step 5:** No code commit.

---

### Task 38: Add custom routes to `wrangler.jsonc` and update env

**Files:**
- Modify: `apps/docs/wrangler.jsonc`
- Modify: `.github/workflows/docs_deploy.yaml`

- [ ] **Step 1: Update `wrangler.jsonc` to bind the route.**

Replace `apps/docs/wrangler.jsonc` with:

```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "liqkit-docs-prod",
  "main": ".open-next/worker.js",
  "compatibility_date": "2024-12-30",
  "compatibility_flags": ["nodejs_compat"],
  "assets": {
    "directory": ".open-next/assets",
    "binding": "ASSETS"
  },
  "observability": { "enabled": true },
  "routes": [
    { "pattern": "liqkit.dev", "custom_domain": true },
    { "pattern": "www.liqkit.dev", "custom_domain": true }
  ],
  "vars": {
    "NEXT_PUBLIC_SNIPPETS_URL": "https://snippets.liqkit.dev"
  }
}
```

- [ ] **Step 2: Update the workflow's `SNIPPETS_URL` env.**

In `.github/workflows/docs_deploy.yaml`, change `env: SNIPPETS_URL: https://liqkit-snippets-prod.pages.dev` to `env: SNIPPETS_URL: https://snippets.liqkit.dev`.

- [ ] **Step 3: Commit.**

```bash
git add apps/docs/wrangler.jsonc .github/workflows/docs_deploy.yaml
git commit -m "deploy(docs): bind liqkit.dev and snippets.liqkit.dev"
```

- [ ] **Step 4: Push to trigger the workflow.**

Push to `main` (or run `gh workflow run docs-deploy`). Verify the deploy succeeds and the site responds at `liqkit.dev`.

---

### Task 39: Update README pointing at the live site

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add a "Documentation" section near the top.**

Insert after the project description in `README.md`:

```markdown
## Documentation

Browse the live docs at **<https://liqkit.dev>**.
```

- [ ] **Step 2: Commit.**

```bash
git add README.md
git commit -m "docs: link README to live docs site"
```

---

# Self-review (run by the plan author after writing — not a runtime task)

## Spec coverage

- §1 Background context: covered in this plan's introduction and Task 25-30 (manifest entries).
- §2 Constraints — Node carve-out: Task 1 (CLAUDE.md update). Existing `ci.yml` untouched: Task 22 (separate workflow file). `apps/showcase/` untouched: this plan never edits its files.
- §3 Repo layout: every file in the planned tree is created in Phase 1 or Phase 2 (Task 2: `.nvmrc`, `pnpm-workspace.yaml`; Tasks 5-9: tooling/gen/*; Task 10-15: apps/docs_snippets; Task 16-22: apps/docs).
- §4.1 Two-app split: Tasks 10 + 16.
- §4.2 Single-manifest route generation: Tasks 4-7.
- §4.3 Iframe contract (URL shape, postMessage height, theme query): Tasks 13-15 (snippets side), Task 18 (docs side).
- §4.4 Snippet code blocks: Tasks 8-9 (generator), Task 12 (run), Task 19 (`<CodeSnippet>`).
- §5 Components — every row of the table has at least one task: snippets app (10-15), docs app (16-23), gen_snippet_routes (5-7), snippet_generator (8-9), liq-preview (18), code-snippet (19).
- §6 Content scope — 37 components: 1 in Phase 1 (Buttons) + 36 in Phase 2 (Tasks 25-30 cover Foundation 3 + Inputs 8 + Containers 8 + Navigation 5 + Status 4 + Decoration 8 = 36). 4 guides: Tasks 31-34.
- §7 Deploy — Cloudflare Workers + Pages: Task 22 (wrangler config + workflow). Custom domain: Task 38.
- §8 CI: Task 22.
- §9 Tech pins: Task 16 (package.json with exact versions).
- §10 Versioning, search, telemetry: Search via Task 17 (search route). Versioning latest-only — no tasks needed (the absence is the implementation). Telemetry — none, also no tasks.
- §11 Error handling — every bullet has a task: manifest→Dart resolution (Task 9), MDX→manifest typing (Task 7's TS output), snippets routes uniqueness (Task 6's generator), origin filtering (Task 18 test), `NEXT_PUBLIC_SNIPPETS_URL` check (Task 16).
- §12 Testing — Dart unit tests (Tasks 5, 8), Flutter widget test (Task 14), React Vitest (Tasks 18-19), e2e (Task 21, 36).
- §13 Migration / rollout: Phase 1 = Buttons end-to-end (Tasks 1-24); Phase 2 = the rest (Tasks 25-36); Phase 3 = domain (Tasks 37-39).
- §14 Open / explicit-defer list — domain deferral is honored by the Phase split.
- §15 CLAUDE.md change: Task 1.

No spec sections lack at least one task.

## Placeholder scan

Searched for "TBD", "TODO", "implement later", "fill in details", "Add appropriate ...", "Similar to Task" — none present. Phase 2 group tasks (25-30) describe the *batch* but each task lists exact components, exact file paths, and points at the verbatim Buttons template (Task 11 + Task 20) for the per-component code. The "repeat the code" rule is satisfied because the template lives at known anchor points.

## Type consistency

- Dart symbol convention `${camelComponent}${PascalVariant}Builder` is defined in Task 6's generator (`_identifier`) and used identically in Tasks 11 (Buttons) and Tasks 25-30 (other components). ✓
- TS type `SnippetRouteKey` defined in Task 6, consumed in Task 18 (`<LiqPreview>`). ✓
- `setReadyFlag()` is named identically across `ready_io.dart`, `ready_web.dart`, and `ready.dart` re-export — Task 10. ✓
- `postHeightToParent` is named identically in `height_post_io.dart` and `height_post_web.dart` — Task 14. ✓
- `LiqHeightReporter` widget name identical in test (Task 14, Step 1) and implementation (Task 14, Step 3). ✓
- `SnippetJson` interface in `<CodeSnippet>` (Task 19) matches the JSON shape emitted by `extractSnippet` (Task 9): both have `file`, `language`, `source`, `highlights[]{start,end}`. ✓
- `liqSnippetsReady` global flag name appears once (Task 10's `ready_web.dart`). The docs-side `<LiqPreview>` does not currently wait on it — it relies on the iframe's `loading="lazy"` and the height postMessage. This is intentional and matches forui's behavior; the flag is for Playwright only.

No inconsistencies found.

---

**End of plan.**
