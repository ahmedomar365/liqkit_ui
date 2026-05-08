import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/pickers/liq_wheel_column.dart';

/// Mode axis for [LiqWheelDatePicker].
enum LiqWheelDatePickerMode {
  /// Three columns: month + day + year.
  date,

  /// Two columns: hour + minute (with optional AM/PM).
  time,

  /// Five columns: month/day/year + hour + minute (+ optional AM/PM).
  dateAndTime,

  /// Two columns: month + year.
  monthYear,
}

const List<String> _kMonthNames = <String>[
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

int _daysInMonth(int year, int month) {
  // Last day of the previous month + 1 day = first day of given month;
  // doing month + 1 day 0 lands on the last day of `month`.
  return DateTime(year, month + 1, 0).day;
}

/// iOS 26 wheel-style date / time picker built from stacked liqkit_ui
/// wheel columns. No Cupertino dependency.
final class LiqWheelDatePicker extends StatefulWidget {
  /// Creates a wheel-style date/time picker.
  const LiqWheelDatePicker({
    required this.onDateChanged,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.mode = LiqWheelDatePickerMode.dateAndTime,
    this.height = 216,
    this.use24hFormat = false,
    this.minuteInterval = 1,
    this.enableHaptics = true,
    this.brightness,
    this.tint = LiqGlassTint.opaque,
    this.minYear = 1900,
    this.maxYear = 2100,
    super.key,
  });

  /// Called every time the wheels rest on a new value.
  final ValueChanged<DateTime> onDateChanged;

  /// Initial value. Defaults to `DateTime.now()`.
  final DateTime? initialDate;

  /// Optional lower bound (inclusive). Selections are clamped above
  /// this value.
  final DateTime? minimumDate;

  /// Optional upper bound (inclusive). Selections are clamped below
  /// this value.
  final DateTime? maximumDate;

  /// Mode axis (date / time / dateAndTime / monthYear).
  final LiqWheelDatePickerMode mode;

  /// Total picker height. iOS HIG default is 216pt.
  final double height;

  /// Whether to use a 24-hour clock when [mode] involves time.
  final bool use24hFormat;

  /// Minute snap interval. iOS canonical is 1; common alternatives are 5/15.
  final int minuteInterval;

  /// Whether to fire `HapticFeedback.selectionClick()` on tick. (The
  /// underlying [LiqWheelColumn] handles haptics directly.)
  final bool enableHaptics;

  /// Override surface brightness. Defaults to the nearest LiqTheme.
  final Brightness? brightness;

  /// Glass tint preset.
  final LiqGlassTint tint;

  /// Lower bound for the year column.
  final int minYear;

  /// Upper bound for the year column.
  final int maxYear;

  @override
  State<LiqWheelDatePicker> createState() => _LiqWheelDatePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqWheelDatePickerMode>('mode', mode))
      ..add(DoubleProperty('height', height))
      ..add(IntProperty('minuteInterval', minuteInterval))
      ..add(FlagProperty('use24hFormat', value: use24hFormat, ifTrue: '24h'));
  }
}

