import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One option in a [LiqWheelPicker].
@immutable
class LiqWheelPickerItem<T> {
  /// Creates a wheel-picker item.
  const LiqWheelPickerItem({required this.value, required this.label});

  /// The value reported via `onValueChanged` when this row is selected.
  final T value;

  /// Display text.
  final String label;
}

/// iOS 26 generic wheel picker.
///
/// Spinning-wheel selector for arbitrary `T` values. Use this when the
/// option set is small enough to scroll through (typically ≤ 50 items)
/// and you want the canonical iOS wheel UX.
///
/// For dates and times specifically, prefer [LiqWheelDatePicker] —
/// which delegates to `CupertinoDatePicker` for full multi-column
/// date/time interactions.
///
/// ```dart
/// LiqWheelPicker<String>(
///   items: const <LiqWheelPickerItem<String>>[
///     LiqWheelPickerItem(value: 's', label: 'Small'),
///     LiqWheelPickerItem(value: 'm', label: 'Medium'),
///     LiqWheelPickerItem(value: 'l', label: 'Large'),
///   ],
///   selectedValue: size,
///   onValueChanged: (v) => setState(() => size = v),
/// )
/// ```
final class LiqWheelPicker<T> extends StatefulWidget {
  /// Creates a generic wheel picker.
  const LiqWheelPicker({
    required this.items,
    required this.onValueChanged,
    this.selectedValue,
    this.height = 216,
    this.itemExtent = 32,
    this.diameterRatio = 1.07,
    this.squeeze = 1.45,
    this.enableHaptics = true,
    this.tint = LiqGlassTint.opaque,
    this.brightness,
    super.key,
  });

  /// Items the wheel will spin through.
  final List<LiqWheelPickerItem<T>> items;

  /// Currently selected value. If it doesn't match any item, the wheel
  /// rests on the first item.
  final T? selectedValue;

  /// Selection callback.
  final ValueChanged<T> onValueChanged;

  /// Total picker height. iOS HIG default is 216pt.
  final double height;

  /// Per-row vertical extent.
  final double itemExtent;

  /// Cylinder bend ratio. iOS canonical is 1.07.
  final double diameterRatio;

  /// Edge squeeze factor. iOS canonical is 1.45.
  final double squeeze;

  /// Whether `HapticFeedback.selectionClick()` fires on each tick.
  final bool enableHaptics;

  /// Glass tint preset.
  final LiqGlassTint tint;

  /// Override surface brightness.
  final Brightness? brightness;

  @override
  State<LiqWheelPicker<T>> createState() => _LiqWheelPickerState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('itemCount', items.length))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('itemExtent', itemExtent));
  }
}

class _LiqWheelPickerState<T> extends State<LiqWheelPicker<T>> {
  late FixedExtentScrollController _controller;

  int get _initialIndex {
    if (widget.selectedValue == null) return 0;
    for (var i = 0; i < widget.items.length; i++) {
      if (widget.items[i].value == widget.selectedValue) return i;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _controller =
        FixedExtentScrollController(initialItem: _initialIndex);
  }

  @override
  void didUpdateWidget(LiqWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      final target = _initialIndex;
      if (_controller.selectedItem != target) {
        _controller.jumpToItem(target);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
    final labelColor = isDark
        ? LiqAppleColors.labelDark
        : LiqAppleColors.label;
    return LiqGlassSurface(
      tint: widget.tint,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: SizedBox(
        height: widget.height,
        child: CupertinoPicker(
          scrollController: _controller,
          itemExtent: widget.itemExtent,
          diameterRatio: widget.diameterRatio,
          squeeze: widget.squeeze,
          backgroundColor: const Color(0x00000000),
          onSelectedItemChanged: (index) {
            if (widget.enableHaptics) HapticFeedback.selectionClick();
            widget.onValueChanged(widget.items[index].value);
          },
          children: <Widget>[
            for (final item in widget.items)
              Center(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 21,
                    color: labelColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
