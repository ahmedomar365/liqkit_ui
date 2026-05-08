import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/lists/liq_list.dart';
import 'package:liqkit_ui/src/components/pickers/liq_wheel_column.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Mode controlling which columns appear in [LiqTimerPicker].
///
/// Native to liqkit_ui — no Cupertino dependency.
enum LiqTimerPickerMode {
  /// Hours + minutes columns.
  hm,

  /// Minutes + seconds columns.
  ms,

  /// Hours + minutes + seconds columns.
  hms,
}

/// One selectable entry in [LiqPickerButton] / [LiqMultiColumnPicker].
@immutable
class LiqPickerItem<T> {
  /// Creates a picker item.
  const LiqPickerItem({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final Widget? icon;
}

/// Row-style trigger that opens a single-column picker sheet.
final class LiqPickerButton<T> extends StatelessWidget with Diagnosticable {
  /// Creates a picker button.
  const LiqPickerButton({
    required this.items,
    required this.onValueSelected,
    this.selectedValue,
    this.label,
    this.placeholder = 'Select…',
    this.modalTitle,
    super.key,
  });

  final List<LiqPickerItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T?> onValueSelected;
  final String? label;
  final String placeholder;
  final String? modalTitle;

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere(
      (i) => i.value == selectedValue,
      orElse: () => LiqPickerItem<T>(
        value: selectedValue as T,
        label: placeholder,
      ),
    );
    return LiqListRow(
      title: label ?? '',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            selectedValue == null ? placeholder : selectedItem.label,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
      showChevron: true,
      onTap: () => _open(context),
    );
  }

  Future<void> _open(BuildContext context) async {
    final result = await Navigator.of(context).push<T>(
      _LiqPickerSheetRoute<T>(
        items: items,
        title: modalTitle ?? label ?? 'Select',
        initialValue: selectedValue,
      ),
    );
    if (result != null) onValueSelected(result);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(IntProperty('itemCount', items.length));
  }
}

class _LiqPickerSheetRoute<T> extends ModalRoute<T> {
  _LiqPickerSheetRoute({
    required this.items,
    required this.title,
    required this.initialValue,
  });

  final List<LiqPickerItem<T>> items;
  final String title;
  final T? initialValue;

