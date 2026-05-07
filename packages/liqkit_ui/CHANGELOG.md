# Changelog

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