class _LiqWheelDatePickerState extends State<LiqWheelDatePicker> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = _clamp(widget.initialDate ?? DateTime.now());
  }

  DateTime _clamp(DateTime d) {
    var v = d;
    final min = widget.minimumDate;
    final max = widget.maximumDate;
    if (min != null && v.isBefore(min)) v = min;
    if (max != null && v.isAfter(max)) v = max;
    return v;
  }

  void _setSelected(DateTime next) {
    final clamped = _clamp(next);
    if (clamped == _selected) return;
    setState(() => _selected = clamped);
    widget.onDateChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = LiqWheelTextStyle.resolve(context);
    return LiqGlassSurface(
      tint: widget.tint,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: SizedBox(
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildColumns(textStyle),
        ),
      ),
    );
  }

  Widget _buildColumns(TextStyle style) {
    switch (widget.mode) {
      case LiqWheelDatePickerMode.date:
        return _DateColumns(
          selected: _selected,
          minYear: widget.minYear,
          maxYear: widget.maxYear,
          textStyle: style,
          onChanged: _setSelected,
        );
      case LiqWheelDatePickerMode.time:
        return _TimeColumns(
          selected: _selected,
          use24h: widget.use24hFormat,
          minuteInterval: widget.minuteInterval,
          textStyle: style,
          onChanged: _setSelected,
        );
      case LiqWheelDatePickerMode.dateAndTime:
        return Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: _DateColumns(
                selected: _selected,
                minYear: widget.minYear,
                maxYear: widget.maxYear,
                textStyle: style,
                onChanged: _setSelected,
              ),
            ),
            Expanded(
              flex: 4,
              child: _TimeColumns(
                selected: _selected,
                use24h: widget.use24hFormat,
                minuteInterval: widget.minuteInterval,
                textStyle: style,
                onChanged: _setSelected,
              ),
            ),
          ],
        );
      case LiqWheelDatePickerMode.monthYear:
        return _MonthYearColumns(
          selected: _selected,
          minYear: widget.minYear,
          maxYear: widget.maxYear,
          textStyle: style,
          onChanged: _setSelected,
        );
    }
  }
}

class _DateColumns extends StatelessWidget {
  const _DateColumns({
    required this.selected,
    required this.minYear,
    required this.maxYear,
    required this.textStyle,
    required this.onChanged,
  });

