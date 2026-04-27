// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: hand-curated for the bootstrap iteration; the long-term plan
// is `tooling/gen/gen_examples_routes.dart` (later batch plan) reading
// per-category YAML examples.

import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Map from route path to widget builder.
const Map<String, WidgetBuilder> showcaseRoutes = <String, WidgetBuilder>{
  '/': _buildHome,
  '/colors/swatch-grid': _buildColorsSwatchGrid,
  '/colors/swatch-grid/increased-contrast':
      _buildColorsSwatchGridIncreasedContrast,
  '/buttons/catalog': _buildButtonsCatalog,
  '/toggles/catalog': _buildTogglesCatalog,
  '/sliders/catalog': _buildSlidersCatalog,
  '/steppers/catalog': _buildSteppersCatalog,
  '/segmented-controls/catalog': _buildSegmentedCatalog,
  '/page-controls/catalog': _buildPageControlsCatalog,
  '/progress/catalog': _buildProgressCatalog,
  '/text-fields/catalog': _buildTextFieldsCatalog,
  '/lists/catalog': _buildListsCatalog,
  '/top-bars/catalog': _buildTopBarsCatalog,
  '/toolbars/catalog': _buildToolbarsCatalog,
  '/sheets/catalog': _buildSheetsCatalog,
  '/alerts/catalog': _buildAlertsCatalog,
  '/action-sheets/catalog': _buildActionSheetsCatalog,
  '/notifications/catalog': _buildNotificationsCatalog,
  '/popovers/catalog': _buildPopoversCatalog,
  '/menu/catalog': _buildMenuCatalog,
  '/context-menu/catalog': _buildContextMenuCatalog,
  '/popup-buttons/catalog': _buildPopupButtonsCatalog,
  '/status-bars/catalog': _buildStatusBarsCatalog,
  '/sidebars/catalog': _buildSidebarsCatalog,
  '/empty-states/catalog': _buildEmptyStatesCatalog,
  '/pickers/catalog': _buildPickersCatalog,
  '/color-pickers/catalog': _buildColorPickersCatalog,
  '/app-icons/catalog': _buildAppIconsCatalog,
  '/widgets/catalog': _buildWidgetsCatalog,
  '/activity-views/catalog': _buildActivityViewsCatalog,
  '/face-id/catalog': _buildFaceIdCatalog,
  '/bezels/catalog': _buildBezelsCatalog,
  '/keyboards/catalog': _buildKeyboardsCatalog,
};

Widget _buildTogglesCatalog(BuildContext context) => const _TogglesRoute();

Widget _buildSlidersCatalog(BuildContext context) => const _SlidersRoute();

Widget _buildSteppersCatalog(BuildContext context) => const _SteppersRoute();

Widget _buildSegmentedCatalog(BuildContext context) => const _SegmentedRoute();

Widget _buildPageControlsCatalog(BuildContext context) =>
    const _PageControlsRoute();

Widget _buildProgressCatalog(BuildContext context) => const _ProgressRoute();

Widget _buildTextFieldsCatalog(BuildContext context) =>
    const _TextFieldsRoute();

Widget _buildListsCatalog(BuildContext context) => const _ListsRoute();

Widget _buildTopBarsCatalog(BuildContext context) => const _TopBarsRoute();

Widget _buildToolbarsCatalog(BuildContext context) => const _ToolbarsRoute();

Widget _buildSheetsCatalog(BuildContext context) => const _SheetsRoute();

Widget _buildAlertsCatalog(BuildContext context) => const _AlertsRoute();

Widget _buildActionSheetsCatalog(BuildContext context) =>
    const _ActionSheetsRoute();

Widget _buildNotificationsCatalog(BuildContext context) =>
    const _NotificationsRoute();

Widget _buildPopoversCatalog(BuildContext context) => const _PopoversRoute();

Widget _buildMenuCatalog(BuildContext context) => const _MenuRoute();

Widget _buildContextMenuCatalog(BuildContext context) =>
    const _ContextMenuRoute();

Widget _buildPopupButtonsCatalog(BuildContext context) =>
    const _PopupButtonsRoute();

Widget _buildStatusBarsCatalog(BuildContext context) =>
    const _StatusBarsRoute();

Widget _buildSidebarsCatalog(BuildContext context) => const _SidebarsRoute();

Widget _buildEmptyStatesCatalog(BuildContext context) =>
    const _EmptyStatesRoute();

Widget _buildPickersCatalog(BuildContext context) => const _PickersRoute();

Widget _buildColorPickersCatalog(BuildContext context) =>
    const _ColorPickersRoute();

Widget _buildAppIconsCatalog(BuildContext context) => const _AppIconsRoute();

Widget _buildWidgetsCatalog(BuildContext context) => const _WidgetsRoute();

Widget _buildActivityViewsCatalog(BuildContext context) =>
    const _ActivityViewsRoute();

Widget _buildFaceIdCatalog(BuildContext context) => const _FaceIdRoute();

Widget _buildBezelsCatalog(BuildContext context) => const _BezelsRoute();

Widget _buildKeyboardsCatalog(BuildContext context) =>
    const _KeyboardsRoute();

Widget _buildHome(BuildContext context) => const _HomeRoute();

