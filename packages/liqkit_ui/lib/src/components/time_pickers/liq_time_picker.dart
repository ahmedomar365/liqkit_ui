import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 3-column scroll-wheel time picker.
///
/// Renders hours / minutes / (AM-PM) when [use24HourFormat] is false;
/// hours / minutes only when true.
///
/// Each column is a [ListWheelScrollView] with [FixedExtentScrollPhysics]
/// that snaps to the nearest tick. The hour and minute wheels loop
/// infinitely (via [ListWheelChildLoopingListDelegate]); the AM/PM
/// column is a finite 2-entry wheel.
final class LiqTimePicker extends StatefulWidget {
  /// Creates a wheel-style time picker.
  ///
  /// [minuteInterval] must be a positive integer that evenly divides
  /// 60 (e.g. 1, 5, 10, 15, 20, 30).
  const LiqTimePicker({
    required this.value,
    required this.onChanged,
    this.use24HourFormat = false,
    this.minuteInterval = 1,
    super.key,
  }) : assert(
         minuteInterval > 0 && 60 % minuteInterval == 0,
         'minuteInterval must evenly divide 60',
       );

  /// The currently selected time. The date portion is ignored — only
  /// hour and minute are used to seed the wheels.
  final DateTime value;

  /// Called with a new [DateTime] (year/month/day inherited from
  /// [value], time set from the wheel selections) whenever any wheel
  /// snaps to a new tick.
  final ValueChanged<DateTime> onChanged;

  /// When true, render hours 0-23 and hide the AM/PM column.
  /// Defaults to false (12-hour with AM/PM).
  final bool use24HourFormat;

  /// Step between minute ticks. Must be > 0 and evenly divide 60.
  /// Defaults to 1.
  final int minuteInterval;

  /// Per-row pixel height. Also dictates the diameter of each wheel.
  static const double itemExtent = 32;

  /// Total height of the picker container.
  static const double wheelHeight = 240;

  /// Wheel curvature; matches iOS 26 wheel pickers.
  static const double diameterRatio = 1.5;

  /// Color of the hairline pair that frames the centered row.
  static const Color hairlineColor = Color(0x29000000);

  /// Hairline thickness in logical pixels (matches iOS 0.33pt).
  static const double hairlineThickness = 0.33;

  /// Subtle group fill behind the wheels.
  static const Color backgroundColor = Color(0x0A000000);

  /// Default text color for wheel items.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Default text style for wheel items.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 21,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  @override
  State<LiqTimePicker> createState() => _LiqTimePickerState();
}

