/// Canonical picker variants — single source of truth for the showcase
/// app and the liqkit.com docs previews.
///
/// Every widget here is a faithful, self-contained reproduction of one
/// `_Section(...)` from `apps/showcase_app/lib/screens/demos/picker_demo_screen.dart`.
/// Edits propagate to both the App Store app and the docs site on the
/// next build.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/lists/liq_list.dart';
import 'package:liqkit_ui/src/components/pickers/liq_picker_extras.dart';
import 'package:liqkit_ui/src/components/pickers/liq_wheel_date_picker.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';

// ─── Single Column ──────────────────────────────────────────────────────────

const List<LiqPickerItem<String>> _kCountries = <LiqPickerItem<String>>[
  LiqPickerItem(value: 'United States', label: 'United States'),
  LiqPickerItem(value: 'Canada', label: 'Canada'),
  LiqPickerItem(value: 'Mexico', label: 'Mexico'),
  LiqPickerItem(value: 'United Kingdom', label: 'United Kingdom'),
  LiqPickerItem(value: 'France', label: 'France'),
  LiqPickerItem(value: 'Germany', label: 'Germany'),
  LiqPickerItem(value: 'Japan', label: 'Japan'),
  LiqPickerItem(value: 'China', label: 'China'),
  LiqPickerItem(value: 'India', label: 'India'),
  LiqPickerItem(value: 'Brazil', label: 'Brazil'),
];

/// Tap-to-open single-value picker. Opens a sheet of [_kCountries].
final class PickerSingleColumnExample extends StatefulWidget {
  const PickerSingleColumnExample({super.key});

  @override
  State<PickerSingleColumnExample> createState() =>
      _PickerSingleColumnExampleState();
}

class _PickerSingleColumnExampleState extends State<PickerSingleColumnExample> {
  String? _selected = 'United States';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LiqPickerButton<String>(
          items: _kCountries,
          selectedValue: _selected,
          label: 'Country',
          placeholder: 'Select Country',
          modalTitle: 'Choose Country',
          onValueSelected: (v) => setState(() => _selected = v),
        ),
        if (_selected != null) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            'Selected: $_selected',
            style: context.textStyles.body.secondary,
          ),
        ],
      ],
    );
  }
}

// ─── Multi Column ───────────────────────────────────────────────────────────

/// Three-column wheel picker (month / day / year).
final class PickerMultiColumnExample extends StatefulWidget {
  const PickerMultiColumnExample({super.key});

  @override
  State<PickerMultiColumnExample> createState() =>
      _PickerMultiColumnExampleState();
}

class _PickerMultiColumnExampleState extends State<PickerMultiColumnExample> {
  List<int> _indices = <int>[0, 0, 0];

  static String _monthName(int m) => const <String>[
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ][m - 1];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: LiqMultiColumnPicker(
        columnWidthRatios: const <double>[2, 1, 1.5],
        selectedIndices: _indices,
        onSelectionChanged: (i) => setState(() => _indices = i),
        columns: <List<LiqPickerItem<dynamic>>>[
          <LiqPickerItem<int>>[
            for (var i = 0; i < 12; i++)
              LiqPickerItem<int>(value: i, label: _monthName(i + 1)),
          ],
          <LiqPickerItem<int>>[
            for (var i = 0; i < 31; i++)
              LiqPickerItem<int>(value: i, label: '${i + 1}'),
          ],
          <LiqPickerItem<int>>[
            for (var i = 0; i < 10; i++)
              LiqPickerItem<int>(value: i, label: '${2020 + i}'),
          ],
        ],
      ),
    );
  }
}

// ─── Number ─────────────────────────────────────────────────────────────────

/// Stepper-style number picker, configurable min/max/step.
final class PickerNumberExample extends StatefulWidget {
  const PickerNumberExample({super.key});

  @override
  State<PickerNumberExample> createState() => _PickerNumberExampleState();
}

class _PickerNumberExampleState extends State<PickerNumberExample> {
  int _value = 25;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 200,
          child: LiqNumberPicker(
            minValue: 0,
            maxValue: 100,
            selectedValue: _value,
            step: 5,
            onValueChanged: (v) => setState(() => _value = v),
          ),
        ),
        const SizedBox(height: 12),
        Text('Selected: $_value', style: context.textStyles.headline),
      ],
    );
  }
}

// ─── Measurement ────────────────────────────────────────────────────────────

/// Decimal-precision pickers for measurements (weight + height).
final class PickerMeasurementExample extends StatefulWidget {
  const PickerMeasurementExample({super.key});

  @override
  State<PickerMeasurementExample> createState() =>
      _PickerMeasurementExampleState();
}

