import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Figma-aligned Liquid Glass specimen built from real liqkit_ui primitives.
class MaterialsSpecimen extends StatelessWidget {
  /// Creates a material specimen panel for docs previews.
  const MaterialsSpecimen({
    required this.brightness,
    this.style = LiqMaterialStyle.regular,
    super.key,
  });

  /// The rendered material brightness.
  final LiqMaterialBrightness brightness;

  /// The material thickness preset.
  final LiqMaterialStyle style;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == LiqMaterialBrightness.dark;
    final palette = _SpecimenPalette(isDark: isDark);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: LiqMaterialChip(
        brightness: brightness,
        style: style,
        size: const Size(680, 360),
        borderRadius: const BorderRadius.all(Radius.circular(38)),
        padding: const EdgeInsets.fromLTRB(56, 38, 56, 34),
        child: DefaultTextStyle(
          style: TextStyle(
            color: palette.primaryText,
            fontFamily: 'SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            height: 1.18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(child: _SpecimenColumn.labels(palette)),
                    const SizedBox(width: 80),
                    Expanded(child: _SpecimenColumn.fills(palette)),
                  ],
                ),
              ),
              Container(height: 1, color: palette.separator),
              const SizedBox(height: 24),
              Text('Separator', style: TextStyle(color: palette.primaryText)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecimenColumn extends StatelessWidget {
  const _SpecimenColumn.labels(this.palette) : kind = _SpecimenKind.labels;
  const _SpecimenColumn.fills(this.palette) : kind = _SpecimenKind.fills;

  final _SpecimenPalette palette;
  final _SpecimenKind kind;

  @override
  Widget build(BuildContext context) {
    final isLabels = kind == _SpecimenKind.labels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(isLabels ? 'Labels' : 'Fills'),
        const SizedBox(height: 24),
        _SpecimenRow(
          swatch: isLabels ? palette.primarySwatch : palette.primaryFill,
          label: isLabels ? 'Vibrant Primary Text' : 'Vibrant Primary Fill',
          color: palette.primaryText,
        ),
        const SizedBox(height: 18),
        _SpecimenRow(
          swatch: isLabels ? palette.secondarySwatch : palette.secondaryFill,
          label: isLabels ? 'Vibrant Secondary Text' : 'Vibrant Secondary Fill',
          color: palette.secondaryText,
        ),
        const SizedBox(height: 18),
        _SpecimenRow(
          swatch: isLabels ? palette.tertiarySwatch : palette.tertiaryFill,
          label: isLabels ? 'Vibrant Tertiary Text' : 'Vibrant Tertiary Fill',
          color: palette.tertiaryText,
        ),
      ],
    );
  }
}

class _SpecimenRow extends StatelessWidget {
  const _SpecimenRow({
    required this.swatch,
    required this.label,
    required this.color,
  });

  final Color swatch;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: swatch,
            borderRadius: const BorderRadius.all(Radius.circular(17)),
          ),
          child: const SizedBox.square(dimension: 54),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}

enum _SpecimenKind { labels, fills }

class _SpecimenPalette {
  const _SpecimenPalette({required bool isDark})
    : primaryText = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
      secondaryText =
          isDark ? const Color(0xCCFFFFFF) : const Color(0xCC000000),
      tertiaryText = isDark ? const Color(0x73FFFFFF) : const Color(0x66000000),
      primarySwatch =
          isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
      secondarySwatch =
          isDark ? const Color(0xCFE8F6FF) : const Color(0x80315C9E),
      tertiarySwatch =
          isDark ? const Color(0x7FA8C2FF) : const Color(0x665A78C8),
      primaryFill = isDark ? const Color(0xBCE0FFFF) : const Color(0x7395AFAF),
      secondaryFill =
          isDark ? const Color(0x72C6FFF5) : const Color(0x52A3C7C5),
      tertiaryFill = isDark ? const Color(0x55D0FFF8) : const Color(0x40B5DEDC),
      separator = isDark ? const Color(0x2EFFFFFF) : const Color(0x24000000);

  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color primarySwatch;
  final Color secondarySwatch;
  final Color tertiarySwatch;
  final Color primaryFill;
  final Color secondaryFill;
  final Color tertiaryFill;
  final Color separator;
}
