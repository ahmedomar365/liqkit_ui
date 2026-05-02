# liqkit iOS 26 Audit And Showcase Rebuild Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `liqkit_ui` the only reusable iOS 26 Liquid Glass component implementation, then rebuild the App Store showcase so it imports and demonstrates `liqkit_ui` only.

**Architecture:** The reusable library remains in `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/packages/liqkit_ui`. Audit evidence and migration guards live in the same repo under `docs/audits/` and `tooling/scripts/`. The App Store showcase at `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit` becomes an app shell, catalog, and demo-data consumer with a local path dependency on `liqkit_ui`.

**Tech Stack:** Flutter, Dart, Melos, `liqkit_ui`, `liqkit_ui_tokens`, `liqkit_ui_assets`, Apple/Figma SVG/HTML artifacts, forui and flutter-shadcn-ui as MIT parity references.

---

## File Structure

Create in `flutter_components/liqkit_ui`:

- `docs/audits/ios26_component_checklist.md`: the authoritative component-by-component audit table.
- `tooling/scripts/check_component_audit.dart`: verifies the checklist covers every export in `packages/liqkit_ui/lib/components.dart`.
- `tooling/scripts/check_showcase_migration.dart`: verifies the showcase has no old `Liquid*` components or old design-system imports after migration.

Modify in `flutter_components/liqkit_ui` as fixes are discovered:

- `packages/liqkit_ui/lib/src/components/**`: component conformance fixes.
- `packages/liqkit_ui/lib/components.dart`: exports for any missing public symbols.
- `packages/liqkit_ui/test/components/**`: behavior, dimension, accessibility, and golden tests.
- `apps/docs_snippets/lib/snippets/**`: snippets that reflect the public API.
- `apps/docs/content/docs/**`: docs notes for native iOS controls and cross-platform extensions.

Modify in the showcase app:

- `pubspec.yaml`: add local path dependency on `liqkit_ui`.
- `lib/main.dart`: wrap app in `LiqApp` or `LiqTheme` and remove old theme imports.
- `lib/screens/**`: rebuild catalog and demo screens using `package:liqkit_ui/liqkit_ui.dart`.
- `lib/demos/**`: keep demo data/state, replace visual primitives with `liqkit_ui`.
- `test/**`: rewrite tests to assert library-backed showcase behavior.

Delete from the showcase app:

- `lib/components/**`
- `lib/core/effects/**`
- `lib/core/theme/**`
- `lib/core/widgets/liquid_container.dart`
- `lib/core/widgets/liquid_list_tile.dart`
- `lib/core/widgets/liquid_scaffold.dart`
- `lib/core/platform/*_components.dart`
- `lib/core/platform/*_gestures.dart` when they exist only to demo duplicated visual components

---

### Task 1: Add Audit Coverage Guard

**Files:**
- Create: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/tooling/scripts/check_component_audit.dart`
- Create: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/docs/audits/ios26_component_checklist.md`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/pubspec.yaml`

- [ ] **Step 1: Create the initial checklist file**

Write `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/docs/audits/ios26_component_checklist.md`:

```markdown
# iOS 26 Component Audit Checklist

Source of truth: `packages/liqkit_ui/lib/components.dart`

Status values:

- `Pass`: conforms today.
- `Fix`: needs code changes in `liqkit_ui`.
- `Extension`: not a native iOS primitive, kept for forui/shadcn parity and rendered in iOS 26 visual language.
- `Defer`: intentionally excluded from the migration with a written reason.

| Component | Category | Apple/Figma source | forui/shadcn parity source | iOS 26 visual status | Token usage status | Glass/material status | Motion status | Typography status | Accessibility status | Test/doc status | Showcase status | Action |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
```

- [ ] **Step 2: Create the audit checker**

Write `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/tooling/scripts/check_component_audit.dart`:

```dart
import 'dart:io';

