import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/foundation/liq_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS-26 scroll-wheel time picker.
///
/// Renders hours / minutes / (AM-PM) when [use24HourFormat] is false;
/// hours / minutes only when true.
///
/// Each column is a [ListWheelScrollView] with [FixedExtentScrollPhysics]
/// that snaps to the nearest tick. Hour and minute wheels loop
/// infinitely; the AM/PM column is a finite 2-entry wheel.
///
/// The picker accepts mouse drag and trackpad scroll on web/desktop in
/// addition to touch on mobile (via a custom [ScrollBehavior]). The
/// centered row is highlighted with a soft fill and framed by two
/// hairlines; rows above/below fade out via a top-bottom gradient mask
/// for the classic iOS picker look.
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

  /// Per-row pixel height.
  static const double itemExtent = 44;

  /// Total height of the picker container.
  static const double wheelHeight = 236;

  /// Wheel curvature; matches iOS 26 wheel pickers.
  static const double diameterRatio = 1.72;

  /// Magnification of the centered row.
  static const double magnification = 1.06;

  /// Color of the hairline pair that frames the centered row.
  static const Color hairlineColor = Color(0x29000000);

  /// Hairline thickness in logical pixels (matches iOS 0.33pt).
  static const double hairlineThickness = 0.5;

  /// Soft fill behind the centered row.
  static const Color selectionFillColor = Color(0x14767680);

  /// Subtle group fill behind the wheels.
  static const Color backgroundColor = Color(0x0A000000);

  /// Default text color for wheel items.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Default text style for wheel items.
  static const TextStyle textStyle = TextStyle(
    fontFamily: LiqFontFamily.display,
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 30,
    height: 36 / 30,
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
    final old = oldWidget.value;
    final next = widget.value;
    if (old.hour == next.hour && old.minute == next.minute) return;

    final desired = _indicesForValue(next);
    final currentHour = _hourFromIndex(_hourIndex);
    final currentMinute = _minuteFromIndex(_minuteIndex);
    final nextMatchesCurrent =
        next.hour == currentHour &&
        next.minute == currentMinute &&
        (widget.use24HourFormat || desired.amPm == _amPmIndex);
    if (nextMatchesCurrent) return;

    _hourIndex = desired.hour;
    _minuteIndex = desired.minute;
    _amPmIndex = desired.amPm;
    final duration = context.liqMotionDuration(LiqMotion.normal);
    _hourController.animateToItem(
      _hourIndex,
      duration: duration,
      curve: LiqMotion.standard,
    );
    _minuteController.animateToItem(
      _minuteIndex,
      duration: duration,
      curve: LiqMotion.standard,
    );
    _amPmController.animateToItem(
      _amPmIndex,
      duration: duration,
      curve: LiqMotion.standard,
    );
  }

  void _seedFromValue(DateTime v) {
    final indices = _indicesForValue(v);
    _hourIndex = indices.hour;
    _minuteIndex = indices.minute;
    _amPmIndex = indices.amPm;
  }

  _TimePickerIndices _indicesForValue(DateTime v) {
    final hourIndex = widget.use24HourFormat ? v.hour : v.hour % 12;
    final amPmIndex = widget.use24HourFormat ? 0 : (v.hour >= 12 ? 1 : 0);
    final snappedMinute =
        (v.minute ~/ widget.minuteInterval) * widget.minuteInterval;
    return _TimePickerIndices(
      hour: hourIndex,
      minute: snappedMinute ~/ widget.minuteInterval,
      amPm: amPmIndex,
    );
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
    final palette = _TimePickerPalette.resolve(context);
    // Fixed per-column widths so the wheel cluster sits as a tight
    // unit (iOS style). flex/Expanded would push AM/PM far to the
    // right and leave a dead gap between minute and AM/PM.
    const hourWidth = 78.0;
    const minuteWidth = 78.0;
    const amPmWidth = 78.0;
    const columnGap = 8.0;

    final children = <Widget>[
      SizedBox(
        width: hourWidth,
        child: _Wheel(
          controller: _hourController,
          itemCount: _hourCount,
          looping: true,
          onSelectedItemChanged: _onHourChanged,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          builder: _hourLabel,
        ),
      ),
      const SizedBox(width: columnGap),
      SizedBox(
        width: minuteWidth,
        child: _Wheel(
          controller: _minuteController,
          itemCount: _minuteCount,
          looping: true,
          onSelectedItemChanged: _onMinuteChanged,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          builder: _minuteLabel,
        ),
      ),
      if (!widget.use24HourFormat) ...<Widget>[
        const SizedBox(width: columnGap),
        SizedBox(
          width: amPmWidth,
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
      ],
    ];

    final clusterWidth =
        hourWidth +
        columnGap +
        minuteWidth +
        (widget.use24HourFormat ? 0 : columnGap + amPmWidth);

    return ScrollConfiguration(
      behavior: const _AnyDeviceScrollBehavior(),
      child: SizedBox(
        height: LiqTimePicker.wheelHeight,
        child: LiqGlassSurface(
          borderRadius: BorderRadius.circular(12),
          padding: EdgeInsets.zero,
          child: Center(
            child: SizedBox(
              width: clusterWidth + 28,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _SelectionBand(palette: palette)),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

/// Allows mouse and trackpad scrolls / drags to drive the wheels on
/// non-touch platforms. Without this Flutter Web's default
/// [ScrollBehavior] only accepts touch input on `ListWheelScrollView`.
class _AnyDeviceScrollBehavior extends ScrollBehavior {
  const _AnyDeviceScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}

final class _TimePickerIndices {
  const _TimePickerIndices({
    required this.hour,
    required this.minute,
    required this.amPm,
  });

  final int hour;
  final int minute;
  final int amPm;
}

/// A single wheel column. Wraps a [ListWheelScrollView] in a
/// gradient [ShaderMask] so items above/below the centered row fade
/// out toward the edges.
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
    final palette = _TimePickerPalette.resolve(context);
    Widget itemAt(int index) {
      return Container(
        alignment: alignment,
        padding: padding,
        child: Text(
          builder(index),
          textDirection: TextDirection.ltr,
          style: LiqTimePicker.textStyle.copyWith(color: palette.text),
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

    final wheel = ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: LiqTimePicker.itemExtent,
      diameterRatio: LiqTimePicker.diameterRatio,
      squeeze: 1.08,
      useMagnifier: true,
      magnification: LiqTimePicker.magnification,
      overAndUnderCenterOpacity: 0.36,
      physics: const _PickerWheelPhysics(),
      dragStartBehavior: DragStartBehavior.down,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: childDelegate,
    );

    return LiqPointerCursor(
      cursor: SystemMouseCursors.resizeUpDown,
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback:
            (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0x00000000),
                Color(0x73000000),
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0x73000000),
                Color(0x00000000),
              ],
              // ignore: prefer_int_literals — Flutter's LinearGradient stops are doubles.
              stops: <double>[0, 0.22, 0.39, 0.61, 0.78, 1],
            ).createShader(bounds),
        child: wheel,
      ),
    );
  }
}

class _PickerWheelPhysics extends FixedExtentScrollPhysics {
  const _PickerWheelPhysics() : super(parent: const BouncingScrollPhysics());

  @override
  _PickerWheelPhysics applyTo(ScrollPhysics? ancestor) {
    return const _PickerWheelPhysics();
  }
}

/// The horizontal soft-fill band + two hairlines that frame the
/// centered row. Sits behind the wheels via a [Stack].
class _SelectionBand extends StatelessWidget {
  const _SelectionBand({required this.palette});

  final _TimePickerPalette palette;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: LiqTimePicker.itemExtent * LiqTimePicker.magnification,
            decoration: BoxDecoration(
              color: palette.selectionFill,
              borderRadius: BorderRadius.circular(8),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: palette.hairline,
                  width: LiqTimePicker.hairlineThickness,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _TimePickerPalette {
  const _TimePickerPalette({
    required this.background,
    required this.selectionFill,
    required this.hairline,
    required this.text,
  });

  factory _TimePickerPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _TimePickerPalette(
        background: LiqTimePicker.backgroundColor,
        selectionFill: LiqTimePicker.selectionFillColor,
        hairline: LiqTimePicker.hairlineColor,
        text: LiqTimePicker.textColor,
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _TimePickerPalette(
      background: secondary.withValues(alpha: 0.10),
      selectionFill: secondary.withValues(alpha: 0.14),
      hairline: secondary.withValues(alpha: 0.18),
      text: context.liqLabelColor,
    );
  }

  final Color background;
  final Color selectionFill;
  final Color hairline;
  final Color text;
}
