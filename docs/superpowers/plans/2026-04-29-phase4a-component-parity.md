# Phase 4A — Foundation Component Parity Plan

> **For agentic workers:** Use superpowers:subagent-driven-development. One subagent per component. Each step is bite-sized.

**Goal:** Add 16 foundational components to liqkit_ui that forui/shadcn ship but we don't, all in iOS-26 Liquid Glass treatment.

**Pattern (every component follows this):**

1. Create `packages/liqkit_ui/lib/src/components/<snake>/liq_<name>.dart` — `final class` extending `StatelessWidget` or `StatefulWidget` with `Diagnosticable` mixin where stateless and `debugFillProperties`. Static `const` color/dimension fields sourced from iOS 26 spec.
2. Add `export 'src/components/<snake>/liq_<name>.dart';` to `packages/liqkit_ui/lib/components.dart` (alphabetical).
3. Create `packages/liqkit_ui/test/components/liq_<name>_test.dart` — at minimum: a behavior test (interaction reports correct value) and a measurement test (canonical size).
4. Create snippet builders under `apps/docs_snippets/lib/snippets/<kebab>/<variant>.dart` — wrap with `Align(heightFactor: 1, child: …)` not `Center`. Mark highlighted region with `// {@highlight} … // {@endhighlight}`. Use `LiqDemo<T>` from `package:docs_snippets/src/demo.dart` for stateful demos.
5. Append entries to `tooling/gen/snippet_manifest.json` `components` array. Run `melos run docs:gen:routes` and `melos run docs:gen:snippets` from repo root.
6. Create `apps/docs/content/docs/<category>/<kebab>.mdx` with the standard structure (YAML frontmatter + LiqPreview + CodeSnippet per variant).
7. Append the new page slug to `apps/docs/content/docs/<category>/meta.json`.
8. Run `melos run fmt && melos run analyze && melos run test` — all pass.
9. Commit as `feat(<name>): add LiqXxx component`.

**Components (in build order):**

| # | Name             | Category   | Variants                                   |
|---|------------------|------------|--------------------------------------------|
| 1 | LiqAccordion     | containers | single, multiple, default                  |
| 2 | LiqAvatar        | foundation | initials, image, group                     |
| 3 | LiqBadge         | status     | counter, status, dot                       |
| 4 | LiqCard          | containers | default, with-header, with-footer          |
| 5 | LiqCheckbox      | inputs     | unchecked, checked, indeterminate          |
| 6 | LiqRadio         | inputs     | group, single                              |
| 7 | LiqDivider       | foundation | horizontal, vertical, with-label           |
| 8 | LiqSkeleton      | status     | rect, circle, text                         |
| 9 | LiqTabs          | navigation | top, underline, pill                       |
| 10| LiqTooltip       | status     | top, bottom, with-arrow                    |
| 11| LiqToast         | status     | success, error, info                       |
| 12| LiqDrawer        | containers | left, right                                |
| 13| LiqDialog        | containers | default, with-actions                      |
| 14| LiqLabel         | foundation | required, optional                         |
| 15| LiqBreadcrumb    | navigation | default, with-separator                    |
| 16| LiqPagination    | navigation | default, compact                           |

Each component dispatched to a fresh subagent. Implementer reports DONE → I run `melos run fmt && analyze && test` → if green, commit and dispatch next.