void main() {
  final repo = Directory.current;
  final exportsFile = File('${repo.path}/packages/liqkit_ui/lib/components.dart');
  final checklistFile = File('${repo.path}/docs/audits/ios26_component_checklist.md');

  if (!exportsFile.existsSync()) {
    stderr.writeln('Missing ${exportsFile.path}');
    exit(1);
  }
  if (!checklistFile.existsSync()) {
    stderr.writeln('Missing ${checklistFile.path}');
    exit(1);
  }

  final exportLines = exportsFile
      .readAsLinesSync()
      .where((line) => line.trim().startsWith('export '))
      .toList();

  final exportedFiles = <String>[];
  for (final line in exportLines) {
    final match = RegExp("'([^']+)'").firstMatch(line);
    if (match != null) {
      exportedFiles.add(match.group(1)!);
    }
  }

  final classes = <String>{};
  for (final exported in exportedFiles) {
    final path = '${repo.path}/packages/liqkit_ui/lib/$exported';
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('Export points to missing file: $exported');
      exit(1);
    }
    final source = file.readAsStringSync();
    for (final match in RegExp(r'(?:final\s+)?class\s+(Liq[A-Za-z0-9]+)').allMatches(source)) {
      classes.add(match.group(1)!);
    }
  }

  final checklist = checklistFile.readAsStringSync();
  final missing = classes.where((name) => !checklist.contains('| $name |')).toList()..sort();
  final invalidStatuses = <String>[];
  final rows = checklist
      .split('\n')
      .where((line) => line.startsWith('| Liq'))
      .toList();

  for (final row in rows) {
    final cells = row.split('|').map((cell) => cell.trim()).toList();
    if (cells.length < 14) {
      invalidStatuses.add('Malformed row: $row');
      continue;
    }
    final statuses = <String>[cells[5], cells[6], cells[7], cells[8], cells[9], cells[10], cells[11], cells[12]];
    for (final status in statuses) {
      if (!status.startsWith('Pass') &&
          !status.startsWith('Fix') &&
          !status.startsWith('Extension') &&
          !status.startsWith('Defer')) {
        invalidStatuses.add('Invalid status "$status" in row: ${cells[1]}');
      }
    }
  }

  if (missing.isNotEmpty || invalidStatuses.isNotEmpty) {
    if (missing.isNotEmpty) {
      stderr.writeln('Checklist missing exported classes:');
      for (final name in missing) {
        stderr.writeln('- $name');
      }
    }
    if (invalidStatuses.isNotEmpty) {
      stderr.writeln('Checklist status problems:');
      for (final problem in invalidStatuses) {
        stderr.writeln('- $problem');
      }
    }
    exit(1);
  }

  stdout.writeln('Component audit covers ${classes.length} exported Liq classes.');
}
```

- [ ] **Step 3: Add the Melos script**

In `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/pubspec.yaml`, add this under `melos.scripts`:

```yaml
    audit:components:
      run: dart run tooling/scripts/check_component_audit.dart
      description: Verify docs/audits/ios26_component_checklist.md covers every exported Liq component.
```

- [ ] **Step 4: Run the guard and confirm it fails before rows are populated**

Run:

```bash
dart run tooling/scripts/check_component_audit.dart
```

Expected: failure listing exported `Liq*` classes missing from the checklist.

- [ ] **Step 5: Commit the guard**

Run:

```bash
git add pubspec.yaml tooling/scripts/check_component_audit.dart docs/audits/ios26_component_checklist.md
git commit -m "chore(audit): add component checklist guard"
```

---

### Task 2: Populate The Component Audit Checklist

**Files:**
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/docs/audits/ios26_component_checklist.md`

- [ ] **Step 1: Generate the exported class list**

Run:

```bash
dart run tooling/scripts/check_component_audit.dart 2>&1 | sed -n 's/^- //p' > /tmp/liqkit_exported_classes.txt
```

Expected: `/tmp/liqkit_exported_classes.txt` contains one exported `Liq*` class per line.

- [ ] **Step 2: Audit native Apple/Figma-backed components**

For components that map directly to `/Users/ahmedomar/Documents/delta/liqkit/apple_design_figma/liqkit/components/**`, add one row each. Use exact source paths such as:

