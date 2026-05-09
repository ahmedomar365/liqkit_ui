import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class PickerDemoScreen extends ConsumerStatefulWidget {
  const PickerDemoScreen({super.key});

  @override
  ConsumerState<PickerDemoScreen> createState() => _PickerDemoScreenState();
}

class _PickerDemoScreenState extends ConsumerState<PickerDemoScreen> {
  String? _selectedCountry = 'United States';
  List<int> _multiColumnSelection = <int>[0, 0, 0];
  int _selectedNumber = 25;
  double _weight = 70.5;
  double _height = 175.0;
  DateTime? _selectedDate;
  DateTime? _selectedTime;
  DateTime? _selectedDateTime;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Duration _selectedDuration = const Duration(hours: 1, minutes: 30);

  static const List<LiqPickerItem<String>> _countries =
      <LiqPickerItem<String>>[
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

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Pickers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Single Column',
              description:
                  'Tap to open a sheet that lets the user pick a single value from a list.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LiqPickerButton<String>(
                    items: _countries,
                    selectedValue: _selectedCountry,
                    label: 'Country',
                    placeholder: 'Select Country',
                    modalTitle: 'Choose Country',
                    onValueSelected: (v) =>
                        setState(() => _selectedCountry = v),
                  ),
                  if (_selectedCountry != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(
                      'Selected: $_selectedCountry',
                      style: context.textStyles.body.secondary,
                    ),
                  ],
                ],
              ),
            ),
            _Section(
              title: 'Multi Column',
              description:
                  'Select related values across multiple columns (month / day / year).',
              child: SizedBox(
                height: 240,
                child: LiqMultiColumnPicker(
                  columnWidthRatios: const <double>[2, 1, 1.5],
                  selectedIndices: _multiColumnSelection,
                  onSelectionChanged: (indices) =>
                      setState(() => _multiColumnSelection = indices),
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
              ),
            ),
            _Section(
              title: 'Number',
              description:
                  'Stepper-style number picker with configurable min/max/step.',
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: LiqNumberPicker(
                      minValue: 0,
                      maxValue: 100,
                      selectedValue: _selectedNumber,
                      step: 5,
                      onValueChanged: (v) =>
                          setState(() => _selectedNumber = v),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Selected: $_selectedNumber',
                    style: context.textStyles.headline,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Measurement',
              description:
                  'Decimal-precision pickers for measurements with units.',
              child: Column(
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
              ),
            ),
            _Section(
              title: 'Inline Date Wheel — Date Mode',
              description:
                  'Wheel-style date picker rendered inline (month / day / '
                  'year columns).',
              child: SizedBox(
                height: 220,
                child: LiqWheelDatePicker(
                  initialDate: _selectedDate ?? DateTime.now(),
                  mode: LiqWheelDatePickerMode.date,
                  onDateChanged: (d) => setState(() => _selectedDate = d),
                ),
              ),
            ),
            _Section(
              title: 'Inline Date Wheel — Time Mode',
              description: 'Hour / minute (and AM/PM) columns only.',
              child: SizedBox(
                height: 220,
                child: LiqWheelDatePicker(
                  initialDate: _selectedTime ?? DateTime.now(),
                  mode: LiqWheelDatePickerMode.time,
                  onDateChanged: (d) => setState(() => _selectedTime = d),
                ),
              ),
            ),
            _Section(
              title: 'Inline Date Wheel — Date & Time Mode',
              description: 'Combined date columns + hour / minute columns.',
              child: SizedBox(
                height: 220,
                child: LiqWheelDatePicker(
                  initialDate: _selectedDateTime ?? DateTime.now(),
                  mode: LiqWheelDatePickerMode.dateAndTime,
                  onDateChanged: (d) =>
                      setState(() => _selectedDateTime = d),
                ),
              ),
            ),
            _Section(
              title: 'Inline Date Wheel — Month + Year Mode',
              description:
                  'Month + year only — common for credit-card expiry pickers.',
              child: SizedBox(
                height: 220,
                child: LiqWheelDatePicker(
                  initialDate: _selectedDate ?? DateTime.now(),
                  mode: LiqWheelDatePickerMode.monthYear,
                  onDateChanged: (d) => setState(() => _selectedDate = d),
                ),
              ),
            ),
            _Section(
              title: 'Inline Date Wheel — 24-Hour Format',
              description: 'Pass `use24hFormat: true` to drop AM/PM.',
              child: SizedBox(
                height: 220,
                child: LiqWheelDatePicker(
                  initialDate: _selectedTime ?? DateTime.now(),
                  mode: LiqWheelDatePickerMode.time,
                  use24hFormat: true,
                  onDateChanged: (d) => setState(() => _selectedTime = d),
                ),
              ),
            ),
            _Section(
              title: 'Date / Time / Date+Time Buttons',
              description:
                  'List-row triggers that open a date wheel sheet from the bottom.',
              child: LiqListGroup(
                rows: <LiqListRow>[
                  LiqListRow(
                    title: 'Date',
                    trailing: Text(
                      _selectedDate == null
                          ? 'Pick'
                          : _formatDate(_selectedDate!),
                      style: TextStyle(
                        fontSize: 15,
                        color: context.appleColors.secondaryLabel,
                      ),
                    ),
                    showChevron: true,
                    onTap: () async {
                      final picked = await _pickDate(_selectedDate);
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                  LiqListRow(
                    title: 'Time',
                    trailing: Text(
                      _selectedTime == null
                          ? 'Pick'
                          : _formatTime(_selectedTime!),
                      style: TextStyle(
                        fontSize: 15,
                        color: context.appleColors.secondaryLabel,
                      ),
                    ),
                    showChevron: true,
                    onTap: () async {
                      final picked = await _pickDate(
                        _selectedTime,
                        mode: LiqWheelDatePickerMode.time,
                      );
                      if (picked != null) {
                        setState(() => _selectedTime = picked);
                      }
                    },
                  ),
                  LiqListRow(
                    title: 'Date & Time',
                    trailing: Text(
                      _selectedDateTime == null
                          ? 'Pick'
                          : '${_formatDate(_selectedDateTime!)} • ${_formatTime(_selectedDateTime!)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: context.appleColors.secondaryLabel,
                      ),
                    ),
                    showChevron: true,
                    onTap: () async {
                      final picked = await _pickDate(
                        _selectedDateTime,
                        mode: LiqWheelDatePickerMode.dateAndTime,
                      );
                      if (picked != null) {
                        setState(() => _selectedDateTime = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Date Range',
              description: 'Two coupled date pickers selecting a start and end.',
              child: LiqListGroup(
                rows: <LiqListRow>[
                  LiqListRow(
                    title: 'Start Date',
                    trailing: Text(
                      _rangeStart == null
                          ? 'Pick a date'
                          : _formatDate(_rangeStart!),
                      style: TextStyle(
                        fontSize: 15,
                        color: context.appleColors.secondaryLabel,
                      ),
                    ),
                    showChevron: true,
                    onTap: () async {
                      final picked = await _pickDate(_rangeStart);
                      if (picked != null) {
                        setState(() => _rangeStart = picked);
                      }
                    },
                  ),
                  LiqListRow(
                    title: 'End Date',
                    trailing: Text(
                      _rangeEnd == null
                          ? 'Pick a date'
                          : _formatDate(_rangeEnd!),
                      style: TextStyle(
                        fontSize: 15,
                        color: context.appleColors.secondaryLabel,
                      ),
                    ),
                    showChevron: true,
                    onTap: () async {
                      final picked = await _pickDate(_rangeEnd);
                      if (picked != null) setState(() => _rangeEnd = picked);
                    },
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Timer — Hours + Minutes + Seconds',
              description:
                  'Countdown duration picker with `LiqTimerPickerMode.hms`.',
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 320,
                    height: 180,
                    child: LiqTimerPicker(
                      initialDuration: _selectedDuration,
                      mode: LiqTimerPickerMode.hms,
                      onDurationChanged: (d) =>
                          setState(() => _selectedDuration = d),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatDuration(_selectedDuration),
                    style: context.textStyles.headline,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Timer — Hours + Minutes',
              description:
                  '`LiqTimerPickerMode.hm` — when seconds aren\'t relevant '
                  '(e.g. cooking, focus timers).',
              child: SizedBox(
                width: 320,
                height: 180,
                child: LiqTimerPicker(
                  initialDuration: const Duration(hours: 1, minutes: 30),
                  mode: LiqTimerPickerMode.hm,
                  onDurationChanged: (_) {},
                ),
              ),
            ),
            _Section(
              title: 'Timer — Minutes + Seconds',
              description:
                  '`LiqTimerPickerMode.ms` — short stopwatch-style durations.',
              child: SizedBox(
                width: 320,
                height: 180,
                child: LiqTimerPicker(
                  initialDuration: const Duration(minutes: 5, seconds: 30),
                  mode: LiqTimerPickerMode.ms,
                  onDurationChanged: (_) {},
                ),
              ),
            ),
            _Section(
              title: 'Timer — Custom Minute Interval',
              description:
                  'Pass `minuteInterval: 5` (or 15 / 30) to step minutes.',
              child: SizedBox(
                width: 320,
                height: 180,
                child: LiqTimerPicker(
                  initialDuration: const Duration(hours: 0, minutes: 15),
                  minuteInterval: 5,
                  onDurationChanged: (_) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(
    DateTime? initial, {
    LiqWheelDatePickerMode mode = LiqWheelDatePickerMode.date,
  }) async {
    var picked = initial ?? DateTime.now();
    final result = await Navigator.of(context).push<DateTime>(
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
    return result;
  }

  String _monthName(int month) {
    const months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime d) {
    final h = (d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour))
        .toString();
    final m = d.minute.toString().padLeft(2, '0');
    final period = d.hour < 12 ? ' AM' : ' PM';
    return '$h:$m$period';
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    final s = duration.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
