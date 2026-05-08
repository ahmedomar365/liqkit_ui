import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Single-column iOS-26-styled wheel picker built directly on
/// [ListWheelScrollView]. Replaces the previous reliance on
/// `CupertinoPicker`, which is iOS-13-era styling.
///
/// Renders a centered selection band, label rows, and snaps-to-row
/// scrolling with optional haptics. This is the building block used by
/// `LiqWheelPicker`, `LiqMultiColumnPicker`, `LiqWheelDatePicker`, and
/// `LiqTimerPicker` — none of those import Cupertino.
///
/// The widget is private to liqkit_ui's pickers folder; consumers
/// always go through the higher-level wrappers.
class LiqWheelColumn extends StatefulWidget {
  /// Creates a wheel column.
  const LiqWheelColumn({
    required this.itemCount,
    required this.itemBuilder,
    required this.onSelectedItemChanged,
    this.controller,
    this.initialIndex = 0,
    this.itemExtent = 36,
    this.diameterRatio = 1.07,
    this.squeeze = 1.25,
    this.offAxisFraction = 0,
    this.enableHaptics = true,
    this.height,
    super.key,
  });

  /// Number of rows the wheel can scroll to.
  final int itemCount;

  /// Builds the widget for row [index].
  final IndexedWidgetBuilder itemBuilder;

  /// Reports the new selected index when the wheel rests on it.
  final ValueChanged<int> onSelectedItemChanged;

  /// Optional external controller (e.g. for jumping to a row when
  /// the parent's value prop changes).
  final FixedExtentScrollController? controller;

  /// Initial row when [controller] is null.
  final int initialIndex;

  /// Per-row vertical extent in logical pixels. iOS uses 36 for body
  /// rows and 32–40 in some reduced layouts.
  final double itemExtent;

  /// Cylinder bend ratio. iOS canonical is 1.07.
  final double diameterRatio;

  /// Vertical squeeze factor. > 1 packs more rows visible at the top
  /// and bottom edges.
  final double squeeze;

  /// Lateral skew for column grouping. 0 keeps the column centered.
  final double offAxisFraction;

  /// Whether `HapticFeedback.selectionClick()` fires on each tick.
  final bool enableHaptics;

  /// Optional fixed height. When null the column expands to the parent.
  final double? height;

  @override
  State<LiqWheelColumn> createState() => _LiqWheelColumnState();
}

class _LiqWheelColumnState extends State<LiqWheelColumn> {
  late final FixedExtentScrollController _ownController;
  int _lastReportedIndex = -1;

  FixedExtentScrollController get _controller =>
      widget.controller ?? _ownController;

  @override
  void initState() {
    super.initState();
    _ownController =
        FixedExtentScrollController(initialItem: widget.initialIndex);
    _lastReportedIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _ownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wheel = ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: widget.itemExtent,
      diameterRatio: widget.diameterRatio,
      squeeze: widget.squeeze,
      offAxisFraction: widget.offAxisFraction,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      onSelectedItemChanged: (index) {
        if (index == _lastReportedIndex) return;
        _lastReportedIndex = index;
        if (widget.enableHaptics) {
          HapticFeedback.selectionClick();
        }
        widget.onSelectedItemChanged(index);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.itemCount,
        builder: widget.itemBuilder,
      ),
    );

    final overlay = IgnorePointer(
      child: Center(
        child: _SelectionBand(extent: widget.itemExtent),
      ),
    );

    final stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[wheel, overlay],
    );

    if (widget.height != null) {
      return SizedBox(height: widget.height, child: stack);
    }
    return stack;
  }
}

/// The translucent selection band painted across the centered row of
/// a wheel column. Pixel-aligned to [extent] so the row's text sits
/// exactly inside it.
class _SelectionBand extends StatelessWidget {
  const _SelectionBand({required this.extent});

  final double extent;

  static const Color _lightFill = Color(0x14000000);
  static const Color _darkFill = Color(0x14FFFFFF);

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    return Container(
      height: extent,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? _darkFill : _lightFill,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}

/// Convenience text style helpers — keeps the pickers visually
/// uniform.
class LiqWheelTextStyle {
  LiqWheelTextStyle._();

  /// Standard wheel-row text style.
  static TextStyle resolve(BuildContext context, {double fontSize = 21}) {
    final isDark = context.liqIsDark;
    final color = isDark ? LiqAppleColors.labelDark : LiqAppleColors.label;
    return TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      letterSpacing: -0.4,
    );
  }
}