const List<({String path, String label, String description})> _homeIndex = <({
  String path,
  String label,
  String description,
})>[
  (
    path: '/colors/swatch-grid',
    label: 'Colors',
    description: '40 canonical iOS 26 color tokens',
  ),
  (
    path: '/colors/swatch-grid/increased-contrast',
    label: 'Colors · increased contrast',
    description: 'Same grid in the iOS 26 accessibility mode',
  ),
  (
    path: '/buttons/catalog',
    label: 'Buttons',
    description: '5 styles × 3 sizes × destructive × disabled = 60 cells',
  ),
  (
    path: '/toggles/catalog',
    label: 'Toggles',
    description: 'On/off/disabled on light + dark backgrounds',
  ),
  (
    path: '/sliders/catalog',
    label: 'Sliders',
    description: 'Track + fill + pill knob, 5 light positions + 1 dark',
  ),
  (
    path: '/steppers/catalog',
    label: 'Steppers',
    description: '−/+ pill with bound-aware disabling',
  ),
  (
    path: '/segmented-controls/catalog',
    label: 'Segmented Controls',
    description: '2/3/4 segments + disabled',
  ),
  (
    path: '/page-controls/catalog',
    label: 'Page Controls',
    description: 'Dot indicator with peripheral fading + dark variant',
  ),
  (
    path: '/progress/catalog',
    label: 'Progress + Spinners',
    description: 'Linear bar at 0/25/60/100% + animated spinners',
  ),
  (
    path: '/text-fields/catalog',
    label: 'Text Fields',
    description: 'Empty/filled/obscured/disabled + dark surface',
  ),
  (
    path: '/lists/catalog',
    label: 'Lists',
    description: 'Settings-style grouped rows + chevrons + dark',
  ),
  (
    path: '/top-bars/catalog',
    label: 'Top Bars',
    description: 'Nav title + leading/trailing actions, large-title row',
  ),
  (
    path: '/toolbars/catalog',
    label: 'Toolbars',
    description: 'Glass action buttons + filter chips',
  ),
  (
    path: '/sheets/catalog',
    label: 'Sheets',
    description: 'Modal/inspector sheets with grabber + 44pt controls',
  ),
  (
    path: '/alerts/catalog',
    label: 'Alerts',
    description: 'Centered translucent dialog with stacked or split actions',
  ),
  (
    path: '/action-sheets/catalog',
    label: 'Action Sheets',
    description: 'Bottom-anchored stack of full-width pill actions + cancel',
  ),
  (
    path: '/notifications/catalog',
    label: 'Notifications',
    description: 'Glass banner cards with icon, title, body, and time',
  ),
  (
    path: '/popovers/catalog',
    label: 'Popovers',
    description: 'Translucent floating panel with arrow tip on any side',
  ),
  (
    path: '/menu/catalog',
    label: 'Menu',
    description: 'iOS dropdown menu with rows, separators, and section titles',
  ),
  (
    path: '/context-menu/catalog',
    label: 'Context Menu',
    description: 'Preview tile + menu in vertical or beside arrangements',
  ),
  (
    path: '/popup-buttons/catalog',
    label: 'Popup Buttons',
    description: 'Inline blue label + chevron-down (32/38) — popup trigger',
  ),
  (
    path: '/status-bars/catalog',
    label: 'Status Bars',
    description: 'iPhone status bar with clock + cellular/wifi/battery glyphs',
  ),
  (
    path: '/sidebars/catalog',
    label: 'Sidebars',
    description: 'iPad-style left rail: search + section headers + nav rows',
  ),
  (
    path: '/empty-states/catalog',
    label: 'Empty States',
    description: 'Centered icon + title + description + optional CTA pill',
  ),
  (
    path: '/pickers/catalog',
    label: 'Pickers',
    description: 'Inline calendar date picker with selection + today ring',
  ),
  (
    path: '/color-pickers/catalog',
    label: 'Color Pickers',
    description: 'Conic-gradient picker button + 12-col swatch grid + dots',
  ),
  (
    path: '/app-icons/catalog',
    label: 'App Icons',
    description: 'Squircle home-screen icon with optional badge + label',
  ),
  (
    path: '/widgets/catalog',
    label: 'Widgets',
    description: 'Home-screen widget cards (small/medium/large/extraLarge)',
  ),
  (
    path: '/activity-views/catalog',
    label: 'Activity Views',
    description: 'iOS share sheet — translucent panel + header + content',
  ),
  (
    path: '/face-id/catalog',
    label: 'Face ID',
    description: 'Black bezel with green Face ID glyph (scan/success/fail)',
  ),
  (
    path: '/bezels/catalog',
    label: 'Bezels',
    description: 'iPhone device frame with optional Dynamic Island',
  ),
  (
    path: '/keyboards/catalog',
    label: 'Keyboards',
    description: 'iPhone keyboard surface — suggestions, keys, toolbar',
  ),
];

class _HomeRoute extends StatelessWidget {
  const _HomeRoute();

  @override
  Widget build(BuildContext context) {
    final theme = LiqTheme.of(context);
    final titleColor = theme.labelColor.resolve(theme.brightness);
    return ColoredBox(
      color: const Color(0xFFF2F2F7),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
        child: Center(
          child: SizedBox(
            width: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'liqkit_ui showcase',
                  style: theme.titleText.toTextStyle().copyWith(
                        color: titleColor,
                        fontSize: 28,
                      ),
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 6),
                const Text(
                  'iOS 26 Liquid Glass — Flutter port. Tap any row to '
                  'open the live route.',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 15,
                    color: Color(0x993C3C43),
                  ),
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                LiqListGroup(
                  rows: <LiqListRow>[
                    for (final entry in _homeIndex)
                      LiqListRow(
                        title: entry.label,
                        subtitle: entry.description,
                        showChevron: true,
                        onTap: () => Navigator.of(context).pushNamed(entry.path),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '31 / 37 categories ported (Keyboards in this build). '
                  'All values sourced from liqkit_ui_design_data '
                  '(variable-defs + native CSS).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    color: Color(0x993C3C43),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildColorsSwatchGrid(BuildContext context) =>
    const _ColorsRoute(mode: LiqColorMode.default_);

Widget _buildColorsSwatchGridIncreasedContrast(BuildContext context) =>
    const _ColorsRoute(mode: LiqColorMode.increasedContrast);

Widget _buildButtonsCatalog(BuildContext context) => const _ButtonsRoute();

class _ColorsRoute extends StatelessWidget {
  const _ColorsRoute({required this.mode});
  final LiqColorMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = LiqTheme.of(context);
    return ColoredBox(
      color: theme.surfaceColor.resolve(theme.brightness),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LiqColorSwatchGrid(mode: mode),
      ),
    );
  }
}

class _ButtonsRoute extends StatelessWidget {
  const _ButtonsRoute();

  static const List<LiqButtonStyle> _styles = LiqButtonStyle.values;
  static const List<LiqButtonSize> _sizes = LiqButtonSize.values;

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: _ButtonsBody(),
      ),
    );
  }
}

class _ButtonsBody extends StatelessWidget {
  const _ButtonsBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final style in LiqButtonStyle.values)
          _StyleSection(style: style),
      ],
    );
  }
}

class _StyleSection extends StatelessWidget {
  const _StyleSection({required this.style});

  final LiqButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              style.name,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101114),
              ),
              textDirection: TextDirection.ltr,
            ),
          ),
          for (final destructive in const <bool>[false, true])
            for (final enabled in const <bool>[true, false])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 160,
                      child: Text(
                        '${destructive ? 'destructive' : 'normal'} · '
                        '${enabled ? 'enabled' : 'disabled'}',
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 13,
                          color: Color(0xFF666A72),
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    for (final size in LiqButtonSize.values)
                      LiqButton(
                        label: _label(size),
                        onPressed: enabled ? _noop : null,
                        style: style,
                        size: size,
                        destructive: destructive,
                      ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  static void _noop() {}

  String _label(LiqButtonSize size) => switch (size) {
        LiqButtonSize.small => 'Small',
        LiqButtonSize.medium => 'Medium',
        LiqButtonSize.large => 'Large',
      };
}

class _TogglesRoute extends StatefulWidget {
  const _TogglesRoute();

  @override
  State<_TogglesRoute> createState() => _TogglesRouteState();
}

class _TogglesRouteState extends State<_TogglesRoute> {
  bool _light = true;
  bool _dark = true;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 16,
          children: <Widget>[
            _Cell(
              label: 'on · light',
              background: const Color(0xFFF4F4F5),
              child: LiqToggle(
                value: _light,
                onChanged: (bool v) => setState(() => _light = v),
              ),
            ),
            _Cell(
              label: 'off · light',
              background: const Color(0xFFF4F4F5),
              child: const LiqToggle(value: false, onChanged: _noop),
            ),
            _Cell(
              label: 'disabled · light',
              background: const Color(0xFFF4F4F5),
              child: const LiqToggle(value: true, onChanged: null),
            ),
            _Cell(
              label: 'on · dark',
              background: const Color(0xFF060606),
              labelLight: false,
              child: LiqToggle(
                value: _dark,
                onChanged: (bool v) => setState(() => _dark = v),
              ),
            ),
            _Cell(
              label: 'off · dark',
              background: const Color(0xFF060606),
              labelLight: false,
              child: const LiqToggle(value: false, onChanged: _noop),
            ),
            _Cell(
              label: 'disabled · dark',
              background: const Color(0xFF060606),
              labelLight: false,
              child: const LiqToggle(value: false, onChanged: null),
            ),
          ],
        ),
      ),
    );
  }

  static void _noop(bool _) {}
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.label,
    required this.background,
    required this.child,
    this.labelLight = true,
  });

  final String label;
  final Color background;
  final Widget child;
  final bool labelLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          child,
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: labelLight
                  ? const Color(0xFF666A72)
                  : const Color(0xFFE5E7EB),
            ),
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}

