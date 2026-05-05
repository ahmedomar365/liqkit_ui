import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';
import 'package:liqkit_ui/src/tokens/_generated/canonical.dart';

/// A single iOS 26 color swatch card.
class LiqColorSwatch extends StatelessWidget {
  /// Creates a color swatch.
  const LiqColorSwatch({
    required this.label,
    required this.value,
    this.swatchSize = 88,
    super.key,
  });

  /// Display label (e.g. `Accents/Blue`).
  final String label;

  /// Resolved color value to render.
  final Color value;

  /// Logical size of the swatch square.
  final double swatchSize;

  static const Color _cardBorder = Color(0xFFD8DCE3);
  static const Color _hexFg = Color(0xFF6B7280);
  static const TextStyle _hexStyle = TextStyle(
    fontFamily: 'SF Mono',
    fontFamilyFallback: <String>['ui-monospace', 'Menlo', 'monospace'],
    fontSize: 11,
    height: 14 / 11,
    color: _hexFg,
  );

  @override
  Widget build(BuildContext context) {
    final theme = LiqTheme.of(context);
    final cardBg = theme.surfaceColor.resolve(theme.brightness);
    final labelStyle = theme.bodyText.toTextStyle().copyWith(
      fontSize: 12,
      color: theme.labelColor.resolve(theme.brightness),
    );

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: _cardBorder),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: SizedBox(
              width: swatchSize,
              height: swatchSize,
              child: ColoredBox(color: value),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: labelStyle, maxLines: 1),
          const SizedBox(height: 2),
          Text(_hexLabel(value), style: _hexStyle, maxLines: 1),
        ],
      ),
    );
  }

  String _hexLabel(Color c) {
    final hex = c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#${hex.substring(2)}';
  }
}

/// A grid of all iOS 26 color tokens for the active [LiqColorMode].
class LiqColorSwatchGrid extends StatelessWidget {
  /// Creates a swatch grid.
  const LiqColorSwatchGrid({
    this.mode = LiqColorMode.default_,
    this.minCardWidth = 110,
    super.key,
  });

  /// Token mode to resolve every color in.
  final LiqColorMode mode;

  /// Minimum card width before the responsive grid wraps.
  final double minCardWidth;

  @override
  Widget build(BuildContext context) {
    const entries = LiqCanonicalColors.all;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.hasBoundedWidth ? constraints.maxWidth : 360.0;
        final columns = (maxWidth / minCardWidth).floor().clamp(1, 6);
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final entry in entries)
              SizedBox(
                width: (maxWidth - (columns - 1) * 8) / columns,
                child: LiqColorSwatch(
                  label: entry.key,
                  value: entry.value.valueIn(mode),
                ),
              ),
          ],
        );
      },
    );
  }
}
