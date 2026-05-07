# Changelog

## 0.3.0

Final batch of primitives so consumers can build a full iOS 26 app
without ever importing `package:flutter/material.dart` — and the
library itself no longer imports it either.

### Internal: package is now Material-free

Replaced every internal `Icons.X` literal in liqkit_ui with the
matching `LucideIcons.X` glyph from `lucide_icons_flutter` (added
as a direct dep). Affects 11 files: `liq_calendar`, `liq_chip`,
`liq_collapsible`, `liq_combobox`, `liq_command_palette`,
`liq_date_picker_field`, `liq_number_field`, `liq_pagination`,
`liq_rich_editor`, `liq_toast`, `liq_tree_view`. Pure visual swap;
no API change. Glyphs map closely (Material `chevron_right` →
Lucide `chevronRight`, `check_circle_outline` → `circleCheck`,
`format_bold` → `bold`, etc.).

Net effect: a consumer who imports only `package:liqkit_ui` and
`package:liqkit_ui_icons` no longer transitively pulls Material
into their bundle (the ~1.6 MB `MaterialIcons-Regular.otf` font is
no longer referenced and is fully tree-shaken away — previously
8.8 KB still leaked through). The new `LiqTimerPickerMode`
typedef in `liq_picker_extras.dart` lets callers pass timer modes
without a `package:flutter/cupertino.dart` import either.

### New components

- `LiqSliverAppBar` + `LiqFlexibleSpaceBar` — iOS 26 collapsing
  app-bar pattern (hero image expanded, glass title bar pinned).
  Drop-in replacement for Material's `SliverAppBar` /
  `FlexibleSpaceBar` for any `CustomScrollView` flow that wants the
  hero-collapse UX. Built on `SliverPersistentHeader` (pure
  `package:flutter/widgets.dart`, no Material dependency).
- `LiqDatePickerModal.show()` — modal date-picker route.
  Drop-in replacement for Material's `showDatePicker`. Returns a
  `Future<DateTime?>` that resolves to the chosen date or null on
  dismiss. Internally uses `LiqCalendar` inside a `LiqAlert` with
  Cancel + Done actions.
- `LiqForm` + `LiqValidatedField<T>` — form-state container with
  `validate()` / `reset()` / `save()` propagation to all
  `LiqValidatedField` descendants. Drop-in replacement for
  Material's `Form` + `TextFormField` for the typical
  "submit button calls `_formKey.currentState?.validate()`" pattern.
  No `Form` dependency in consumer code.

The remaining Material symbols an iOS-26 app might still touch
are limited to `BorderSide` (already exported by
`package:flutter/painting.dart` → `package:flutter/widgets.dart`,
so no Material import is actually needed) and
`GlobalMaterialLocalizations` (only when the app needs Material's
i18n delegates — replace with `GlobalCupertinoLocalizations` for
iOS-only apps).

## 0.2.0

Adds the missing primitives the showcase needed so an iOS 26 app can
build entirely against `package:liqkit_ui` + `package:liqkit_ui_icons`,
with no `package:flutter/material.dart` import in consumer code.

### New foundation

- `LiqColors` — Material-style color palette mapped to iOS 26 system
  tones. Drop-in replacement for `Colors.X` (white/black/transparent
  greyscale + the named iOS system tones + a `greyRamp.shade(N)`
  accessor). Lives in `package:liqkit_ui` (foundation export).

### New components

- `LiqDismissible` — swipe-to-dismiss row, alias for `Dismissible`
  from `package:flutter/widgets.dart` (no Material dependency).
- `LiqPageRoute` — iOS-style push route (subclass of
  `CupertinoPageRoute`). Drop-in replacement for `MaterialPageRoute`.
- `LiqReorderableList` — drag-to-reorder vertical list backed by
  `SliverReorderableList`. Replaces `ReorderableListView`.
- `LiqRefreshIndicator` — pull-to-refresh wrapper rendering a
  `LiqSpinner` instead of Material's circular progress glyph.

### Companion package

- `liqkit_ui_icons` 0.2.0 adds `LiqMaterialIcons` — 315 verbose-name
  aliases (`LiqMaterialIcons.accountCircle`, `errorOutline`, …) for
  drop-in migration off `Icons.X`. The curated short-name surface on
  `LiqIcons` is unchanged.

## 0.1.0

First real release. Comprehensive iOS 26 Liquid Glass design system.

### Flagship — real-refraction liquid glass shader