class _SlidersRoute extends StatefulWidget {
  const _SlidersRoute();

  @override
  State<_SlidersRoute> createState() => _SlidersRouteState();
}

class _SlidersRouteState extends State<_SlidersRoute> {
  double _a = 0;
  double _b = 0.25;
  double _c = 0.5;
  double _d = 0.75;
  double _e = 1;
  double _dark = 0.5;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'sliders · light',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101114),
              ),
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xFFE6E6E6)),
              ),
              child: Column(
                children: <Widget>[
                  _SliderRow(
                    label: '0%',
                    child: LiqSlider(
                      value: _a,
                      onChanged: (double v) => setState(() => _a = v),
                    ),
                  ),
                  _SliderRow(
                    label: '25%',
                    child: LiqSlider(
                      value: _b,
                      onChanged: (double v) => setState(() => _b = v),
                    ),
                  ),
                  _SliderRow(
                    label: '50%',
                    child: LiqSlider(
                      value: _c,
                      onChanged: (double v) => setState(() => _c = v),
                    ),
                  ),
                  _SliderRow(
                    label: '75%',
                    child: LiqSlider(
                      value: _d,
                      onChanged: (double v) => setState(() => _d = v),
                    ),
                  ),
                  _SliderRow(
                    label: '100%',
                    child: LiqSlider(
                      value: _e,
                      onChanged: (double v) => setState(() => _e = v),
                    ),
                  ),
                  _SliderRow(
                    label: 'disabled',
                    child: const LiqSlider(value: 0.4, onChanged: null),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'sliders · dark',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101114),
              ),
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  _SliderRow(
                    label: 'value',
                    labelLight: false,
                    child: LiqSlider(
                      value: _dark,
                      brightness: Brightness.dark,
                      onChanged: (double v) => setState(() => _dark = v),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.child,
    this.labelLight = true,
  });
  final String label;
  final Widget child;
  final bool labelLight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 13,
                color: labelLight
                    ? const Color(0xFF666A72)
                    : const Color(0xFFE5E7EB),
              ),
              textDirection: TextDirection.ltr,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SteppersRoute extends StatefulWidget {
  const _SteppersRoute();

  @override
  State<_SteppersRoute> createState() => _SteppersRouteState();
}