```markdown
| LiqButton | Inputs | `apple_design_figma/liqkit/components/buttons/index.html`; `apple_design_figma/liqkit/components/buttons/text-button-small-red-light.svg` | forui `FButton`; shadcn `ShadButton` | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pending showcase migration | Confirm showcase imports `LiqButton`. |
```

Native-backed groups include:

```text
LiqActionSheet
LiqActivitySheet
LiqAlert
LiqAppIcon
LiqButton
LiqColorPickerButton
LiqColorDot
LiqColorGrid
LiqColorSwatch
LiqColorSwatchGrid
LiqContextMenu
LiqDatePicker
LiqDeviceBezel
LiqEmptyState
LiqFaceIdBezel
LiqGlassSurface
LiqHomeIndicator
LiqKeyboard
LiqListGroup
LiqListRow
LiqMaterialChip
LiqMenu
LiqMenuItem
LiqNotification
LiqPageControl
LiqPopover
LiqPopupButton
LiqProgressBar
LiqSegmentedControl
LiqSheet
LiqSidebar
LiqSlider
LiqSpinner
LiqStatusBar
LiqStepper
LiqSystemActionPill
LiqSystemToggleDot
LiqTextField
LiqTextarea
LiqTimePicker
LiqToggle
LiqToolbar
LiqTopBar
LiqWidgetCard
```

- [ ] **Step 3: Audit forui/shadcn parity extensions**

For components that are cross-platform parity controls rather than native iOS primitives, mark iOS status as `Extension` and name the parity source:

```markdown
| LiqBreadcrumb | Navigation | Native iOS uses stack navigation rather than breadcrumbs | forui `FBreadcrumb`; shadcn `ShadBreadcrumb` | Extension - iOS visual treatment | Pass | Pass | Pass | Pass | Pass | Pass | Pending showcase migration | Keep as parity extension. |
```

Extension groups include:

```text
LiqAccordion
LiqAvatar
LiqAvatarGroup
LiqBadge
LiqBarChart
LiqBottomNavBar
LiqBreadcrumb
LiqCalendar
LiqCard
LiqCarousel
LiqCheckbox
LiqChip
LiqChipGroup
LiqCollapsible
LiqCombobox
LiqCommandPalette
LiqDataTable
LiqDialog
LiqDivider
LiqDrawer
LiqHoverCard
LiqKanban
LiqLabel
LiqLineChart
LiqNumberField
LiqOtpInput
LiqPagination
LiqRadio
LiqRadioGroup
LiqResizable
LiqRichEditor
LiqScrollArea
LiqSkeleton
LiqSkeletonText
LiqTabs
LiqToast
LiqTooltip
LiqTreeView
LiqWindow
```

- [ ] **Step 4: Audit helper/data classes**

For exported helper classes that are not standalone widgets, add rows with `Pass` or `Fix` for API utility status:

```markdown
| LiqDialogAction | Containers | Used by `LiqDialog` | forui dialog actions; shadcn dialog footer actions | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pending showcase migration | Keep as public dialog action model. |
```

Helper groups include:

```text
LiqAccordionItem
LiqActivityHeader
LiqAlertAction
LiqAppIconBadge
LiqBottomNavItem
LiqComboboxOption
LiqCommand
LiqContextMenuPreview
LiqDataColumn
LiqDataRow
LiqDialogAction
LiqDrawerOverlay
LiqEmptyStateCta
LiqExamplesItem
LiqExamplesPanel
LiqExamplesSection
LiqFormField
LiqKanbanCard
LiqKanbanColumn
LiqKitHelpersHeader
LiqKitHelpersModeLabels
LiqKitHelpersModePill
LiqMaterialChipCell
LiqMenuSectionTitle
LiqMenuSeparator
LiqNotificationIcon
LiqNotificationIconColors
LiqRichEditorController
LiqRichRange
LiqRichValue
LiqSheetGrabber
LiqSheetTopButton
LiqSidebarRow
LiqSidebarSearch
LiqSidebarSectionHeader
LiqTabItem
LiqTime
LiqToastOverlay
LiqToolbarChip
LiqToolbarGlassButton
LiqTopBarAccentButton
LiqTopBarSymbolButton
LiqTreeNode
LiqTypeColumn
LiqWindowControls
LiqWindowGlassButton
LiqWindowToolbar
```