- New `liq_liquid_glass.frag` fragment shader. Per-pixel pipeline:
  signed-distance rounded-rect → height-field (edge bulge) → analytic
  surface normal → Snell refraction → 17-tap rosette frosted blur →
  adaptive vibrancy tint → Schlick Fresnel rim → optional Blinn-Phong
  specular and chromatic dispersion. Premultiplied alpha output.
- New widget `LiqLiquidGlass` — opt-in premium glass surface using the
  shader via `BackdropFilter(filter: ImageFilter.shader(...))` on
  Impeller. Falls back gracefully to `BackdropFilter(blur)` + tint
  overlay on Flutter web (CanvasKit doesn't yet support
  `ImageFilter.shader`).
- `LiqGlassSurface` (the foundation primitive every `Liq*` component
  uses) **now delegates internally to the new shader on Impeller**.
  Every existing component — `LiqCard`, `LiqAppBar`, `LiqSheet`,
  `LiqMenu`, `LiqDialog`, `LiqPopover`, `LiqDrawer`, `LiqTooltip`,
  `LiqNotification` — automatically inherits real refraction with no
  call-site changes.

### `LiqScaffold` safe-area fix

- Body content now respects the top safe-area inset whether or not an
  app bar is provided.

### New components (24+ added across this release cycle)

- **Steppers**: `LiqVerticalStepper`, `LiqHorizontalStepper`,
  `LiqOnboardingStepper`, `LiqProgressStepper`, `LiqNumericStepper`,
  `LiqStep` data class.
- **Menu**: `LiqMenuBar` + `LiqMenuBarItem` (macOS-style top strip).
- **Activity**: `LiqShareSheet` + `LiqShareActivity`,
  `LiqActivityIndicatorView`.
- **Auth**: `LiqFaceIdView`, `LiqTouchIdSensor`. New `LiqFaceIdState.idle`.
- **Bezels**: `LiqDeviceShowcase` + `LiqDeviceType` (12 device presets) +
  `LiqDeviceSpec`.
- **Pickers**: `LiqPickerButton`, `LiqNumberPicker`,
  `LiqMeasurementPicker`, `LiqDateRangePicker`, `LiqTimerPicker`,
  `LiqMultiColumnPicker`.
- **System**: `LiqSystemAlert`, `LiqSystemOverlay`,
  `LiqControlCenter`, `LiqControlCenterTile`, `LiqQuickActionsRow`,
  `LiqIconBar` family.
- **Keyboard**: `LiqLayoutKeyboard` with 7 layouts (alphabetic, numeric,
  decimal, phone, email, url, emoji), `LiqKeyboardSuggestionBar`.
- **Animations**: `LiqFlowAnimation`, `LiqMorphTransition`, `LiqRipple`,
  `LiqBounce`, `LiqPulse`, `LiqShimmer`, `LiqSwipeDetector`,
  `LiqPinchDetector`, `LiqLongPress`.
- **macOS chrome**: `LiqWindow`, `LiqWindowToolbar`, `LiqWindowControls`,
  `LiqWindowGlassButton`.

### Component extensions

- `LiqAlert.showMessage` / `showError` / `showConfirmation` static
  helpers; new `content` slot for embedding arbitrary widgets;
  `LiqAlertAction.icon` param.
- New `LiqTextInputDialog` (alert + LiqTextField + validator).
- `LiqMaterialChip` — 10 new `LiqMaterialStyle` values + new
  `LiqMaterialConfig` for custom blur/opacity/tint/saturation/vibrancy.
- `LiqEmptyState` — new typed presets (`noData`, `error`, `noConnection`,
  `noResults`), `LiqCompactEmptyState`, `LiqIllustratedEmptyState`,
  `LiqLoadingState`.

### Foundation

- `LiqAppleColors` — full UI palette (uiBackground, uiCyanLight, uiPurple,
  etc.); `LiqApplePalette` brightness-bound view.
- `LiqAppleTextStyles` — secondary/tertiary/quaternary modifiers.
- `LiqAppleColorsContext` / `LiqAppleTypographyContext` extensions on
  `BuildContext` (`context.appleColors.X`, `context.textStyles.body`).
- `LiqColorUtils` — fromHex/toHex/lighten/darken/contrastingColor/mix.

### Tests

603 / 603 widget + foundation tests pass.

## 0.0.1

- Placeholder publish to reserve the name on pub.dev.