class _SteppersRouteState extends State<_SteppersRoute> {
  int _a = 0;
  int _b = 5;
  int _c = 10;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 16,
          children: <Widget>[
            _StepperCell(
              label: 'value=0 (min)',
              child: LiqStepper(
                value: _a,
                onChanged: (int v) => setState(() => _a = v),
              ),
              currentValue: _a,
            ),
            _StepperCell(
              label: 'value=5',
              child: LiqStepper(
                value: _b,
                onChanged: (int v) => setState(() => _b = v),
              ),
              currentValue: _b,
            ),
            _StepperCell(
              label: 'value=10 (max=10)',
              child: LiqStepper(
                value: _c,
                max: 10,
                onChanged: (int v) => setState(() => _c = v),
              ),
              currentValue: _c,
            ),
            _StepperCell(
              label: 'disabled',
              child: const LiqStepper(value: 7, onChanged: null),
              currentValue: 7,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperCell extends StatelessWidget {
  const _StepperCell({
    required this.label,
    required this.child,
    required this.currentValue,
  });
  final String label;
  final Widget child;
  final int currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$currentValue',
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 17,
                  color: Color(0xFF000000),
                ),
                textDirection: TextDirection.ltr,
              ),
              child,
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedRoute extends StatefulWidget {
  const _SegmentedRoute();
  @override
  State<_SegmentedRoute> createState() => _SegmentedRouteState();
}

class _SegmentedRouteState extends State<_SegmentedRoute> {
  String _two = 'a';
  int _three = 1;
  int _four = 2;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _SegLabel('2 segments'),
            SizedBox(
              width: 370,
              child: LiqSegmentedControl<String>(
                segments: const <({String value, String label})>[
                  (value: 'a', label: 'Label'),
                  (value: 'b', label: 'Label'),
                ],
                value: _two,
                onChanged: (String v) => setState(() => _two = v),
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('3 segments'),
            SizedBox(
              width: 370,
              child: LiqSegmentedControl<int>(
                segments: const <({int value, String label})>[
                  (value: 0, label: 'One'),
                  (value: 1, label: 'Two'),
                  (value: 2, label: 'Three'),
                ],
                value: _three,
                onChanged: (int v) => setState(() => _three = v),
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('4 segments'),
            SizedBox(
              width: 370,
              child: LiqSegmentedControl<int>(
                segments: const <({int value, String label})>[
                  (value: 0, label: 'Day'),
                  (value: 1, label: 'Week'),
                  (value: 2, label: 'Month'),
                  (value: 3, label: 'Year'),
                ],
                value: _four,
                onChanged: (int v) => setState(() => _four = v),
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('disabled'),
            SizedBox(
              width: 370,
              child: LiqSegmentedControl<int>(
                segments: const <({int value, String label})>[
                  (value: 0, label: 'A'),
                  (value: 1, label: 'B'),
                  (value: 2, label: 'C'),
                ],
                value: 1,
                onChanged: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegLabel extends StatelessWidget {
  const _SegLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 13,
          color: Color(0xFF666A72),
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class _PageControlsRoute extends StatelessWidget {
  const _PageControlsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('3 dots, page 1 (light)'),
            _PageControlCard(
              brightness: LiqPageControlBrightness.light,
              child: LiqPageControl(count: 3, activeIndex: 0),
            ),
            const SizedBox(height: 16),
            const _SegLabel('5 dots, page 3 (light)'),
            _PageControlCard(
              brightness: LiqPageControlBrightness.light,
              child: LiqPageControl(count: 5, activeIndex: 2),
            ),
            const SizedBox(height: 16),
            const _SegLabel('20 dots, page 11 (light)'),
            _PageControlCard(
              brightness: LiqPageControlBrightness.light,
              child: LiqPageControl(count: 20, activeIndex: 10),
            ),
            const SizedBox(height: 16),
            const _SegLabel('5 dots, page 3 (dark)'),
            _PageControlCard(
              brightness: LiqPageControlBrightness.dark,
              child: LiqPageControl(
                count: 5,
                activeIndex: 2,
                brightness: LiqPageControlBrightness.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageControlCard extends StatelessWidget {
  const _PageControlCard({
    required this.brightness,
    required this.child,
  });
  final LiqPageControlBrightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == LiqPageControlBrightness.dark;
    return Container(
      width: 320,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF12151C) : const Color(0xFFF6F7F9),
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        border: Border.all(
          color: dark ? const Color(0xFF2F3340) : const Color(0xFFD8DCE3),
        ),
      ),
      child: child,
    );
  }
}

class _ProgressRoute extends StatelessWidget {
  const _ProgressRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('progress · 0%'),
            const SizedBox(width: 320, child: LiqProgressBar(value: 0)),
            const SizedBox(height: 16),
            const _SegLabel('progress · 25%'),
            const SizedBox(width: 320, child: LiqProgressBar(value: 0.25)),
            const SizedBox(height: 16),
            const _SegLabel('progress · 60%'),
            const SizedBox(width: 320, child: LiqProgressBar(value: 0.6)),
            const SizedBox(height: 16),
            const _SegLabel('progress · 100%'),
            const SizedBox(width: 320, child: LiqProgressBar(value: 1)),
            const SizedBox(height: 28),
            const _SegLabel('spinners · regular + small'),
            Row(
              children: const <Widget>[
                LiqSpinner(),
                SizedBox(width: 24),
                LiqSpinner(size: LiqSpinnerSize.small),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldsRoute extends StatefulWidget {
  const _TextFieldsRoute();

  @override
  State<_TextFieldsRoute> createState() => _TextFieldsRouteState();
}

class _TextFieldsRouteState extends State<_TextFieldsRoute> {
  late final TextEditingController _empty = TextEditingController();
  late final TextEditingController _filled =
      TextEditingController(text: 'Sample text');
  late final TextEditingController _password =
      TextEditingController(text: 'hunter2');
  late final TextEditingController _disabled =
      TextEditingController(text: 'Read only');
  late final TextEditingController _dark =
      TextEditingController(text: 'Dark surface');

  @override
  void dispose() {
    _empty.dispose();
    _filled.dispose();
    _password.dispose();
    _disabled.dispose();
    _dark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('empty (placeholder)'),
            SizedBox(
              width: 320,
              child: LiqTextField(
                controller: _empty,
                placeholder: 'Enter text…',
              ),
            ),
            const SizedBox(height: 12),
            const _SegLabel('filled'),
            SizedBox(
              width: 320,
              child: LiqTextField(controller: _filled),
            ),
            const SizedBox(height: 12),
            const _SegLabel('obscured'),
            SizedBox(
              width: 320,
              child: LiqTextField(
                controller: _password,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 12),
            const _SegLabel('disabled'),
            SizedBox(
              width: 320,
              child: LiqTextField(
                controller: _disabled,
                enabled: false,
              ),
            ),
            const SizedBox(height: 12),
            const _SegLabel('dark surface'),
            ColoredBox(
              color: const Color(0xFF000000),
              child: SizedBox(
                width: 320,
                child: LiqTextField(
                  controller: _dark,
                  brightness: Brightness.dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListsRoute extends StatelessWidget {
  const _ListsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF2F2F7),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('Settings-style group'),
            const SizedBox(
              width: 360,
              child: LiqListGroup(
                rows: <LiqListRow>[
                  LiqListRow(
                    title: 'Wi-Fi',
                    detail: 'liqkit-net',
                    showChevron: true,
                  ),
                  LiqListRow(
                    title: 'Bluetooth',
                    detail: 'On',
                    showChevron: true,
                  ),
                  LiqListRow(
                    title: 'Cellular',
                    showChevron: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('Two-line rows'),
            const SizedBox(
              width: 360,
              child: LiqListGroup(
                rows: <LiqListRow>[
                  LiqListRow(
                    title: 'Notifications',
                    subtitle: '8 unread',
                    showChevron: true,
                  ),
                  LiqListRow(
                    title: 'Sounds & Haptics',
                    subtitle: 'Standard',
                    showChevron: true,
                  ),
                  LiqListRow(
                    title: 'Focus',
                    subtitle: 'Do Not Disturb',
                    showChevron: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('Dark surface'),
            SizedBox(
              width: 360,
              child: LiqListGroup(
                brightness: Brightness.dark,
                rows: <LiqListRow>[
                  LiqListRow(
                    title: 'General',
                    detail: 'iOS 26',
                    showChevron: true,
                    brightness: Brightness.dark,
                  ),
                  LiqListRow(
                    title: 'Display & Brightness',
                    showChevron: true,
                    brightness: Brightness.dark,
                  ),
                  LiqListRow(
                    title: 'Accessibility',
                    showChevron: true,
                    brightness: Brightness.dark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarsRoute extends StatelessWidget {
  const _TopBarsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('plain title'),
            _TopBarCard(child: LiqTopBar(title: 'Settings')),
            const SizedBox(height: 16),
            const _SegLabel('with back + accent action'),
            _TopBarCard(
              child: LiqTopBar(
                title: 'Wi-Fi',
                leading: LiqTopBarSymbolButton(
                  glyph: '‹',
                  onPressed: () {},
                ),
                trailing: LiqTopBarAccentButton(
                  glyph: '+',
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('large title'),
            _TopBarCard(
              child: LiqTopBar(
                title: 'Inbox',
                largeTitle: 'Inbox',
                trailing: LiqTopBarSymbolButton(
                  glyph: '⌕',
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('dark surface'),
            _TopBarCard(
              dark: true,
              child: LiqTopBar(
                title: 'Photos',
                brightness: Brightness.dark,
                largeTitle: 'Photos',
                leading: LiqTopBarSymbolButton(
                  glyph: '‹',
                  onPressed: () {},
                  brightness: Brightness.dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarCard extends StatelessWidget {
  const _TopBarCard({required this.child, this.dark = false});
  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: dark ? const Color(0xFF2C2C2E) : const Color(0xFFE6E6E6),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _ToolbarsRoute extends StatelessWidget {
  const _ToolbarsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('glass action buttons'),
            SizedBox(
              width: 380,
              child: LiqToolbar(
                leading: <Widget>[
                  LiqToolbarGlassButton(
                    label: 'Cancel',
                    onPressed: () {},
                  ),
                ],
                trailing: <Widget>[
                  LiqToolbarGlassButton(
                    label: 'Save',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('symbol-only toolbar'),
            SizedBox(
              width: 380,
              child: LiqToolbar(
                leading: <Widget>[
                  LiqToolbarGlassButton(
                    label: '⌫',
                    onPressed: () {},
                    symbolOnly: true,
                  ),
                  LiqToolbarGlassButton(
                    label: '↻',
                    onPressed: () {},
                    symbolOnly: true,
                  ),
                ],
                trailing: <Widget>[
                  LiqToolbarGlassButton(
                    label: '⇪',
                    onPressed: () {},
                    symbolOnly: true,
                  ),
                  LiqToolbarGlassButton(
                    label: '⌘',
                    onPressed: () {},
                    symbolOnly: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SegLabel('chips · light'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                LiqToolbarChip(label: 'All'),
                LiqToolbarChip(label: 'Unread'),
                LiqToolbarChip(label: 'Flagged'),
                LiqToolbarChip(label: 'Mentions'),
                LiqToolbarChip(label: 'Recent'),
              ],
            ),
            const SizedBox(height: 16),
            const _SegLabel('chips · dark'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF0F1115),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  LiqToolbarChip(
                    label: 'All',
                    brightness: Brightness.dark,
                  ),
                  LiqToolbarChip(
                    label: 'Unread',
                    brightness: Brightness.dark,
                  ),
                  LiqToolbarChip(
                    label: 'Flagged',
                    brightness: Brightness.dark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetsRoute extends StatelessWidget {
  const _SheetsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _SheetCell(
              caption: 'fullscreen',
              child: LiqSheet(title: 'Title'),
            ),
            SizedBox(height: 24),
            _SheetCell(
              caption: 'stacked',
              child: LiqSheet(
                title: 'Title',
                variant: LiqSheetVariant.stacked,
              ),
            ),
            SizedBox(height: 24),
            _SheetCell(
              caption: 'inspector',
              child: LiqSheet(
                title: 'Title',
                variant: LiqSheetVariant.inspector,
                height: 220,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetCell extends StatelessWidget {
  const _SheetCell({required this.caption, required this.child});
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            caption,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          width: 360,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _AlertsRoute extends StatelessWidget {
  const _AlertsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: <Widget>[
            _AlertCell(
              caption: 'stacked · 2 actions',
              child: LiqAlert(
                title: 'Allow Notifications',
                description: 'liqkit_ui needs permission to send you '
                    'updates while in the background.',
                actions: <LiqAlertAction>[
                  LiqAlertAction(
                    label: 'Allow',
                    style: LiqAlertActionStyle.filled,
                  ),
                  LiqAlertAction(label: 'Not Now'),
                ],
              ),
            ),
            _AlertCell(
              caption: 'side-by-side',
              child: LiqAlert(
                title: 'Discard Changes?',
                description: 'You have unsaved changes that will be lost.',
                layout: LiqAlertActionLayout.sideBySide,
                actions: <LiqAlertAction>[
                  LiqAlertAction(label: 'Cancel'),
                  LiqAlertAction(
                    label: 'Discard',
                    style: LiqAlertActionStyle.destructive,
                  ),
                ],
              ),
            ),
            _AlertCell(
              caption: 'destructive · stacked',
              child: LiqAlert(
                title: 'Delete File',
                description: 'This action cannot be undone.',
                actions: <LiqAlertAction>[
                  LiqAlertAction(
                    label: 'Delete',
                    style: LiqAlertActionStyle.destructive,
                  ),
                  LiqAlertAction(label: 'Cancel'),
                ],
              ),
            ),
            _AlertCell(
              caption: 'three actions',
              child: LiqAlert(
                title: 'Unsaved Draft',
                actions: <LiqAlertAction>[
                  LiqAlertAction(
                    label: 'Save',
                    style: LiqAlertActionStyle.filled,
                  ),
                  LiqAlertAction(
                    label: 'Discard',
                    style: LiqAlertActionStyle.destructive,
                  ),
                  LiqAlertAction(label: 'Cancel'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertCell extends StatelessWidget {
  const _AlertCell({required this.caption, required this.child});
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            caption,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        child,
      ],
    );
  }
}

class _ActionSheetsRoute extends StatelessWidget {
  const _ActionSheetsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: <Widget>[
            _AlertCell(
              caption: 'with header + cancel',
              child: LiqActionSheet(
                title: 'Sort by',
                description: 'Choose how to order your library.',
                actions: <LiqAlertAction>[
                  LiqAlertAction(label: 'Date Added'),
                  LiqAlertAction(label: 'Name'),
                  LiqAlertAction(label: 'Size'),
                  LiqAlertAction(label: 'Type'),
                ],
                cancelAction: LiqAlertAction(label: 'Cancel'),
              ),
            ),
            _AlertCell(
              caption: 'destructive · cancel',
              child: LiqActionSheet(
                actions: <LiqAlertAction>[
                  LiqAlertAction(
                    label: 'Delete Photo',
                    style: LiqAlertActionStyle.destructive,
                  ),
                ],
                cancelAction: LiqAlertAction(label: 'Cancel'),
              ),
            ),
            _AlertCell(
              caption: 'no header · long list',
              child: LiqActionSheet(
                actions: <LiqAlertAction>[
                  LiqAlertAction(label: 'Action 1'),
                  LiqAlertAction(label: 'Action 2'),
                  LiqAlertAction(label: 'Action 3'),
                  LiqAlertAction(label: 'Action 4'),
                  LiqAlertAction(label: 'Action 5'),
                ],
                cancelAction: LiqAlertAction(label: 'Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsRoute extends StatelessWidget {
  const _NotificationsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF101418),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'mail (blue) · with time',
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 13,
                  color: Color(0xFFC0C5CC),
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            LiqNotification(
              title: 'Mail',
              body: 'Sam: "Lunch at noon? I made a reservation."',
              time: 'now',
              icon: LiqNotificationIcon(
                colors: LiqNotificationIconColors.mail,
                glyph: _NotificationGlyph.mail(),
              ),
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'reminders (red) · without time',
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 13,
                  color: Color(0xFFC0C5CC),
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            LiqNotification(
              title: 'Reminders',
              body: 'Buy milk on the way home.',
              icon: LiqNotificationIcon(
                colors: LiqNotificationIconColors.reminders,
                glyph: _NotificationGlyph.list(),
              ),
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'long body · ellipsised',
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 13,
                  color: Color(0xFFC0C5CC),
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            LiqNotification(
              title: 'Mail',
              body: 'Andy: "Could you take a look at the spec when you get '
                  'a chance? There are a few open questions about how the '
                  'review pipeline should handle reverts."',
              time: '2m ago',
              icon: LiqNotificationIcon(
                colors: LiqNotificationIconColors.mail,
                glyph: _NotificationGlyph.mail(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationGlyph extends StatelessWidget {
  const _NotificationGlyph._(this.kind);
  factory _NotificationGlyph.mail() => const _NotificationGlyph._('mail');
  factory _NotificationGlyph.list() => const _NotificationGlyph._('list');
  final String kind;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _NotifPainter(kind)),
    );
  }
}

class _NotifPainter extends CustomPainter {
  _NotifPainter(this.kind);
  final String kind;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFAFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.6;
    final s = size.width / 22;
    if (kind == 'mail') {
      final rect =
          Rect.fromLTWH(2.5 * s, 5.5 * s, 17 * s, 11 * s);
      canvas
        ..drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(2 * s)),
          stroke,
        )
        ..drawPath(
          Path()
            ..moveTo(2.5 * s, 6.5 * s)
            ..lineTo(11 * s, 12 * s)
            ..lineTo(19.5 * s, 6.5 * s),
          stroke,
        );
    } else {
      final fill = Paint()..color = const Color(0xFAFFFFFF);
      for (var i = 0; i < 3; i++) {
        final y = (5 + i * 5) * s;
        canvas
          ..drawCircle(Offset(4 * s, y), 1.2 * s, fill)
          ..drawLine(Offset(7 * s, y), Offset(18 * s, y), stroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NotifPainter oldDelegate) =>
      oldDelegate.kind != kind;
}

class _PopoversRoute extends StatelessWidget {
  const _PopoversRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF6F7F9),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('top · center'),
            const _PopoverCell(
              child: LiqPopover(
                child: Text(
                  'Tap to add a tag',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    color: Color(0xFF1F2937),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _SegLabel('bottom · trailing'),
            const _PopoverCell(
              child: LiqPopover(
                side: LiqPopoverSide.bottom,
                alignment: LiqPopoverAlignment.trailing,
                child: Text(
                  'Sort by date',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    color: Color(0xFF1F2937),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _SegLabel('leading · middle'),
            const _PopoverCell(
              child: LiqPopover(
                side: LiqPopoverSide.leading,
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    color: Color(0xFF1F2937),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _SegLabel('trailing · top'),
            const _PopoverCell(
              child: LiqPopover(
                side: LiqPopoverSide.trailing,
                alignment: LiqPopoverAlignment.leading,
                child: Text(
                  'Read receipt: ON',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    color: Color(0xFF1F2937),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _SegLabel('dark surface'),
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF12151C),
              child: const LiqPopover(
                brightness: Brightness.dark,
                child: Text(
                  'Hold to drag',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    color: Color(0xFFE5E7EB),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopoverCell extends StatelessWidget {
  const _PopoverCell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFE9ECF1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: child,
    );
  }
}

class _MenuRoute extends StatelessWidget {
  const _MenuRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.start,
          children: <Widget>[
            _MenuCell(
              caption: 'edit · light',
              child: LiqMenu(
                children: <Widget>[
                  LiqMenuItem(
                    label: 'Cut',
                    onPressed: _menuNoop,
                    trailing: Text('Cmd X', textDirection: TextDirection.ltr),
                  ),
                  LiqMenuItem(
                    label: 'Copy',
                    onPressed: _menuNoop,
                    trailing: Text('Cmd C', textDirection: TextDirection.ltr),
                  ),
                  LiqMenuItem(
                    label: 'Paste',
                    onPressed: _menuNoop,
                    trailing: Text('Cmd V', textDirection: TextDirection.ltr),
                  ),
                  LiqMenuSeparator(),
                  LiqMenuItem(
                    label: 'Delete',
                    onPressed: _menuNoop,
                    style: LiqMenuItemStyle.destructive,
                  ),
                ],
              ),
            ),
            _MenuCell(
              caption: 'sections · light',
              child: LiqMenu(
                children: <Widget>[
                  LiqMenuSectionTitle(title: 'View'),
                  LiqMenuItem(label: 'As Icons', onPressed: _menuNoop),
                  LiqMenuItem(label: 'As List', onPressed: _menuNoop),
                  LiqMenuItem(label: 'As Columns', onPressed: _menuNoop),
                  LiqMenuSeparator(),
                  LiqMenuSectionTitle(title: 'Sort by'),
                  LiqMenuItem(label: 'Date Modified', onPressed: _menuNoop),
                  LiqMenuItem(label: 'Name', onPressed: _menuNoop),
                  LiqMenuItem(label: 'Size', onPressed: _menuNoop),
                ],
              ),
            ),
            _MenuCell(
              caption: 'disabled rows · light',
              child: LiqMenu(
                children: <Widget>[
                  LiqMenuItem(label: 'Undo', onPressed: _menuNoop),
                  LiqMenuItem(label: 'Redo', onPressed: null),
                  LiqMenuSeparator(),
                  LiqMenuItem(
                    label: 'Discard',
                    style: LiqMenuItemStyle.destructive,
                    onPressed: null,
                  ),
                ],
              ),
            ),
            _MenuCell(
              caption: 'dark surface',
              dark: true,
              child: LiqMenu(
                brightness: Brightness.dark,
                children: <Widget>[
                  LiqMenuSectionTitle(
                    title: 'Share',
                    brightness: Brightness.dark,
                  ),
                  LiqMenuItem(
                    label: 'AirDrop',
                    brightness: Brightness.dark,
                    onPressed: _menuNoop,
                  ),
                  LiqMenuItem(
                    label: 'Mail',
                    brightness: Brightness.dark,
                    onPressed: _menuNoop,
                  ),
                  LiqMenuSeparator(brightness: Brightness.dark),
                  LiqMenuItem(
                    label: 'Remove',
                    style: LiqMenuItemStyle.destructive,
                    brightness: Brightness.dark,
                    onPressed: _menuNoop,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _menuNoop() {}

class _MenuCell extends StatelessWidget {
  const _MenuCell({
    required this.caption,
    required this.child,
    this.dark = false,
  });
  final String caption;
  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            caption,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: dark ? const Color(0xFF12151C) : null,
          child: child,
        ),
      ],
    );
  }
}

class _ContextMenuRoute extends StatelessWidget {
  const _ContextMenuRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 28,
          runSpacing: 28,
          children: <Widget>[
            _ContextCell(
              caption: 'below · leading',
              child: LiqContextMenu(
                preview: LiqContextMenuPreview(size: Size(200, 200)),
                menu: LiqMenu(
                  width: 200,
                  children: <Widget>[
                    LiqMenuItem(
                      label: 'Edit',
                      onPressed: _menuNoop,
                    ),
                    LiqMenuItem(
                      label: 'Pin',
                      onPressed: _menuNoop,
                    ),
                    LiqMenuSeparator(),
                    LiqMenuItem(
                      label: 'Delete',
                      style: LiqMenuItemStyle.destructive,
                      onPressed: _menuNoop,
                    ),
                  ],
                ),
              ),
            ),
            _ContextCell(
              caption: 'beside · trailing',
              child: LiqContextMenu(
                arrangement: LiqContextMenuArrangement.besideTrailing,
                preview: LiqContextMenuPreview(size: Size(180, 180)),
                menu: LiqMenu(
                  width: 200,
                  children: <Widget>[
                    LiqMenuItem(
                      label: 'Schedule Send',
                      subtitle: 'Tomorrow at 9 AM',
                      onPressed: _menuNoop,
                    ),
                    LiqMenuItem(
                      label: 'Move to…',
                      onPressed: _menuNoop,
                    ),
                    LiqMenuSeparator(),
                    LiqMenuItem(
                      label: 'Discard',
                      style: LiqMenuItemStyle.destructive,
                      onPressed: _menuNoop,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContextCell extends StatelessWidget {
  const _ContextCell({required this.caption, required this.child});
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            caption,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        child,
      ],
    );
  }
}

class _PopupButtonsRoute extends StatelessWidget {
  const _PopupButtonsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('enabled'),
            LiqPopupButton(label: 'Sort by', onPressed: () {}),
            const SizedBox(height: 16),
            const _SegLabel('disabled'),
            const LiqPopupButton(label: 'Sort by'),
            const SizedBox(height: 16),
            const _SegLabel('long label'),
            LiqPopupButton(
              label: 'Last 30 days',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBarsRoute extends StatelessWidget {
  const _StatusBarsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('iPhone · light · 9:41'),
            _StatusBarFrame(child: LiqStatusBar()),
            const SizedBox(height: 16),
            const _SegLabel('iPhone · dark · 12:34'),
            _StatusBarFrame(
              dark: true,
              child: LiqStatusBar(
                time: '12:34',
                brightness: Brightness.dark,
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('low battery / 1 bar'),
            _StatusBarFrame(
              child: LiqStatusBar(
                cellularBars: 1,
                batteryLevel: 0.18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBarFrame extends StatelessWidget {
  const _StatusBarFrame({required this.child, this.dark = false});
  final Widget child;
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 402,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF13161C) : const Color(0xFFFFFFFF),
          border: Border.all(
            color: dark
                ? const Color(0x2EFFFFFF)
                : const Color(0xFFDDE2EB),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: child,
      ),
    );
  }
}

class _SidebarsRoute extends StatelessWidget {
  const _SidebarsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: <Widget>[
            LiqSidebar(
              children: <Widget>[
                LiqSidebarSearch(),
                SizedBox(height: 12),
                LiqSidebarSectionHeader(title: 'Mailboxes', detail: '12'),
                LiqSidebarRow(
                  title: 'All Inboxes',
                  detail: '42',
                  selected: true,
                ),
                LiqSidebarRow(title: 'VIP', detail: '3'),
                LiqSidebarRow(title: 'Flagged'),
                LiqSidebarRow(title: 'Drafts', detail: '7'),
                LiqSidebarSectionHeader(title: 'Folders'),
                LiqSidebarRow(title: 'Receipts'),
                LiqSidebarRow(title: 'Travel'),
                LiqSidebarRow(title: '2026', nested: true),
                LiqSidebarRow(title: '2025', nested: true),
              ],
            ),
            LiqSidebar(
              width: 280,
              children: <Widget>[
                LiqSidebarSectionHeader(title: 'Library'),
                LiqSidebarRow(title: 'Recent', detail: '128'),
                LiqSidebarRow(title: 'Photos'),
                LiqSidebarRow(title: 'Albums'),
                LiqSidebarRow(title: 'Trash'),
                LiqSidebarSectionHeader(title: 'Shared'),
                LiqSidebarRow(title: 'Family'),
                LiqSidebarRow(title: 'Vacation 2026'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStatesRoute extends StatelessWidget {
  const _EmptyStatesRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: <Widget>[
            _EmptyCell(
              caption: 'icon + title + description',
              child: LiqEmptyState(
                title: 'No Mail',
                description: 'New mail will appear here.',
                iconBackground: true,
                icon: SizedBox(
                  width: 22,
                  height: 22,
                  child: CustomPaint(painter: _EnvelopePainter()),
                ),
              ),
            ),
            _EmptyCell(
              caption: 'with CTA',
              child: LiqEmptyState(
                title: 'Welcome',
                description: 'Start by composing your first message.',
                cta: LiqEmptyStateCta(
                  label: 'Compose',
                  onPressed: () {},
                ),
              ),
            ),
            _EmptyCell(
              caption: 'minimal',
              child: LiqEmptyState(title: 'Nothing here yet'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell({required this.caption, required this.child});
  final String caption;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              caption,
              style: const TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 13,
                color: Color(0xFF666A72),
              ),
              textDirection: TextDirection.ltr,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(28)),
              border: Border.fromBorderSide(BorderSide(color: Color(0xFFE6E9EE))),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0A84FF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.7;
    final s = size.width / 22;
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(2 * s, 5 * s, 18 * s, 12 * s),
          Radius.circular(2 * s),
        ),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(2 * s, 6 * s)
          ..lineTo(11 * s, 13 * s)
          ..lineTo(20 * s, 6 * s),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PickersRoute extends StatefulWidget {
  const _PickersRoute();
  @override
  State<_PickersRoute> createState() => _PickersRouteState();
}

class _PickersRouteState extends State<_PickersRoute> {
  int _year = 2026;
  int _month = 4;
  int _selected = 27;

  void _prev() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year--;
      } else {
        _month--;
      }
    });
  }

  void _next() {
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year++;
      } else {
        _month++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('inline date picker · interactive'),
            LiqDatePicker(
              year: _year,
              month: _month,
              selectedDay: _selected,
              currentDay: DateTime.now().month == _month &&
                      DateTime.now().year == _year
                  ? DateTime.now().day
                  : null,
              onPrev: _prev,
              onNext: _next,
              onDayTap: (d) => setState(() => _selected = d),
            ),
            const SizedBox(height: 20),
            const _SegLabel('selected = today'),
            const LiqDatePicker(
              year: 2026,
              month: 4,
              selectedDay: 27,
              currentDay: 27,
            ),
            const SizedBox(height: 20),
            const _SegLabel('today ring only'),
            const LiqDatePicker(year: 2026, month: 4, currentDay: 15),
          ],
        ),
      ),
    );
  }
}

class _ColorPickersRoute extends StatefulWidget {
  const _ColorPickersRoute();
  @override
  State<_ColorPickersRoute> createState() => _ColorPickersRouteState();
}

class _ColorPickersRouteState extends State<_ColorPickersRoute> {
  Color _picked = const Color(0xFFAF52DE);
  int? _gridSelected = 17;
  int _dotSelected = 2;

  static const List<Color> _palette = <Color>[
    Color(0xFFFF3B30),
    Color(0xFFFF9500),
    Color(0xFFFFCC00),
    Color(0xFF34C759),
    Color(0xFF00C7BE),
    Color(0xFF30B0C7),
    Color(0xFF32ADE6),
    Color(0xFF007AFF),
    Color(0xFF5856D6),
    Color(0xFFAF52DE),
    Color(0xFFFF2D55),
    Color(0xFFA2845E),
  ];

  @override
  Widget build(BuildContext context) {
    final swatches = <Color>[];
    for (final base in _palette) {
      // 4 lightness ramps per hue (lightening) — synthesized for showcase.
      for (var i = 0; i < 3; i++) {
        final r = base.r;
        final g = base.g;
        final b = base.b;
        final mix = i / 3.0;
        swatches.add(Color.fromARGB(
          255,
          (r * 255 * (1 - mix) + 255 * mix).round().clamp(0, 255),
          (g * 255 * (1 - mix) + 255 * mix).round().clamp(0, 255),
          (b * 255 * (1 - mix) + 255 * mix).round().clamp(0, 255),
        ));
      }
    }

    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('color picker buttons'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LiqColorPickerButton(
                  color: _picked,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                LiqColorPickerButton(
                  color: _picked,
                  size: LiqColorPickerButtonSize.small,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SegLabel('palette · selectable dots'),
            SizedBox(
              width: 320,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  for (var i = 0; i < _palette.length; i++)
                    LiqColorDot(
                      color: _palette[i],
                      selected: i == _dotSelected,
                      onPressed: () => setState(() {
                        _dotSelected = i;
                        _picked = _palette[i];
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SegLabel('12-column swatch grid'),
            SizedBox(
              width: 360,
              child: LiqColorGrid(
                colors: swatches,
                selectedIndex: _gridSelected,
                onSelected: (i) => setState(() {
                  _gridSelected = i;
                  _picked = swatches[i];
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppIconsRoute extends StatelessWidget {
  const _AppIconsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('home-screen tiles · 66pt'),
            Wrap(
              spacing: 22,
              runSpacing: 22,
              children: <Widget>[
                LiqAppIcon(
                  label: 'Mail',
                  badge: LiqAppIconBadge(count: 3),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFF62CCFF), Color(0xFF0A87F5)],
                  ),
                  glyph: SizedBox(
                    width: 36,
                    height: 36,
                    child: CustomPaint(painter: _MailGlyph()),
                  ),
                ),
                LiqAppIcon(
                  label: 'Reminders',
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFFFF6F88), Color(0xFFFF2B3F)],
                  ),
                  glyph: SizedBox(
                    width: 30,
                    height: 30,
                    child: CustomPaint(painter: _ListGlyph()),
                  ),
                ),
                LiqAppIcon(
                  label: 'Music',
                  badge: LiqAppIconBadge(count: 99),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFFFA5A8A), Color(0xFFC93473)],
                  ),
                ),
                LiqAppIcon(
                  label: 'Settings',
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFFCED2D9), Color(0xFF80868F)],
                  ),
                ),
                LiqAppIcon(
                  label: 'Photos',
                  badge: LiqAppIconBadge(count: 250),
                  color: Color(0xFFFFFFFF),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const _SegLabel('large variant · 96pt'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LiqAppIcon(
                  size: 96,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFF62CCFF), Color(0xFF0A87F5)],
                  ),
                  glyph: SizedBox(
                    width: 56,
                    height: 56,
                    child: CustomPaint(painter: _MailGlyph()),
                  ),
                ),
                const SizedBox(width: 16),
                LiqAppIcon(
                  size: 96,
                  badge: LiqAppIconBadge(count: 7),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFFFFCC00), Color(0xFFFF9500)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MailGlyph extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.4;
    final s = size.width / 36;
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(3 * s, 8 * s, 30 * s, 20 * s),
          Radius.circular(3 * s),
        ),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(3 * s, 10 * s)
          ..lineTo(18 * s, 22 * s)
          ..lineTo(33 * s, 10 * s),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ListGlyph extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;
    final fill = Paint()..color = const Color(0xFFFFFFFF);
    final s = size.width / 30;
    for (var i = 0; i < 3; i++) {
      final y = (8 + i * 7) * s;
      canvas
        ..drawCircle(Offset(7 * s, y), 1.6 * s, fill)
        ..drawLine(Offset(11 * s, y), Offset(24 * s, y), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WidgetsRoute extends StatelessWidget {
  const _WidgetsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('small (1:1)'),
            const SizedBox(
              width: 160,
              child: LiqWidgetCard(
                size: LiqWidgetSize.small,
                caption: 'Weather',
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('medium (2:1)'),
            const SizedBox(
              width: 320,
              child: LiqWidgetCard(
                size: LiqWidgetSize.medium,
                caption: 'Calendar',
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('large (1:1.045)'),
            const SizedBox(
              width: 320,
              child: LiqWidgetCard(
                size: LiqWidgetSize.large,
                caption: 'Stocks',
              ),
            ),
            const SizedBox(height: 16),
            const _SegLabel('extra large (2.1:1) · iPad'),
            const SizedBox(
              width: 380,
              child: LiqWidgetCard(
                size: LiqWidgetSize.extraLarge,
                caption: 'News',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityViewsRoute extends StatelessWidget {
  const _ActivityViewsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('share sheet · with header + apps strip'),
            LiqActivitySheet(
              header: LiqActivityHeader(
                title: 'liqkit_ui Spec.pdf',
                subtitle: '12 pages · 2.4 MB',
                onClose: () {},
              ),
              child: SizedBox(
                height: 88,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const <Widget>[
                    _ActivityApp(label: 'AirDrop', color: Color(0xFF4B62F8)),
                    SizedBox(width: 18),
                    _ActivityApp(label: 'Messages', color: Color(0xFF1CBE54)),
                    SizedBox(width: 18),
                    _ActivityApp(label: 'Mail', color: Color(0xFF3478F6)),
                    SizedBox(width: 18),
                    _ActivityApp(label: 'Notes', color: Color(0xFFFFD95A)),
                    SizedBox(width: 18),
                    _ActivityApp(label: 'Reminders', color: Color(0xFFFF453A)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _SegLabel('header only · no body'),
            const LiqActivitySheet(
              width: 360,
              header: LiqActivityHeader(
                title: 'Family vacation.heic',
                subtitle: '4032 × 3024 · HEIC',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityApp extends StatelessWidget {
  const _ActivityApp({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x1F000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 11,
              height: 13 / 11,
              color: Color(0xFF111111),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaceIdRoute extends StatelessWidget {
  const _FaceIdRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SegLabel('scanning'),
            const LiqFaceIdBezel(),
            const SizedBox(height: 28),
            const _SegLabel('success'),
            const LiqFaceIdBezel(state: LiqFaceIdState.success),
            const SizedBox(height: 28),
            const _SegLabel('fail'),
            const LiqFaceIdBezel(state: LiqFaceIdState.fail),
          ],
        ),
      ),
    );
  }
}

class _BezelsRoute extends StatelessWidget {
  const _BezelsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: <Widget>[
            _BezelCell(
              caption: 'with Dynamic Island',
              child: LiqDeviceBezel(
                size: Size(220, 478),
                child: Center(
                  child: Text(
                    'Hello iPhone',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
            _BezelCell(
              caption: 'no island · custom screen',
              child: LiqDeviceBezel(
                size: Size(220, 478),
                showIsland: false,
                screenColor: Color(0xFFFEF3C7),
                child: Center(
                  child: Text(
                    'Lock screen',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BezelCell extends StatelessWidget {
  const _BezelCell({required this.caption, required this.child});
  final String caption;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            caption,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        child,
      ],
    );
  }
}

class _KeyboardsRoute extends StatelessWidget {
  const _KeyboardsRoute();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE9ECF1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: const <Widget>[
            _KeyboardCell(
              caption: 'default · iPhone QWERTY',
              child: LiqKeyboard(width: 360, minHeight: 320),
            ),
            _KeyboardCell(
              caption: 'numbers · custom rows',
              child: LiqKeyboard(
                width: 360,
                minHeight: 320,
                suggestions: <String>['1,000', '\$10', '99%'],
                keyRows: <List<String>>[
                  <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
                  <String>['-', '/', ':', ';', '(', ')', '\$', '&', '@', '"'],
                  <String>['.', ',', '?', '!', '\''],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyboardCell extends StatelessWidget {
  const _KeyboardCell({required this.caption, required this.child});
  final String caption;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            caption,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              color: Color(0xFF666A72),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        child,
      ],
    );
  }
}