- [ ] **Step 5: Run the guard until it passes**

Run:

```bash
dart run tooling/scripts/check_component_audit.dart
```

Expected:

```text
Component audit covers 138 exported Liq classes.
```

- [ ] **Step 6: Commit the checklist**

Run:

```bash
git add docs/audits/ios26_component_checklist.md
git commit -m "docs(audit): inventory ios26 component conformance"
```

---

### Task 3: Fix Library-Wide Primitive Drift

**Files:**
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/packages/liqkit_ui/lib/src/components/**`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/packages/liqkit_ui/test/components/**`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/docs/audits/ios26_component_checklist.md`

- [ ] **Step 1: Find hard-coded animation drift**

Run:

```bash
rg -n "Duration\\(|Curves\\." packages/liqkit_ui/lib/src/components
```

Expected: only intentional component-local findings remain after remediation.

- [ ] **Step 2: Replace component-local motion constants with `LiqMotion`**

For each non-exception finding, import:

```dart
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
```

Replace local constants like:

```dart
static const Duration _duration = Duration(milliseconds: 250);
static const Curve _curve = Curves.easeOutCubic;
```

with:

```dart
static const Duration _duration = LiqMotion.normal;
static const Curve _curve = LiqMotion.standard;
```

- [ ] **Step 3: Find glass-bearing components not using `LiqGlassSurface`**

Run:

```bash
rg -n "BackdropFilter|ImageFilter\\.blur|glass|Glass|blur" packages/liqkit_ui/lib/src/components
```

Expected: glass-bearing panels either use `LiqGlassSurface` or have a checklist action explaining the exception.

- [ ] **Step 4: Route glass-bearing panels through `LiqGlassSurface`**

For each simple panel, import:

```dart
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
```

Replace custom panel decorations like:

```dart
DecoratedBox(
  decoration: BoxDecoration(
    color: const Color(0xCCFAFAFA),
    borderRadius: BorderRadius.circular(20),
  ),
  child: child,
)
```

with:

```dart
LiqGlassSurface(
  borderRadius: const BorderRadius.all(Radius.circular(20)),
  tint: LiqGlassTint.light,
  elevation: LiqGlassElevation.floating,
  child: child,
)
```

- [ ] **Step 5: Update checklist rows for primitive fixes**

For each fixed component, change `Fix` to `Pass` in the affected status cells and write the exact fix in the Action column:

```markdown
| LiqDrawer | Containers | ... | ... | Pass | Pass | Pass - routed through `LiqGlassSurface` | Pass - uses `LiqMotion.slow` | Pass | Pass | Pass | Pending showcase migration | Primitive drift fixed in `packages/liqkit_ui/lib/src/components/drawers/liq_drawer.dart`. |
```

- [ ] **Step 6: Run focused tests**

Run:

```bash
melos run fmt
melos run analyze:flutter
melos run test
```

Expected: all commands pass.

- [ ] **Step 7: Commit primitive fixes**

Run:

```bash
git add packages/liqkit_ui/lib/src/components packages/liqkit_ui/test/components docs/audits/ios26_component_checklist.md
git commit -m "refactor(ui): align components with ios26 primitives"
```

---

### Task 4: Add Showcase Migration Guard

**Files:**
- Create: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/tooling/scripts/check_showcase_migration.dart`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/pubspec.yaml`

- [ ] **Step 1: Create the migration checker**

Write `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/tooling/scripts/check_showcase_migration.dart`:

```dart
import 'dart:io';

void main(List<String> args) {
  final showcasePath = args.isNotEmpty
      ? args.first
      : '/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit';
  final showcase = Directory(showcasePath);
  if (!showcase.existsSync()) {
    stderr.writeln('Showcase directory does not exist: $showcasePath');
    exit(1);
  }

  final forbiddenDirs = <String>[
    'lib/components',
    'lib/core/effects',
    'lib/core/theme',
  ];

  final problems = <String>[];
  for (final relative in forbiddenDirs) {
    final dir = Directory('${showcase.path}/$relative');
    if (dir.existsSync()) {
      final dartFiles = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList();
      if (dartFiles.isNotEmpty) {
        problems.add('Forbidden design-system directory still has Dart files: $relative');
      }
    }
  }

  final dartFiles = showcase
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.contains('/.dart_tool/'))
      .where((file) => !file.path.contains('/build/'))
      .toList();

  for (final file in dartFiles) {
    final source = file.readAsStringSync();
    final relative = file.path.substring(showcase.path.length + 1);
    if (RegExp(r'class\s+Liquid[A-Za-z0-9_]+').hasMatch(source)) {
      problems.add('$relative declares a Liquid* class');
    }
    if (source.contains("import '../components/") ||
        source.contains("import '../../components/") ||
        source.contains("import '../../../components/") ||
        source.contains("import 'components/") ||
        source.contains("import '../core/theme/") ||
        source.contains("import '../../core/theme/") ||
        source.contains("import '../../../core/theme/") ||
        source.contains("import '../core/effects/") ||
        source.contains("import '../../core/effects/") ||
        source.contains("import '../../../core/effects/")) {
      problems.add('$relative imports old showcase design-system code');
    }
  }

  final pubspec = File('${showcase.path}/pubspec.yaml').readAsStringSync();
  if (!pubspec.contains('liqkit_ui:')) {
    problems.add('pubspec.yaml does not declare liqkit_ui dependency');
  }

  if (problems.isNotEmpty) {
    stderr.writeln('Showcase migration guard failed:');
    for (final problem in problems) {
      stderr.writeln('- $problem');
    }
    exit(1);
  }

  stdout.writeln('Showcase migration guard passed for $showcasePath');
}
```

- [ ] **Step 2: Add the Melos script**

In `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/pubspec.yaml`, add this under `melos.scripts`:

```yaml
    audit:showcase:
      run: dart run tooling/scripts/check_showcase_migration.dart
      description: Verify the App Store showcase consumes liqkit_ui instead of duplicated Liquid* components.
```

- [ ] **Step 3: Run the guard and confirm it fails before migration**

Run:

```bash
dart run tooling/scripts/check_showcase_migration.dart
```

Expected: failure listing old showcase `lib/components/**`, `lib/core/theme/**`, and `Liquid*` classes.

- [ ] **Step 4: Commit the guard**

Run:

```bash
git add pubspec.yaml tooling/scripts/check_showcase_migration.dart
git commit -m "chore(audit): add showcase migration guard"
```

---

### Task 5: Wire Showcase To Local `liqkit_ui`

**Files:**
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/pubspec.yaml`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/main.dart`

- [ ] **Step 1: Add local path dependencies**

In showcase `pubspec.yaml`, add:

```yaml
  liqkit_ui:
    path: ../../../flutter_components/liqkit_ui/packages/liqkit_ui
  liqkit_ui_assets:
    path: ../../../flutter_components/liqkit_ui/packages/liqkit_ui_assets
  liqkit_ui_tokens:
    path: ../../../flutter_components/liqkit_ui/packages/liqkit_ui_tokens
```

- [ ] **Step 2: Remove duplicated theme imports from `main.dart`**

Replace imports like:

```dart
import 'core/theme/liquid_theme.dart';
```

with:

```dart
import 'package:liqkit_ui/liqkit_ui.dart';
```

- [ ] **Step 3: Wrap the app in library theme**

Use this shape in `main.dart`:

```dart
class LiquidUIKitApp extends ConsumerWidget {
  const LiquidUIKitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqApp(
      title: 'Liquid UI Kit',
      home: const HomeScreen(),
    );
  }
}
```

If the existing app needs localization delegates or routes, keep those app-owned values and place them on the `LiqApp` constructor when supported. If `LiqApp` is missing a needed `WidgetsApp`/`MaterialApp` parameter, add that parameter to `liqkit_ui` rather than reintroducing the old showcase theme.

- [ ] **Step 4: Fetch dependencies**

Run from the showcase root:

```bash
flutter pub get
```

Expected: dependency resolution succeeds and includes local `liqkit_ui`.

- [ ] **Step 5: Commit dependency wiring**

Run from the `liqkit_ui` repo root:

```bash
git add ../../showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/pubspec.yaml ../../showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/main.dart
git commit -m "refactor(showcase): depend on local liqkit_ui"
```

If Git cannot commit files outside the repo, commit the showcase change in the showcase repository if it is a repo; otherwise leave it as an uncommitted workspace change and record that in the final handoff.

---

### Task 6: Rebuild Showcase Catalog Screens

**Files:**
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/screens/component_catalog_screen.dart`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/screens/showcase_screen.dart`
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/screens/demos/**`

- [ ] **Step 1: Replace old imports**

For each catalog/demo screen, replace old design-system imports:

```dart
import '../../components/buttons/liquid_button.dart';
import '../../core/widgets/liquid_scaffold.dart';
import '../../core/theme/typography.dart';
```

with:

```dart
import 'package:liqkit_ui/liqkit_ui.dart';
```

- [ ] **Step 2: Replace old component names with `Liq*` names**

Use this mapping:

```text
LiquidButton -> LiqButton
LiquidTextField -> LiqTextField
LiquidSwitch -> LiqToggle
LiquidSegmentedControl -> LiqSegmentedControl
LiquidSlider -> LiqSlider
LiquidStepper -> LiqStepper
LiquidActionSheet -> LiqActionSheet
LiquidBottomSheet -> LiqSheet
LiquidAlertDialog -> LiqAlert or LiqDialog
LiquidPopover -> LiqPopover
LiquidContextMenu -> LiqContextMenu
LiquidMenu -> LiqMenu
LiquidPopupButton -> LiqPopupButton
LiquidPageControl -> LiqPageControl
LiquidProgressBar -> LiqProgressBar
LiquidActivityIndicator -> LiqSpinner
LiquidActivityView -> LiqActivitySheet
LiquidListTile -> LiqListRow
LiquidListView -> LiqListGroup
LiquidMaterial -> LiqMaterialChip or LiqGlassSurface
LiquidNotification -> LiqNotification
LiquidDatePicker -> LiqDatePicker
LiquidColorPicker -> LiqColorGrid / LiqColorPickerButton
LiquidKeyboard -> LiqKeyboard
LiquidDeviceBezel -> LiqDeviceBezel
LiquidStatusBar -> LiqStatusBar
LiquidToolbar -> LiqToolbar
LiquidSidebar -> LiqSidebar
LiquidFaceId -> LiqFaceIdBezel
LiquidAppIcon -> LiqAppIcon
LiquidEmptyState -> LiqEmptyState
LiquidWidget -> LiqWidgetCard
```

- [ ] **Step 3: Use library primitives for layout chrome**

Replace old `LiquidScaffold` and `LiquidContainer` usage with normal Flutter layout plus `LiqGlassSurface`, `LiqCard`, `LiqTopBar`, `LiqBottomNavBar`, and `LiqListGroup` as needed:

```dart
return Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        const LiqTopBar(title: 'Buttons'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              LiqButton(label: 'Regular'),
            ],
          ),
        ),
      ],
    ),
  ),
);
```

- [ ] **Step 4: Preserve app-owned demo state**

Keep Riverpod providers and model objects where they represent demo data. Replace only visual primitives:

```dart
LiqCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(product.name),
      LiqButton(
        label: 'Add to cart',
        onPressed: () => ref.read(cartProvider.notifier).add(product),
      ),
    ],
  ),
)
```

- [ ] **Step 5: Run analyze frequently**

Run from the showcase root:

```bash
flutter analyze
```

Expected: errors decrease as each screen is migrated.

---

### Task 7: Delete Old Showcase Design-System Code

**Files:**
- Delete: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/components/**`
- Delete: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/core/effects/**`
- Delete: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/core/theme/**`
- Delete: selected `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/core/widgets/**`
- Delete: selected `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/lib/core/platform/**`

- [ ] **Step 1: Confirm no migrated file imports old code**

Run from the showcase root:

```bash
rg -n "components/|core/theme|core/effects|Liquid[A-Za-z0-9_]+" lib test
```

Expected: only app name strings such as `LiquidUIKitApp` remain.

- [ ] **Step 2: Delete duplicated component folders**

Use `rm -rf` only after Step 1 passes for imports:

```bash
rm -rf lib/components lib/core/effects lib/core/theme
rm -f lib/core/widgets/liquid_container.dart lib/core/widgets/liquid_list_tile.dart lib/core/widgets/liquid_scaffold.dart
rm -f lib/core/platform/android_components.dart lib/core/platform/ios_components.dart lib/core/platform/macos_components.dart lib/core/platform/web_components.dart lib/core/platform/windows_components.dart
rm -f lib/core/platform/android_gestures.dart lib/core/platform/ios_gestures.dart lib/core/platform/macos_gestures.dart lib/core/platform/web_gestures.dart lib/core/platform/windows_gestures.dart
```

- [ ] **Step 3: Run the migration guard**

Run from the `liqkit_ui` repo root:

```bash
dart run tooling/scripts/check_showcase_migration.dart
```

Expected:

```text
Showcase migration guard passed for /Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit
```

- [ ] **Step 4: Commit deletion**

Commit in the repository that owns the showcase files. If the showcase has no `.git`, leave the deletion as workspace changes and record that in final handoff.

---

### Task 8: Rebuild Showcase Tests

**Files:**
- Modify: `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit/test/**`

- [ ] **Step 1: Replace old component test imports**

Replace:

```dart
import 'package:flutter_liquid_ui_kit/components/buttons/liquid_button.dart';
```

with:

```dart
import 'package:liqkit_ui/liqkit_ui.dart';
```

- [ ] **Step 2: Delete tests for deleted showcase primitives**

Delete tests whose only purpose is validating removed implementation code:

```text
test/core/theme/liquid_theme_test.dart
test/core/widgets/liquid_container_test.dart
test/core/widgets/liquid_scaffold_test.dart
```

- [ ] **Step 3: Keep app-level tests**

Rewrite accessibility and integration tests to pump showcase screens and find `Liq*` widgets:

```dart
testWidgets('catalog renders library button examples', (tester) async {
  await tester.pumpWidget(const LiquidUIKitApp());
  expect(find.byType(LiqButton), findsWidgets);
});
```

- [ ] **Step 4: Run tests**

Run from showcase root:

```bash
flutter test
```

Expected: all app-level tests pass.

---

### Task 9: Full Verification

**Files:**
- Modify only files needed to fix verification failures.

- [ ] **Step 1: Run library verification**

Run from `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui`:

```bash
melos run fmt
melos run analyze
melos run analyze:flutter
melos run test
melos run audit:components
melos run audit:showcase
```

Expected: all commands pass.

- [ ] **Step 2: Run showcase verification**

Run from `/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build ios --debug --no-codesign
```

Expected: all commands pass.

- [ ] **Step 3: Final checklist update**

In `/Users/ahmedomar/Documents/delta/liqkit/flutter_components/liqkit_ui/docs/audits/ios26_component_checklist.md`, set every Showcase status to one of:

```text
Pass - showcased
Extension - showcased as parity component
Defer - not showcased; reason: platform-only helper used by another showcased component
```

- [ ] **Step 4: Commit final state**

Run from the owning repository roots:

```bash
git status --short
git add .
git commit -m "refactor(showcase): rebuild on liqkit_ui"
```

If files span multiple repositories, make one commit per repository and include both commit hashes in the final handoff.

---

## Self-Review

Spec coverage:

- Component audit checklist: Tasks 1 and 2.
- Library remediation before showcase rebuild: Task 3.
- Showcase depends on `liqkit_ui` and deletes old code: Tasks 5, 6, and 7.
- Tests and static migration guards: Tasks 1, 4, 8, and 9.
- Full verification: Task 9.

Placeholder scan:

- No placeholder markers or unspecified implementation steps remain.

Type consistency:

- Guard scripts use `Liq*` and `Liquid*` naming consistently.
- Showcase imports target `package:liqkit_ui/liqkit_ui.dart`.
- Verification commands match existing Melos scripts plus the new audit scripts.
