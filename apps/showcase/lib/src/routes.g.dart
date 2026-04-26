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
};

Widget _buildTogglesCatalog(BuildContext context) => const _TogglesRoute();

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