class _PickerMeasurementExampleState extends State<PickerMeasurementExample> {
  double _weight = 70.5;
  double _height = 175;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Weight', style: context.textStyles.body.secondary),
        const SizedBox(height: 8),
        SizedBox(
          width: 220,
          child: LiqMeasurementPicker(
            value: _weight,
            minValue: 30,
            maxValue: 200,
            unit: 'kg',
            onValueChanged: (v) => setState(() => _weight = v),
          ),
        ),
        const SizedBox(height: 16),
        Text('Height', style: context.textStyles.body.secondary),
        const SizedBox(height: 8),
        SizedBox(
          width: 220,
          child: LiqMeasurementPicker(
            value: _height,
            minValue: 100,
            maxValue: 250,
            unit: 'cm',
            onValueChanged: (v) => setState(() => _height = v),
          ),
        ),
      ],
    );
  }
}

// ─── Inline Date Wheel × 5 modes ────────────────────────────────────────────

/// Wheel-style date picker rendered inline (month / day / year).
final class PickerWheelDateExample extends StatefulWidget {
  const PickerWheelDateExample({super.key});

  @override
  State<PickerWheelDateExample> createState() => _PickerWheelDateExampleState();
}

class _PickerWheelDateExampleState extends State<PickerWheelDateExample> {
  late DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LiqWheelDatePicker(
        initialDate: _date,
        onDateChanged: (d) => setState(() => _date = d),
      ),
    );
  }
}

/// Time-only wheel — hour / minute (and AM/PM) columns.
final class PickerWheelTimeExample extends StatefulWidget {
  const PickerWheelTimeExample({super.key});

  @override
  State<PickerWheelTimeExample> createState() => _PickerWheelTimeExampleState();
}

class _PickerWheelTimeExampleState extends State<PickerWheelTimeExample> {
  late DateTime _time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LiqWheelDatePicker(
        initialDate: _time,
        mode: LiqWheelDatePickerMode.time,
        onDateChanged: (d) => setState(() => _time = d),
      ),
    );
  }
}

/// Combined date + time columns.
final class PickerWheelDateTimeExample extends StatefulWidget {
  const PickerWheelDateTimeExample({super.key});

  @override
  State<PickerWheelDateTimeExample> createState() =>
      _PickerWheelDateTimeExampleState();
}

class _PickerWheelDateTimeExampleState
    extends State<PickerWheelDateTimeExample> {
  late DateTime _value = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LiqWheelDatePicker(
        initialDate: _value,
        mode: LiqWheelDatePickerMode.dateAndTime,
        onDateChanged: (d) => setState(() => _value = d),
      ),
    );
  }
}

/// Month + year only — common for credit-card expiry pickers.
final class PickerWheelMonthYearExample extends StatefulWidget {
  const PickerWheelMonthYearExample({super.key});

  @override
  State<PickerWheelMonthYearExample> createState() =>
      _PickerWheelMonthYearExampleState();
}

class _PickerWheelMonthYearExampleState
    extends State<PickerWheelMonthYearExample> {
  late DateTime _value = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LiqWheelDatePicker(
        initialDate: _value,
        mode: LiqWheelDatePickerMode.monthYear,
        onDateChanged: (d) => setState(() => _value = d),
      ),
    );
  }
}

/// 24-hour-format time wheel (no AM/PM).
final class PickerWheelTime24hExample extends StatefulWidget {
  const PickerWheelTime24hExample({super.key});

  @override
  State<PickerWheelTime24hExample> createState() =>
      _PickerWheelTime24hExampleState();
}

class _PickerWheelTime24hExampleState extends State<PickerWheelTime24hExample> {
  late DateTime _value = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LiqWheelDatePicker(
        initialDate: _value,
        mode: LiqWheelDatePickerMode.time,
        use24hFormat: true,
        onDateChanged: (d) => setState(() => _value = d),
      ),
    );
  }
}

// ─── Modal trigger sheet (shared) ───────────────────────────────────────────

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _formatTime(DateTime d) {
  final h =
      (d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour)).toString();
  final m = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? ' AM' : ' PM';
  return '$h:$m$period';
}

