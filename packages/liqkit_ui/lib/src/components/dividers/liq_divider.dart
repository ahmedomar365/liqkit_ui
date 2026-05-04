import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Orientation for [LiqDivider].
enum LiqDividerOrientation {
  /// Horizontal hairline. Width fills its parent.
  horizontal,

  /// Vertical hairline. Height fills its parent.
  vertical,
}

/// iOS 26 hairline separator.
///
/// A 0.33pt physical-thickness rule, sized along its [orientation]'s
/// cross-axis to fill its parent. [indent] insets the leading edge
/// (left for horizontal, top for vertical) and [endIndent] insets the
/// trailing edge.
final class LiqDivider extends StatelessWidget {
  /// Creates a hairline separator.
  const LiqDivider({
    this.orientation = LiqDividerOrientation.horizontal,
    this.indent = 0,
    this.endIndent = 0,
    this.color = defaultColor,
    super.key,
  });

  /// Orientation of the hairline.
  final LiqDividerOrientation orientation;

  /// Leading inset in logical pixels (left for horizontal, top for
  /// vertical).
  final double indent;

  /// Trailing inset in logical pixels (right for horizontal, bottom
  /// for vertical).
  final double endIndent;

  /// Hairline color. Defaults to [defaultColor].
  final Color color;

  /// Default hairline color: 16% black on white.
  static const Color defaultColor = Color(0x29000000);

  /// Default hairline color in dark theme.
  static const Color darkDefaultColor = Color(0x29FFFFFF);

  /// iOS 26 hairline thickness in logical pixels.
  static const double thickness = 0.33;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _effectiveColor(context, color);
    switch (orientation) {
      case LiqDividerOrientation.horizontal:
        return Container(
          height: thickness,
          margin: EdgeInsets.only(left: indent, right: endIndent),
          color: effectiveColor,
        );
      case LiqDividerOrientation.vertical:
        return Container(
          width: thickness,
          margin: EdgeInsets.only(top: indent, bottom: endIndent),
          color: effectiveColor,
        );
    }
  }

  static Color _effectiveColor(BuildContext context, Color color) {
    if (color != defaultColor) return color;
    final brightness = context.liqBrightness;
    return brightness == Brightness.dark ? darkDefaultColor : defaultColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqDividerOrientation>('orientation', orientation))
      ..add(DoubleProperty('indent', indent))
      ..add(DoubleProperty('endIndent', endIndent))
      ..add(ColorProperty('color', color));
  }
}

/// Horizontal hairline with a centered text label, e.g. "OR".
///
/// Lays out two [LiqDivider]s flanking a centered [label]. The [gap]
/// is the horizontal padding between the label and each line.
final class LiqLabeledDivider extends StatelessWidget {
  /// Creates a labeled divider.
  const LiqLabeledDivider({
    required this.label,
    this.gap = 12,
    this.color = LiqDivider.defaultColor,
    this.textStyle,
    super.key,
  });

  /// Text rendered between the two hairlines.
  final String label;

  /// Horizontal space in logical pixels between the label and each
  /// hairline.
  final double gap;

  /// Hairline color passed through to each [LiqDivider].
  final Color color;

  /// Optional override for the label text style. Defaults to
  /// [defaultLabelStyle].
  final TextStyle? textStyle;

  /// Default label style: SF 13pt in iOS secondary-label grey.
  static const TextStyle defaultLabelStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 13,
    color: Color(0xFF8E8E93),
  );

  @override
  Widget build(BuildContext context) {
    final effectiveColor = LiqDivider._effectiveColor(context, color);
    final effectiveStyle =
        textStyle ??
        defaultLabelStyle.copyWith(color: context.liqSecondaryLabelColor);
    return Row(
      children: [
        Expanded(child: LiqDivider(color: effectiveColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gap),
          child: Text(label, style: effectiveStyle),
        ),
        Expanded(child: LiqDivider(color: effectiveColor)),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DoubleProperty('gap', gap))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
  }
}
