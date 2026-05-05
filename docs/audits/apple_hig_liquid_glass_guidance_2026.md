# Apple HIG + Liquid Glass Guidance Audit, 2026

Purpose: make `liqkit_ui` feel native to Apple platform design by translating current Apple guidance into concrete checks for Flutter components, docs snippets, and showcase behavior.

Primary sources:

- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- Liquid Glass overview: https://developer.apple.com/documentation/TechnologyOverviews/liquid-glass
- Adopting Liquid Glass: https://developer.apple.com/documentation/TechnologyOverviews/adopting-liquid-glass
- Materials: https://developer.apple.com/design/human-interface-guidelines/materials
- Color: https://developer.apple.com/design/human-interface-guidelines/color
- Motion: https://developer.apple.com/design/human-interface-guidelines/motion
- Accessibility: https://developer.apple.com/design/human-interface-guidelines/accessibility
- Buttons: https://developer.apple.com/design/human-interface-guidelines/buttons
- Sliders: https://developer.apple.com/design/human-interface-guidelines/sliders
- Steppers: https://developer.apple.com/design/human-interface-guidelines/steppers
- Segmented controls: https://developer.apple.com/design/human-interface-guidelines/segmented-controls
- Text fields: https://developer.apple.com/design/human-interface-guidelines/text-fields
- Pickers: https://developer.apple.com/design/human-interface-guidelines/pickers
- Tab bars: https://developer.apple.com/design/human-interface-guidelines/tab-bars
- Sidebars: https://developer.apple.com/design/human-interface-guidelines/sidebars
- Toolbars: https://developer.apple.com/design/human-interface-guidelines/toolbars
- Menus: https://developer.apple.com/design/human-interface-guidelines/menus
- Context menus: https://developer.apple.com/design/human-interface-guidelines/context-menus
- Popovers: https://developer.apple.com/design/human-interface-guidelines/popovers
- Sheets: https://developer.apple.com/design/human-interface-guidelines/sheets
- Search fields: https://developer.apple.com/design/human-interface-guidelines/search-fields
- Layout: https://developer.apple.com/design/human-interface-guidelines/layout

## Global Design Contract

These rules apply across every `Liq*` component.

| Area | Requirement | Component implications |
|---|---|---|
| Layering | Liquid Glass is a functional layer for controls and navigation, floating above content. It should not be used as generic content decoration. | Reserve `LiqGlassSurface` for bars, controls, popovers, sheets, menus, navigation, and transient interaction states. Cards, lists, charts, and content surfaces should use standard system/background materials. |
| Material variants | Regular glass preserves legibility; clear glass belongs over visually rich media and may need dimming. | Add/keep explicit material intent: `regular`, `clear`, `prominent`, `content`, plus reduced-transparency fallbacks. Avoid invisible clear glass on plain white/black demo backgrounds. |
| Color | Use semantic system colors, light/dark variants, increased-contrast variants, and sparse accent color. | Eliminate hard-coded display colors from components where tokens exist. Accent backgrounds should be rare and mainly for primary/prominent actions or status. |
| Motion | Motion should be purposeful, brief, precise, cancellable, gesture-following, and respect reduced motion. | Shared press, hover, drag, selection, popover, sheet, and glass morph animations need a single duration/easing policy and reduced-motion switch. |
| Input feedback | Custom controls must show press/hover/focus/disabled states. Pointer devices on iPad and web must get correct cursors. | Every tappable/clickable widget needs `MouseRegion` or a shared pointer wrapper, semantic button state, and visible feedback. |
| Concentric geometry | Controls, sheets, popovers, windows, and nested surfaces should use rounded forms that feel concentric with their containers. | Centralize radius tokens by control size and container type; avoid arbitrary radii. Child radii should be smaller and visually concentric. |
| Layout | Support arbitrary widths and heights; use safe areas; avoid clipped content; prefer adaptive layouts over fixed demo boxes. | Docs snippets need responsive preview heights. Components need intrinsic sizing, min/max constraints, and overflow strategies. |
| Accessibility | Support large text, contrast, reduce transparency, reduce motion, semantics, keyboard focus, and non-color status cues. | Add semantic labels/states to interactive controls, preserve text selection in text inputs, and test large text layouts. |
| Documentation truth | Code shown in docs must compile and must be the exact code used to render the snippet. | Keep snippet JSON generated from `apps/docs_snippets`; never hand-write snippet code in docs. |

## Component-Specific Checks

### Controls