Future<DateTime?> _pickDate(
  BuildContext context,
  DateTime? initial, {
  LiqWheelDatePickerMode mode = LiqWheelDatePickerMode.date,
}) async {
  var picked = initial ?? DateTime.now();
  return Navigator.of(context).push<DateTime>(
    PageRouteBuilder<DateTime>(
      opaque: false,
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, animation, secondary) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: LiqGlassSurface(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(28)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        LiqWheelDatePicker(
                          initialDate: picked,
                          mode: mode,
                          onDateChanged: (d) => picked = d,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: LiqButton(
                                label: 'Cancel',
                                style: LiqButtonStyle.borderedSecondary,
                                onPressed: () =>
                                    Navigator.of(ctx).pop<DateTime>(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: LiqButton(
                                label: 'Done',
                                onPressed: () =>
                                    Navigator.of(ctx).pop<DateTime>(picked),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

// ─── Date / Time / Date+Time trigger buttons ────────────────────────────────

/// List-row triggers that open a date wheel sheet from the bottom.
final class PickerTriggerButtonsExample extends StatefulWidget {
  const PickerTriggerButtonsExample({super.key});

  @override
  State<PickerTriggerButtonsExample> createState() =>
      _PickerTriggerButtonsExampleState();
}

class _PickerTriggerButtonsExampleState
    extends State<PickerTriggerButtonsExample> {
  DateTime? _date;
  DateTime? _time;
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final trailing = TextStyle(
      fontSize: 15,
      color: context.appleColors.secondaryLabel,
    );
    return LiqListGroup(
      rows: <LiqListRow>[
        LiqListRow(
          title: 'Date',
          trailing: Text(
            _date == null ? 'Pick' : _formatDate(_date!),
            style: trailing,
          ),
          showChevron: true,
          onTap: () async {
            final picked = await _pickDate(context, _date);
            if (picked != null) setState(() => _date = picked);
          },
        ),
        LiqListRow(
          title: 'Time',
          trailing: Text(
            _time == null ? 'Pick' : _formatTime(_time!),
            style: trailing,
          ),
          showChevron: true,
          onTap: () async {
            final picked = await _pickDate(
              context,
              _time,
              mode: LiqWheelDatePickerMode.time,
            );
            if (picked != null) setState(() => _time = picked);
          },
        ),
        LiqListRow(
          title: 'Date & Time',
          trailing: Text(
            _dateTime == null
                ? 'Pick'
                : '${_formatDate(_dateTime!)} • ${_formatTime(_dateTime!)}',
            style: trailing,
          ),
          showChevron: true,
          onTap: () async {
            final picked = await _pickDate(
              context,
              _dateTime,
              mode: LiqWheelDatePickerMode.dateAndTime,
            );
            if (picked != null) setState(() => _dateTime = picked);
          },
        ),
      ],
    );
  }
}

// ─── Date Range ─────────────────────────────────────────────────────────────

/// Two coupled list-row triggers selecting a start and end date.
final class PickerDateRangeExample extends StatefulWidget {
  const PickerDateRangeExample({super.key});

  @override
  State<PickerDateRangeExample> createState() =>
      _PickerDateRangeExampleState();
}

class _PickerDateRangeExampleState extends State<PickerDateRangeExample> {
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    final trailing = TextStyle(
      fontSize: 15,
      color: context.appleColors.secondaryLabel,
    );
    return LiqListGroup(
      rows: <LiqListRow>[
        LiqListRow(
          title: 'Start Date',
          trailing: Text(
            _start == null ? 'Pick a date' : _formatDate(_start!),
            style: trailing,
          ),
          showChevron: true,
          onTap: () async {
            final picked = await _pickDate(context, _start);
            if (picked != null) setState(() => _start = picked);
          },
        ),
        LiqListRow(
          title: 'End Date',
          trailing: Text(
            _end == null ? 'Pick a date' : _formatDate(_end!),
            style: trailing,
          ),
          showChevron: true,
          onTap: () async {
            final picked = await _pickDate(context, _end);
            if (picked != null) setState(() => _end = picked);
          },
        ),
      ],
    );
  }
}

// ─── Timer pickers (4 modes) ────────────────────────────────────────────────

String _formatDuration(Duration duration) {
  final h = duration.inHours;
  final m = duration.inMinutes % 60;
  final s = duration.inSeconds % 60;
  if (h > 0) return '${h}h ${m}m ${s}s';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}

/// Countdown picker — hours + minutes + seconds.
final class PickerTimerHmsExample extends StatefulWidget {
  const PickerTimerHmsExample({super.key});

  @override
  State<PickerTimerHmsExample> createState() => _PickerTimerHmsExampleState();
}

class _PickerTimerHmsExampleState extends State<PickerTimerHmsExample> {
  Duration _value = const Duration(hours: 1, minutes: 30);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 320,
          height: 180,
          child: LiqTimerPicker(
            initialDuration: _value,
            onDurationChanged: (d) => setState(() => _value = d),
          ),
        ),
        const SizedBox(height: 12),
        Text(_formatDuration(_value), style: context.textStyles.headline),
      ],
    );
  }
}

/// Countdown picker — hours + minutes (when seconds aren't relevant).
final class PickerTimerHmExample extends StatelessWidget {
  const PickerTimerHmExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: LiqTimerPicker(
        initialDuration: const Duration(hours: 1, minutes: 30),
        mode: LiqTimerPickerMode.hm,
        onDurationChanged: (_) {},
      ),
    );
  }
}

/// Stopwatch-style picker — minutes + seconds.
final class PickerTimerMsExample extends StatelessWidget {
  const PickerTimerMsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: LiqTimerPicker(
        initialDuration: const Duration(minutes: 5, seconds: 30),
        mode: LiqTimerPickerMode.ms,
        onDurationChanged: (_) {},
      ),
    );
  }
}

/// Hour/minute timer with a custom 5-minute interval.
final class PickerTimerIntervalExample extends StatelessWidget {
  const PickerTimerIntervalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: LiqTimerPicker(
        initialDuration: const Duration(minutes: 15),
        minuteInterval: 5,
        onDurationChanged: (_) {},
      ),
    );
  }
}