class _LiqTimePickerState extends State<LiqTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _amPmController;

  // Cached "current" indices, used to recompute the DateTime when any
  // wheel changes.
  late int _hourIndex;
  late int _minuteIndex;
  late int _amPmIndex; // 0 = AM, 1 = PM. Unused in 24h mode.

  int get _hourCount => widget.use24HourFormat ? 24 : 12;
  int get _minuteCount => 60 ~/ widget.minuteInterval;

  @override
  void initState() {
    super.initState();
    _seedFromValue(widget.value);
    _hourController = FixedExtentScrollController(initialItem: _hourIndex);
    _minuteController = FixedExtentScrollController(initialItem: _minuteIndex);
    _amPmController = FixedExtentScrollController(initialItem: _amPmIndex);
  }

  @override
  void didUpdateWidget(covariant LiqTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reseedFormat =
        oldWidget.use24HourFormat != widget.use24HourFormat ||
        oldWidget.minuteInterval != widget.minuteInterval;
    if (reseedFormat) {
      _seedFromValue(widget.value);
      _hourController.jumpToItem(_hourIndex);
      _minuteController.jumpToItem(_minuteIndex);
      _amPmController.jumpToItem(_amPmIndex);
      return;
    }
    // Otherwise, only follow the parent if the parent changed value
    // and the wheel is currently parked on the *old* index.
    final old = oldWidget.value;
    final next = widget.value;
    if (old.hour == next.hour && old.minute == next.minute) return;
    _seedFromValue(next);
    _hourController.jumpToItem(_hourIndex);
    _minuteController.jumpToItem(_minuteIndex);
    _amPmController.jumpToItem(_amPmIndex);
  }

  void _seedFromValue(DateTime v) {
    if (widget.use24HourFormat) {
      _hourIndex = v.hour;
      _amPmIndex = 0;
    } else {
      _amPmIndex = v.hour >= 12 ? 1 : 0;
      final twelveHour = v.hour % 12;
      // Display order is 12, 1, 2, ..., 11. Index 0 = "12".
      _hourIndex = twelveHour; // 0 maps to "12", 1..11 map to "1".."11".
    }
    final snappedMinute =
        (v.minute ~/ widget.minuteInterval) * widget.minuteInterval;
    _minuteIndex = snappedMinute ~/ widget.minuteInterval;
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _amPmController.dispose();
    super.dispose();
  }

  int _hourFromIndex(int rawIndex) {
    final mod = rawIndex % _hourCount;
    final idx = mod < 0 ? mod + _hourCount : mod;
    if (widget.use24HourFormat) return idx;
    // 12-hour: index 0 displays "12", indices 1..11 display "1".."11".
    final twelveHour = idx == 0 ? 12 : idx;
    final isPm = _amPmIndex == 1;
    if (twelveHour == 12) return isPm ? 12 : 0;
    return isPm ? twelveHour + 12 : twelveHour;
  }

  int _minuteFromIndex(int rawIndex) {
    final mod = rawIndex % _minuteCount;
    final idx = mod < 0 ? mod + _minuteCount : mod;
    return idx * widget.minuteInterval;
  }

  void _emit() {
    final hour = _hourFromIndex(_hourIndex);
    final minute = _minuteFromIndex(_minuteIndex);
    final base = widget.value;
    widget.onChanged(DateTime(base.year, base.month, base.day, hour, minute));
  }

  void _onHourChanged(int index) {
    _hourIndex = index;
    _emit();
  }

  void _onMinuteChanged(int index) {
    _minuteIndex = index;
    _emit();
  }

  void _onAmPmChanged(int index) {
    _amPmIndex = index;
    _emit();
  }

  String _hourLabel(int displayIndex) {
    if (widget.use24HourFormat) {
      return displayIndex.toString().padLeft(2, '0');
    }
    return (displayIndex == 0 ? 12 : displayIndex).toString();
  }

  String _minuteLabel(int displayIndex) {
    final m = displayIndex * widget.minuteInterval;
    return m.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final columns = <Widget>[
      Expanded(
        child: _Wheel(
          controller: _hourController,
          itemCount: _hourCount,
          looping: true,
          onSelectedItemChanged: _onHourChanged,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 8),
          builder: _hourLabel,
        ),
      ),
      const SizedBox(
        width: 12,
        child: Center(
          child: Text(
            ':',
            textDirection: TextDirection.ltr,
            style: LiqTimePicker.textStyle,
          ),
        ),
      ),
      Expanded(
        child: _Wheel(
          controller: _minuteController,
          itemCount: _minuteCount,
          looping: true,
          onSelectedItemChanged: _onMinuteChanged,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
          builder: _minuteLabel,
        ),
      ),
      if (!widget.use24HourFormat)
        Expanded(
          child: _Wheel(
            controller: _amPmController,
            itemCount: 2,
            looping: false,
            onSelectedItemChanged: _onAmPmChanged,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            builder: (i) => i == 0 ? 'AM' : 'PM',
          ),
        ),
    ];

    return SizedBox(
      height: LiqTimePicker.wheelHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: LiqTimePicker.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: columns,
              ),
            ),
            const Positioned.fill(child: _SelectionHairlines()),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final hour = _hourFromIndex(_hourIndex);
    final minute = _minuteFromIndex(_minuteIndex);
    properties
      ..add(IntProperty('hour', hour))
      ..add(IntProperty('minute', minute))
      ..add(
        FlagProperty(
          'use24HourFormat',
          value: widget.use24HourFormat,
          ifTrue: '24-hour',
          ifFalse: '12-hour',
        ),
      )
      ..add(IntProperty('minuteInterval', widget.minuteInterval));
  }
}

/// A single wheel column.
class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.controller,
    required this.itemCount,
    required this.looping,
    required this.onSelectedItemChanged,
    required this.alignment,
    required this.padding,
    required this.builder,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final bool looping;
  final ValueChanged<int> onSelectedItemChanged;
  final Alignment alignment;
  final EdgeInsets padding;
  final String Function(int index) builder;

  @override
  Widget build(BuildContext context) {
    Widget itemAt(int index) {
      return Container(
        alignment: alignment,
        padding: padding,
        child: Text(
          builder(index),
          textDirection: TextDirection.ltr,
          style: LiqTimePicker.textStyle,
        ),
      );
    }

    final ListWheelChildDelegate childDelegate;
    if (looping) {
      childDelegate = ListWheelChildLoopingListDelegate(
        children: <Widget>[for (var i = 0; i < itemCount; i++) itemAt(i)],
      );
    } else {
      childDelegate = ListWheelChildListDelegate(
        children: <Widget>[for (var i = 0; i < itemCount; i++) itemAt(i)],
      );
    }

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: LiqTimePicker.itemExtent,
      diameterRatio: LiqTimePicker.diameterRatio,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: childDelegate,
    );
  }
}

/// Two horizontal hairlines that frame the centered row of the wheels.
class _SelectionHairlines extends StatelessWidget {
  const _SelectionHairlines();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Center(
        child: SizedBox(
          height: LiqTimePicker.itemExtent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_Hairline(), _Hairline()],
          ),
        ),
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: LiqTimePicker.hairlineThickness,
      child: DecoratedBox(
        decoration: BoxDecoration(color: LiqTimePicker.hairlineColor),
      ),
    );
  }
}
