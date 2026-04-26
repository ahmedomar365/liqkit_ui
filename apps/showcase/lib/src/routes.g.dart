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
};

Widget _buildTogglesCatalog(BuildContext context) => const _TogglesRoute();

Widget _buildSlidersCatalog(BuildContext context) => const _SlidersRoute();

Widget _buildSteppersCatalog(BuildContext context) => const _SteppersRoute();

Widget _buildSegmentedCatalog(BuildContext context) => const _SegmentedRoute();

Widget _buildPageControlsCatalog(BuildContext context) =>
    const _PageControlsRoute();

Widget _buildProgressCatalog(BuildContext context) => const _ProgressRoute();

Widget _buildHome(BuildContext context) {
  final theme = LiqTheme.of(context);
  return ColoredBox(
    color: theme.surfaceColor.resolve(theme.brightness),
    child: Center(
      child: Text(
        'liqkit_ui showcase',
        style: theme.titleText.toTextStyle().copyWith(
              color: theme.labelColor.resolve(theme.brightness),
            ),
        textDirection: TextDirection.ltr,
      ),
    ),
  );
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
