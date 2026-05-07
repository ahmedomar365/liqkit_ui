import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One option in a [LiqTabSegmentedControl] or
/// [LiqVerticalSegmentedControl].
@immutable
class LiqSegmentItem<T> {
  /// Creates a segment item.
  const LiqSegmentItem({
    required this.value,
    required this.label,
    this.icon,
  });

  /// Value reported via `onChanged` when this item is selected.
  final T value;

  /// Display label.
  final String label;

  /// Optional leading glyph.
  final IconData? icon;
}

/// Tab-style segmented control — a row of labels with an animated
/// underline indicator under the selected one. Borderless. Used for
/// in-page tab navigation (Overview / Details / Reviews etc.).
final class LiqTabSegmentedControl<T> extends StatelessWidget
    with Diagnosticable {
  /// Creates a tab segmented control.
  const LiqTabSegmentedControl({
    required this.value,
    required this.segments,
    required this.onChanged,
    this.indicatorColor,
    this.height = 44,
    super.key,
  });

  final T value;
  final List<LiqSegmentItem<T>> segments;
  final ValueChanged<T>? onChanged;
  final Color? indicatorColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final accent = indicatorColor ?? LiqAppleColors.systemBlue;
    final inactiveLabel = isDark
        ? const Color(0xB2EBEBF5)
        : const Color(0xB23C3C43);
    final disabled = onChanged == null;
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final segment in segments)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: disabled ? null : () => onChanged!(segment.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: segment.value == value
                            ? accent
                            : const Color(0x00000000),
                        width: 2,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (segment.icon != null) ...<Widget>[
                        Icon(
                          segment.icon,
                          size: 16,
                          color: segment.value == value
                              ? accent
                              : inactiveLabel,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        segment.label,
                        style: LiqAppleTypography.subheadline(brightness)
                            .copyWith(
                          color: segment.value == value
                              ? accent
                              : inactiveLabel,
                          fontWeight: segment.value == value
                              ? LiqAppleTypography.semibold
                              : LiqAppleTypography.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('segmentCount', segments.length))
      ..add(DoubleProperty('height', height));
  }
}

/// Vertical sidebar-style segmented control — column of pill buttons
/// with an accent-tinted selected state. Used for settings menus,
/// secondary navigation (General / Privacy / Notifications).
final class LiqVerticalSegmentedControl<T> extends StatelessWidget
    with Diagnosticable {
  /// Creates a vertical segmented control.
  const LiqVerticalSegmentedControl({
    required this.value,
    required this.segments,
    required this.onChanged,
    this.selectedColor,
    super.key,
  });

  final T value;
  final List<LiqSegmentItem<T>> segments;
  final ValueChanged<T>? onChanged;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final accent = selectedColor ?? LiqAppleColors.systemBlue;
    final selectedBg = accent.withValues(alpha: isDark ? 0.22 : 0.12);
    final inactiveLabel = isDark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);
    final disabled = onChanged == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final segment in segments)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: disabled ? null : () => onChanged!(segment.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: segment.value == value
                      ? selectedBg
                      : const Color(0x00000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    if (segment.icon != null) ...<Widget>[
                      Icon(
                        segment.icon,
                        size: 18,
                        color: segment.value == value
                            ? accent
                            : inactiveLabel,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        segment.label,
                        style: LiqAppleTypography.body(brightness).copyWith(
                          color: segment.value == value
                              ? accent
                              : inactiveLabel,
                          fontWeight: segment.value == value
                              ? LiqAppleTypography.semibold
                              : LiqAppleTypography.regular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('segmentCount', segments.length));
  }
}