- `LiqButton`: minimum 44x44 pt hit area, clear press state, role-aware styling, one or two prominent actions per view, activity/loading state support, no same-color label/background conflicts.
- `LiqSlider`: leading-to-trailing min/max, live value feedback, optional icons/value field pairing, thumb transforms/presses into a glass-like interaction state, smooth drag and pointer cursor.
- `LiqStepper`: value must be obvious near the stepper because the native stepper does not display the value itself; pair with text/value label in demos; press feedback on both segments.
- `LiqSegmentedControl` and `LiqToggleGroup`: closely related choices only, consistent segment type, equal segment widths where possible, five segments max on iPhone-like widths, animated selection pill, drag-across selection during press.
- `LiqToggle` and `LiqCheckbox`: use for binary/opposing state; preserve hierarchy semantics for checkbox groups; animate thumb/knob and state transitions; do not rely on color alone.
- `LiqTextField`, `LiqTextarea`, `LiqRichEditor`, `LiqCombobox`: correct placeholder/label behavior, clear button support where appropriate, pointer/keyboard focus, expected text selection on web/iPad pointer, logical tab order, responsive width.
- `LiqDatePicker`, `LiqTimePicker`, `LiqDatePickerField`, `LiqTimeField`, `LiqPopupButton`, `LiqColorPicker`: picker surfaces appear near the edited field, are responsive, use native-feeling wheels/grids/sheets, and maintain smooth drag/scroll physics.

### Navigation

- `LiqTopBar`, `LiqToolbar`: group related actions; maximum about three groups; symbols preferred for common toolbar actions; text and icon buttons should not be mixed in the same grouped background; primary action belongs trailing and visually distinct.
- `LiqBottomNavBar`, `LiqTabs`: navigation only, not actions; labels should be short; badge only for critical information; search tab/action should be distinct and trailing where applicable.
- `LiqSidebar`, `LiqTreeView`: float above/extend content beneath where used as navigation; support collapse/hide patterns; no more than two visible hierarchy levels in sidebar-like layouts; use title-style capitalization.
- `LiqBreadcrumb`: single-line horizontal breadcrumb by default; separators inline; truncate or scroll horizontally rather than wrapping each crumb onto separate lines.

### Menus, Popovers, Sheets

- `LiqMenu`, `LiqContextMenu`: adopt glass, use icons for common actions, no decorative icons, destructive actions last and visually destructive, top context actions should match swipe actions where both exist.
- `LiqPopover`, `LiqHoverCard`, `LiqTooltip`: transient, small scope, positioned relative to source, responsive within viewport, never clipped by demo frames, use regular glass for text-heavy content.
- `LiqSheet`, `LiqActionSheet`, `LiqDialog`, `LiqAlert`: rounder corners, inset half-sheet behavior, source/anchor for action sheets, brief content, predictable Done/Cancel positions, no custom background effects that fight glass.

### Organization And Content

- `LiqList`, `LiqDataTable`, `LiqCard`, `LiqEmptyState`, charts, badges, skeletons: use standard/content materials rather than Liquid Glass unless acting as controls; larger row height/padding for list-like structures; title-style section headers.
- `LiqNotification`, `LiqToast`, `LiqBadge`: legible on both light and dark contexts, use status colors plus glyph/text, avoid clear glass on empty/plain backgrounds.
- `LiqAppIcon`: layered, optically balanced, centered, compatible with light/dark/clear/tinted variants, and lets the system effect model do blur/masking/reflection instead of baking effects into artwork.

## Priority Implementation Sequence

1. Shared foundations: semantic color resolver, material intent, motion policy, pointer wrapper, contrast/reduced-motion/reduced-transparency switches.
2. Core inputs: button, text field, slider, stepper, segmented/toggle group, toggle, checkbox.
3. Picker family: date/time/color/popup/combobox.
4. Navigation and command surfaces: toolbar, top bar, bottom nav, tabs, sidebar, menu, context menu.
5. Modals and transient surfaces: sheets, action sheets, popovers, hover cards, tooltips, notifications, toasts.
6. Content and layout extensions: list, data table, cards, charts, carousel, kanban, breadcrumb, tree view.
7. Docs/showcase truth pass: ensure all snippets compile, previews are responsive, and every demo proves interaction states.

## Verification Gates

- `flutter analyze packages/liqkit_ui apps/docs_snippets`
- `flutter test packages/liqkit_ui/test`
- `dart run tooling/gen/snippet_generator/main.dart --check`
- `dart run tooling/gen/gen_snippet_routes.dart --check`
- `flutter build web --wasm --release --no-web-resources-cdn --pwa-strategy=none --base-href=/` in `apps/docs_snippets`
- `npx pnpm@10 typecheck` in `apps/docs`
- Browser QA in light/dark, pointer hover, press/drag, narrow/mobile width, large text, reduced motion, reduced transparency, and high contrast where Flutter exposes the setting.
