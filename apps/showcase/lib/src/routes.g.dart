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
                  '18 / 37 categories ported (Menu in this build). '
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