  @override
  Color? get barrierColor => const Color(0x66000000);
  @override
  bool get barrierDismissible => true;
  @override
  String? get barrierLabel => 'picker';
  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 240);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
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
              child: _LiqPickerSheetBody<T>(
                items: items,
                title: title,
                initialValue: initialValue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiqPickerSheetBody<T> extends StatefulWidget {
  const _LiqPickerSheetBody({
    required this.items,
    required this.title,
    required this.initialValue,
  });

  final List<LiqPickerItem<T>> items;
  final String title;
  final T? initialValue;

  @override
  State<_LiqPickerSheetBody<T>> createState() => _LiqPickerSheetBodyState<T>();
}

class _LiqPickerSheetBodyState<T> extends State<_LiqPickerSheetBody<T>> {
  late T? _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleStyle = LiqAppleTypography.headline(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    return LiqGlassSurface(
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(widget.title,
                textAlign: TextAlign.center, style: titleStyle),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return LiqListRow(
                  title: item.label,
                  leading: item.icon,
                  selected: item.value == _value,
                  onTap: () => setState(() => _value = item.value),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: LiqButton(
                  label: 'Cancel',
                  style: LiqButtonStyle.borderedSecondary,
                  onPressed: () => Navigator.of(context).pop<T>(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LiqButton(
                  label: 'Done',
                  onPressed: _value == null
                      ? null
                      : () => Navigator.of(context).pop<T>(_value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Wheel-style integer picker.
final class LiqNumberPicker extends StatelessWidget with Diagnosticable {
  /// Creates a number picker.
  const LiqNumberPicker({
    required this.selectedValue,
    required this.onValueChanged,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    this.height = 180,
    this.itemExtent = 32,
    super.key,
  });

  final int selectedValue;
  final ValueChanged<int> onValueChanged;
  final int minValue;
  final int maxValue;
  final int step;
  final double height;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    final values = <int>[
      for (var v = minValue; v <= maxValue; v += step) v,
    ];
    final initialIndex =
        values.indexOf(selectedValue).clamp(0, values.length - 1);
    final textStyle = LiqWheelTextStyle.resolve(context);
    return SizedBox(
      height: height,
      child: LiqWheelColumn(
        initialIndex: initialIndex,
        itemExtent: itemExtent,
        itemCount: values.length,
        onSelectedItemChanged: (index) => onValueChanged(values[index]),
        itemBuilder: (context, index) => Center(
          child: Text(
            values[index].toString(),
            style: textStyle,
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('selectedValue', selectedValue))
      ..add(IntProperty('min', minValue))
      ..add(IntProperty('max', maxValue));
  }
}

/// Wheel-style decimal picker with a unit suffix.
final class LiqMeasurementPicker extends StatelessWidget
    with Diagnosticable {
  /// Creates a measurement picker.
  const LiqMeasurementPicker({
    required this.value,
    required this.onValueChanged,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    this.step = 0.5,
    this.height = 180,
    super.key,
  });

  final double value;
  final ValueChanged<double> onValueChanged;
  final double minValue;
  final double maxValue;
  final String unit;
  final double step;
  final double height;

  @override
  Widget build(BuildContext context) {
    final values = <double>[];
    for (var v = minValue; v <= maxValue + 0.0001; v += step) {
      values.add(double.parse(v.toStringAsFixed(2)));
    }
    final initialIndex = values
        .indexWhere((v) => (v - value).abs() < step / 2)
        .clamp(0, values.length - 1);
    final textStyle = LiqWheelTextStyle.resolve(context);
    return SizedBox(
      height: height,
      child: LiqWheelColumn(
        initialIndex: initialIndex,
        itemCount: values.length,
        onSelectedItemChanged: (index) => onValueChanged(values[index]),
        itemBuilder: (context, index) => Center(
          child: Text(
            '${values[index].toStringAsFixed(1)} $unit',
            style: textStyle,
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(StringProperty('unit', unit));
  }
}

/// Two-column date range picker (Start + End). Each column opens a
/// `LiqWheelDatePicker` modal sheet.
final class LiqDateRangePicker extends StatelessWidget with Diagnosticable {
  /// Creates a date range picker.
  const LiqDateRangePicker({
    required this.onRangeChanged,
    this.startDate,
    this.endDate,
    this.startLabel = 'Start',
    this.endLabel = 'End',
    super.key,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime? start, DateTime? end) onRangeChanged;
  final String startLabel;
  final String endLabel;

  @override
  Widget build(BuildContext context) {
    return LiqListGroup(
      rows: <LiqListRow>[
        LiqListRow(
          title: startLabel,
          trailing: Text(
            startDate == null
                ? 'Pick a date'
                : _formatDate(startDate!),
            style: const TextStyle(fontSize: 15),
          ),
          showChevron: true,
          onTap: () {
            // Caller handles modal — emit a tap so consumers can
            // wire any picker they like.
            onRangeChanged(startDate, endDate);
          },
        ),
        LiqListRow(
          title: endLabel,
          trailing: Text(
            endDate == null ? 'Pick a date' : _formatDate(endDate!),
            style: const TextStyle(fontSize: 15),
          ),
          showChevron: true,
          onTap: () {
            onRangeChanged(startDate, endDate);
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('startDate', startDate))
      ..add(DiagnosticsProperty<DateTime?>('endDate', endDate));
  }
}

/// iOS-26 timer/duration picker built from stacked liqkit_ui wheel
/// columns. No Cupertino dependency.
///
/// Each numeric column is followed by a unit label (`hours` / `min` /
/// `sec`) so users see "1 hour 30 min" instead of bare numbers.
final class LiqTimerPicker extends StatefulWidget with Diagnosticable {
  /// Creates a timer picker.
  const LiqTimerPicker({
    required this.initialDuration,
    required this.onDurationChanged,
    this.mode = LiqTimerPickerMode.hms,
    this.minuteInterval = 1,
    this.secondInterval = 1,
    this.height = 216,
    super.key,
  });

  /// Starting duration. The wheels rest on the matching rows.
  final Duration initialDuration;

  /// Selection callback fired each time any wheel settles.
  final ValueChanged<Duration> onDurationChanged;

  /// Which columns to display.
  final LiqTimerPickerMode mode;

  /// Step between minute rows.
  final int minuteInterval;

  /// Step between second rows.
  final int secondInterval;

  /// Total picker height.
  final double height;

  @override
  State<LiqTimerPicker> createState() => _LiqTimerPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>('initialDuration', initialDuration))
      ..add(EnumProperty<LiqTimerPickerMode>('mode', mode));
  }
}

class _LiqTimerPickerState extends State<LiqTimerPicker> {
  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialDuration.inHours;
    _minute = widget.initialDuration.inMinutes.remainder(60);
    _second = widget.initialDuration.inSeconds.remainder(60);
  }

  void _emit() {
    widget.onDurationChanged(
      Duration(hours: _hour, minutes: _minute, seconds: _second),
    );
  }

  Widget _column({
    required int valueCount,
    required int step,
    required int initial,
    required String unitShort,
    required ValueChanged<int> onChanged,
    required TextStyle textStyle,
  }) {
    final values = <int>[for (var v = 0; v < valueCount; v += step) v];
    final initialIndex =
        (initial ~/ step).clamp(0, values.length - 1);
    return Expanded(
      child: LiqWheelColumn(
        initialIndex: initialIndex,
        itemCount: values.length,
        itemExtent: 36,
        onSelectedItemChanged: (index) {
          onChanged(values[index]);
          _emit();
        },
        itemBuilder: (context, index) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  values[index].toString().padLeft(2, '0'),
                  style: textStyle,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(width: 6),
                Text(
                  unitShort,
                  style: textStyle.copyWith(
                    fontSize: textStyle.fontSize! - 4,
                    color: textStyle.color!.withValues(alpha: 0.6),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = LiqWheelTextStyle.resolve(context);
    final showHours = widget.mode == LiqTimerPickerMode.hm ||
        widget.mode == LiqTimerPickerMode.hms;
    final showSeconds = widget.mode == LiqTimerPickerMode.ms ||
        widget.mode == LiqTimerPickerMode.hms;
    return SizedBox(
      height: widget.height,
      child: Row(
        children: <Widget>[
          if (showHours)
            _column(
              valueCount: 24,
              step: 1,
              initial: _hour,
              unitShort: 'hour',
              textStyle: textStyle,
              onChanged: (v) => _hour = v,
            ),
          _column(
            valueCount: 60,
            step: widget.minuteInterval,
            initial: _minute,
            unitShort: 'min',
            textStyle: textStyle,
            onChanged: (v) => _minute = v,
          ),
          if (showSeconds)
            _column(
              valueCount: 60,
              step: widget.secondInterval,
              initial: _second,
              unitShort: 'sec',
              textStyle: textStyle,
              onChanged: (v) => _second = v,
            ),
        ],
      ),
    );
  }
}

/// Multi-column wheel picker — N independent CupertinoPicker columns
/// with optional `columnWidthRatios` for layout weighting.
final class LiqMultiColumnPicker extends StatelessWidget with Diagnosticable {
  /// Creates a multi-column picker.
  const LiqMultiColumnPicker({
    required this.columns,
    required this.selectedIndices,
    required this.onSelectionChanged,
    this.columnWidthRatios,
    this.height = 216,
    this.itemExtent = 32,
    super.key,
  });

  final List<List<LiqPickerItem<dynamic>>> columns;
  final List<int> selectedIndices;
  final ValueChanged<List<int>> onSelectionChanged;
  final List<double>? columnWidthRatios;
  final double height;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    final ratios =
        columnWidthRatios ?? List<double>.filled(columns.length, 1);
    final textStyle = LiqWheelTextStyle.resolve(context);
    return SizedBox(
      height: height,
      child: Row(
        children: <Widget>[
          for (var c = 0; c < columns.length; c++)
            Expanded(
              flex: (ratios[c] * 10).toInt(),
              child: LiqWheelColumn(
                initialIndex: selectedIndices[c].clamp(
                  0,
                  columns[c].length - 1,
                ),
                itemCount: columns[c].length,
                itemExtent: itemExtent,
                onSelectedItemChanged: (index) {
                  final next = List<int>.from(selectedIndices)..[c] = index;
                  onSelectionChanged(next);
                },
                itemBuilder: (context, index) => Center(
                  child: Text(
                    columns[c][index].label,
                    style: textStyle,
                    textDirection: TextDirection.ltr,
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
    properties.add(IntProperty('columns', columns.length));
  }
}