  final DateTime selected;
  final int minYear;
  final int maxYear;
  final TextStyle textStyle;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final daysThisMonth = _daysInMonth(selected.year, selected.month);
    final years = <int>[for (var y = minYear; y <= maxYear; y++) y];
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: LiqWheelColumn(
            key: ValueKey<int>(selected.year * 100 + selected.month),
            initialIndex: selected.month - 1,
            itemCount: 12,
            onSelectedItemChanged: (index) {
              final newMonth = index + 1;
              final newDay =
                  selected.day.clamp(1, _daysInMonth(selected.year, newMonth));
              onChanged(DateTime(
                selected.year,
                newMonth,
                newDay,
                selected.hour,
                selected.minute,
              ));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                _kMonthNames[index],
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: LiqWheelColumn(
            key: ValueKey<String>(
                'day-${selected.year}-${selected.month}-$daysThisMonth'),
            initialIndex: (selected.day - 1).clamp(0, daysThisMonth - 1),
            itemCount: daysThisMonth,
            onSelectedItemChanged: (index) {
              onChanged(DateTime(
                selected.year,
                selected.month,
                index + 1,
                selected.hour,
                selected.minute,
              ));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                (index + 1).toString(),
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: LiqWheelColumn(
            initialIndex: (selected.year - minYear).clamp(0, years.length - 1),
            itemCount: years.length,
            onSelectedItemChanged: (index) {
              final newYear = years[index];
              final newDay = selected.day
                  .clamp(1, _daysInMonth(newYear, selected.month));
              onChanged(DateTime(
                newYear,
                selected.month,
                newDay,
                selected.hour,
                selected.minute,
              ));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                years[index].toString(),
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeColumns extends StatelessWidget {
  const _TimeColumns({
    required this.selected,
    required this.use24h,
    required this.minuteInterval,
    required this.textStyle,
    required this.onChanged,
  });

  final DateTime selected;
  final bool use24h;
  final int minuteInterval;
  final TextStyle textStyle;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final hourCount = use24h ? 24 : 12;
    final displayHour = use24h
        ? selected.hour
        : (selected.hour % 12 == 0 ? 12 : selected.hour % 12);
    final isPm = selected.hour >= 12;
    final minuteSteps = 60 ~/ minuteInterval;
    final minuteIndex = (selected.minute ~/ minuteInterval).clamp(
      0,
      minuteSteps - 1,
    );

    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: LiqWheelColumn(
            initialIndex:
                use24h ? selected.hour : displayHour - 1,
            itemCount: hourCount,
            onSelectedItemChanged: (index) {
              final h24 = use24h
                  ? index
                  : (index + 1) % 12 + (isPm ? 12 : 0);
              onChanged(DateTime(
                selected.year,
                selected.month,
                selected.day,
                h24,
                selected.minute,
              ));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                use24h
                    ? index.toString().padLeft(2, '0')
                    : (index + 1).toString(),
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: LiqWheelColumn(
            initialIndex: minuteIndex,
            itemCount: minuteSteps,
            onSelectedItemChanged: (index) {
              onChanged(DateTime(
                selected.year,
                selected.month,
                selected.day,
                selected.hour,
                index * minuteInterval,
              ));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                (index * minuteInterval).toString().padLeft(2, '0'),
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
        if (!use24h)
          Expanded(
            flex: 2,
            child: LiqWheelColumn(
              initialIndex: isPm ? 1 : 0,
              itemCount: 2,
              onSelectedItemChanged: (index) {
                final pm = index == 1;
                final base = selected.hour % 12;
                final h24 = base + (pm ? 12 : 0);
                onChanged(DateTime(
                  selected.year,
                  selected.month,
                  selected.day,
                  h24,
                  selected.minute,
                ));
              },
              itemBuilder: (context, index) => Center(
                child: Text(
                  index == 0 ? 'AM' : 'PM',
                  style: textStyle,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthYearColumns extends StatelessWidget {
  const _MonthYearColumns({
    required this.selected,
    required this.minYear,
    required this.maxYear,
    required this.textStyle,
    required this.onChanged,
  });

  final DateTime selected;
  final int minYear;
  final int maxYear;
  final TextStyle textStyle;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final years = <int>[for (var y = minYear; y <= maxYear; y++) y];
    return Row(
      children: <Widget>[
        Expanded(
          child: LiqWheelColumn(
            initialIndex: selected.month - 1,
            itemCount: 12,
            onSelectedItemChanged: (index) {
              onChanged(DateTime(selected.year, index + 1));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                _kMonthNames[index],
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
        Expanded(
          child: LiqWheelColumn(
            initialIndex:
                (selected.year - minYear).clamp(0, years.length - 1),
            itemCount: years.length,
            onSelectedItemChanged: (index) {
              onChanged(DateTime(years[index], selected.month));
            },
            itemBuilder: (context, index) => Center(
              child: Text(
                years[index].toString(),
                style: textStyle,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Modal-bottom-sheet variant — opens [LiqWheelDatePicker] with a
/// Cancel / Done header. Returns the picked `DateTime` (or `null` if
/// dismissed via Cancel).
extension LiqWheelDatePickerModal on LiqWheelDatePicker {
  /// Show as a modal bottom sheet.
  static Future<DateTime?> showModal({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    LiqWheelDatePickerMode mode = LiqWheelDatePickerMode.date,
    bool use24hFormat = false,
    int minuteInterval = 1,
    String cancelLabel = 'Cancel',
    String doneLabel = 'Done',
  }) async {
    var staged = initialDate ?? DateTime.now();
    return Navigator.of(context).push<DateTime?>(
      _LiqWheelDateModalRoute(
        builder: (modalContext) => _ModalShell(
          cancelLabel: cancelLabel,
          doneLabel: doneLabel,
          onCancel: () => Navigator.of(modalContext).pop<DateTime?>(),
          onDone: () => Navigator.of(modalContext).pop<DateTime>(staged),
          child: LiqWheelDatePicker(
            initialDate: staged,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            mode: mode,
            use24hFormat: use24hFormat,
            minuteInterval: minuteInterval,
            onDateChanged: (next) => staged = next,
          ),
        ),
      ),
    );
  }
}

class _ModalShell extends StatelessWidget {
  const _ModalShell({
    required this.cancelLabel,
    required this.doneLabel,
    required this.onCancel,
    required this.onDone,
    required this.child,
  });

  final String cancelLabel;
  final String doneLabel;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 56,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onCancel,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        cancelLabel,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 17,
                          color: Color(0xFFFF383C),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onDone,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        doneLabel,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0088FF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _LiqWheelDateModalRoute extends ModalRoute<DateTime?> {
  _LiqWheelDateModalRoute({required this.builder});

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => const Color(0x66000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'date picker';

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: builder(context),
    );
  }
}
