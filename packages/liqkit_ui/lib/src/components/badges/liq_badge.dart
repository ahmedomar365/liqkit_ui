import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Visual variant for [LiqBadge].
///
/// Each variant maps to a fixed iOS 26 system color for the pill background
/// and a corresponding foreground color for the label or count glyph.
enum LiqBadgeVariant {
  /// Light grey pill with dark text. The default.
  neutral,

  /// iOS system blue, white text.
  primary,

  /// iOS system green, white text.
  success,

  /// iOS system orange, white text.
  warning,

  /// iOS system red, white text.
  destructive,
}

/// iOS 26 pill-shaped count or status indicator.
///
/// Renders one of three things, in priority order:
/// 1. A dot-only 8x8 circle when [dot] is `true`.
/// 2. A pill containing the formatted [count] (clamped to `99+`).
/// 3. A pill containing the free-form [label].
///
/// Exactly one of [label], [count], or [dot] must be supplied — the
/// constructor asserts otherwise.
final class LiqBadge extends StatelessWidget {
  /// Creates a badge.
  ///
  /// One of [label], [count], or [dot] must be non-null/true.
  const LiqBadge({
    this.label,
    this.count,
    this.variant = LiqBadgeVariant.neutral,
    this.dot = false,
    super.key,
  }) : assert(label != null || count != null || dot, 'badge needs content');

  /// Free-form text shown inside the pill, e.g. `"New"`.
  final String? label;

  /// Numeric counter shown inside the pill. Values past 99 render as
  /// `"99+"`; negative values render as `"0"`.
  final int? count;

  /// Background/foreground color preset.
  final LiqBadgeVariant variant;

  /// When `true`, renders an 8×8 colored circle with no label or count.
  final bool dot;

  /// Pill minimum height in logical pixels.
  static const double pillMinHeight = 18;

  /// Pill horizontal padding in logical pixels for label and multi-digit
  /// counts.
  static const double pillHorizontalPadding = 8;

  /// Pill horizontal padding in logical pixels for single-digit counts.
  static const double pillHorizontalPaddingSingleDigit = 4;

  /// Side length in logical pixels of the dot-mode circle.
  static const double dotSize = 8;

  /// Glyph font size in logical pixels.
  static const double fontSize = 11;

  /// iOS system grey background for [LiqBadgeVariant.neutral].
  static const Color neutralBackground = Color(0xFFE5E5EA);

  /// iOS system blue background for [LiqBadgeVariant.primary].
  static const Color primaryBackground = Color(0xFF007AFF);

  /// iOS system green background for [LiqBadgeVariant.success].
  static const Color successBackground = Color(0xFF34C759);

  /// iOS system orange background for [LiqBadgeVariant.warning].
  static const Color warningBackground = Color(0xFFFF9500);

  /// iOS system red background for [LiqBadgeVariant.destructive].
  static const Color destructiveBackground = Color(0xFFFF3B30);

  /// Foreground color used by [LiqBadgeVariant.neutral].
  static const Color neutralForeground = Color(0xFF1C1C1E);

  /// Foreground color used by every non-neutral variant.
  static const Color contrastForeground = Color(0xFFFFFFFF);

  /// Background color for [variant].
  static Color backgroundFor(LiqBadgeVariant variant) {
    switch (variant) {
      case LiqBadgeVariant.neutral:
        return neutralBackground;
      case LiqBadgeVariant.primary:
        return primaryBackground;
      case LiqBadgeVariant.success:
        return successBackground;
      case LiqBadgeVariant.warning:
        return warningBackground;
      case LiqBadgeVariant.destructive:
        return destructiveBackground;
    }
  }

  /// Foreground color for [variant].
  static Color foregroundFor(LiqBadgeVariant variant) {
    return variant == LiqBadgeVariant.neutral
        ? neutralForeground
        : contrastForeground;
  }

  /// Renders [count] as `"0"`–`"99"` literally and `100+` as `"99+"`.
  ///
  /// Negative counts are treated as `0`.
  static String formatCount(int count) {
    if (count <= 0) return '0';
    if (count > 99) return '99+';
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    final background = backgroundFor(variant);

    if (dot) {
      return SizedBox(
        width: dotSize,
        height: dotSize,
        child: DecoratedBox(
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        ),
      );
    }

    final foreground = foregroundFor(variant);
    final text = count != null ? formatCount(count!) : label!;
    final isSingleDigitCount = count != null && text.length == 1;
    final horizontal =
        isSingleDigitCount
            ? pillHorizontalPaddingSingleDigit
            : pillHorizontalPadding;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: pillMinHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(pillMinHeight / 2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal),
          child: Center(
            widthFactor: 1,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: '.SF Pro Text',
                fontFamilyFallback: const <String>[
                  'SF Pro Text',
                  'SF Pro',
                  'system-ui',
                ],
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: foreground,
                height: 1,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqBadgeVariant>('variant', variant))
      ..add(DiagnosticsProperty<bool>('dot', dot))
      ..add(IntProperty('count', count, defaultValue: null))
      ..add(StringProperty('label', label, defaultValue: null));
  }
}
