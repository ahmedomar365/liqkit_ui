# liqkit iOS 26 Audit And Showcase Rebuild Design

## Goal

Make `liqkit_ui` the single reusable Flutter implementation of the iOS 26
Liquid Glass design system, then rebuild the App Store showcase so every
component catalog page and demo imports from `liqkit_ui` instead of maintaining
duplicated `Liquid*` widgets.

## Context

The workspace has three relevant sources:

- `/Users/ahmedomar/Documents/delta/liqkit/apple_design_figma/liqkit` is the
  canonical Apple/Figma extraction archive. It includes component SVGs, HTML
  previews, node manifests, native-image audits, and release inventory files.
- `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui` is the
  reusable Flutter design-system workspace. Its published package is
  `packages/liqkit_ui`, backed by tokens, assets, design-data packages, docs,
  snippets, tests, and Melos quality gates.
- `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit`
  is the App Store showcase. It currently duplicates component and core design
  code under `lib/components/**` and `lib/core/**`; those duplicates must be
  removed during the migration.

Fresh MIT reference clones are used only as parity references:

- `https://github.com/duobaseio/forui.git`
- `https://github.com/nank1ro/flutter-shadcn-ui`

They are not copied into this project. Their value is API and coverage
comparison: component names, expected variants, controller patterns, portal
behavior, form-field ergonomics, and documentation coverage.

## Design Principles

`liqkit_ui` is the source of truth. Any iOS 26 visual behavior, component
primitive, token, animation, or accessibility rule belongs in
`packages/liqkit_ui`, not in the showcase app.

The showcase is a consumer. It can own app navigation, catalog grouping, demo
data, localization, and Riverpod state, but it cannot own component
implementations, Liquid Glass primitives, theme primitives, or Apple system
tokens.

The audit must be evidence based. Each component receives an explicit status
row with source references, implementation notes, test coverage, and migration
readiness. Components that are cross-platform extensions from forui/shadcn
rather than native iOS controls are allowed, but must be documented as
extensions and rendered with iOS 26 visual language.

## Component Audit Checklist

Create a committed checklist at `docs/audits/ios26_component_checklist.md`.
Every exported `Liq*` widget from `packages/liqkit_ui/lib/components.dart` must
have one row with these columns:

- Component
- Category
- Apple/Figma source
- forui/shadcn parity source
- iOS 26 visual status
- Token usage status
- Glass/material status
- Motion status
- Typography status
- Accessibility status
- Test/doc status
- Showcase status
- Action

Status values are:

- `Pass` for components that conform today.
- `Fix` for components needing code changes in `liqkit_ui`.
- `Extension` for components that are not native iOS primitives but are kept
  for forui/shadcn parity in iOS 26 styling.
- `Defer` only when a component is intentionally excluded from the current
  migration and has a written reason.

The checklist starts from the current exported component set, including but not
limited to buttons, toggles, toggle groups, sliders, steppers, sheets, alerts,
sidebars, lists, popovers, menus, popup buttons, segmented controls, page
controls, progress, text fields, textareas, pickers, color pickers, top bars,
toolbars, bottom navigation, tabs, breadcrumbs, pagination, command palette,
tree view, status bars, notifications, skeletons, toasts, tooltips, hover
cards, badges, app icons, bezels, keyboards, kit helpers, materials, widgets,
windows, system primitives, examples, Face ID, activity views, accordion,
collapsible, avatar, card, carousel, dialog, drawer, resizable, scroll area,
data table, kanban, empty states, divider, label, text styles, colors,
checkbox, radio, chip, calendar, date picker field, time picker, time field,
number field, OTP input, combobox, line chart, bar chart, and rich editor.

## Library Remediation

Fixes happen inside `flutter_components/liqkit_ui` first.

Shared primitives:

- `LiqGlassSurface` is the only component-level glass panel primitive.
  Surface-bearing components must route through it unless a written exception
  explains why a lower-level paint path is required.
- `LiqMotion` is the only public motion namespace for component transitions.
  Component-local durations and curves should be replaced with the closest
  existing `LiqMotion` preset.
- `LiqThemeData`, token packages, and `LiqTypography` remain the source for
  colors and text. Hard-coded visual constants are acceptable only when they
  are canonical iOS measurements documented in the component.

Component criteria:

- Layout must match the closest Apple/Figma artifact when one exists.
- Light/dark behavior must be defined and testable.
- Interactive components that maintain selection, open/closed, focus, checked,
  value, or current-page state must expose controlled state APIs.
- Inputs must preserve focus, keyboard, semantics, disabled, and error states.
- Components inspired by forui/shadcn must keep ergonomic APIs while looking
  native to iOS 26.
- Tests must cover behavior and canonical dimensions. Golden coverage should be
  added where it catches visual regressions better than structural assertions.
- Docs snippets must render the same public API that showcase consumers use.

## Showcase Rebuild

Update the showcase app at
`showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit` so it
depends on the local `liqkit_ui` package by path.

Delete duplicated implementation code from the showcase:

- `lib/components/**`
- `lib/core/effects/**`
- `lib/core/theme/**`
- `lib/core/widgets/**` when a widget is a design-system primitive
- platform component adapters that reimplement visual components

Keep app-owned code:

- `lib/main.dart`
- app shell and navigation
- catalog screens
- demo screens
- demo data/models/providers
- localization
- utility code that is not a design-system primitive

All showcase component examples must import from:

```dart
import 'package:liqkit_ui/liqkit_ui.dart';
```

Additional imports from `liqkit_ui/components.dart`, `liqkit_ui/theme.dart`, or
`liqkit_ui/foundation.dart` are allowed only if the aggregate export is missing
a symbol and the library export should then be fixed.

Every existing showcase demo should be rewritten to use the library component
closest to its purpose. If the showcase references a component that does not
exist in `liqkit_ui`, the missing component is added or the demo is removed
with a checklist note. The preferred result is full showcase coverage of all
`liqkit_ui` components plus the richer domain demos using those components.

## Verification

Library gates:

```bash
melos run fmt
melos run analyze
melos run analyze:flutter
melos run test
```

Showcase gates:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build ios --debug --no-codesign
```

Static migration checks:

- No showcase import may reference `lib/components/**` or old `lib/core/**`
  design primitives.
- No duplicated `Liquid*` component class should remain in the showcase.
- The showcase must import `package:liqkit_ui/liqkit_ui.dart` for component
  rendering.
- `liqkit_ui` must not add runtime dependencies on the showcase app.

## Done Criteria

The work is complete when:

- The audit checklist exists and covers every exported `Liq*` component.
- Each checklist row is `Pass`, `Extension`, or has a completed fix.
- `liqkit_ui` passes all Melos quality gates.
- The showcase app has no duplicated component implementation code.
- All catalog and demo screens compile against `liqkit_ui`.
- The showcase passes analyze, tests, and an iOS debug build without signing.
