import 'package:flutter/cupertino.dart' show CupertinoPicker, CupertinoTimerPicker, CupertinoTimerPickerMode;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/lists/liq_list.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Mode controlling which columns appear in [LiqTimerPicker].
///
/// Re-export of `CupertinoTimerPickerMode` so consumers don't need a
/// `package:flutter/cupertino.dart` import to pass `mode:` values.
typedef LiqTimerPickerMode = CupertinoTimerPickerMode;

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
    final isDark = context.liqIsDark;
    final values = <int>[
      for (var v = minValue; v <= maxValue; v += step) v,
    ];
    final initialIndex =
        values.indexOf(selectedValue).clamp(0, values.length - 1);
    return SizedBox(
      height: height,
      child: CupertinoPicker.builder(
        scrollController: FixedExtentScrollController(initialItem: initialIndex),
        backgroundColor: isDark
            ? const Color(0xCC1C1C1E)
            : const Color(0xCCF5F5F7),
        itemExtent: itemExtent,
        childCount: values.length,
        itemBuilder: (context, index) => Center(
          child: Text(
            values[index].toString(),
            style: LiqAppleTypography.body(
              isDark ? Brightness.dark : Brightness.light,
            ),
          ),
        ),
        onSelectedItemChanged: (index) =>
            onValueChanged(values[index]),
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
    final isDark = context.liqIsDark;
    final values = <double>[];
    for (var v = minValue; v <= maxValue + 0.0001; v += step) {
      values.add(double.parse(v.toStringAsFixed(2)));
    }
    final initialIndex = values
        .indexWhere((v) => (v - value).abs() < step / 2)
        .clamp(0, values.length - 1);
    return SizedBox(
      height: height,
      child: CupertinoPicker.builder(
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        backgroundColor: isDark
            ? const Color(0xCC1C1C1E)
            : const Color(0xCCF5F5F7),
        itemExtent: 32,
        childCount: values.length,
        itemBuilder: (context, index) => Center(
          child: Text(
            '${values[index].toStringAsFixed(1)} $unit',
            style: LiqAppleTypography.body(
              isDark ? Brightness.dark : Brightness.light,
            ),
          ),
        ),
        onSelectedItemChanged: (index) => onValueChanged(values[index]),
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

/// Wraps `CupertinoTimerPicker` to surface a `Duration` selector with
/// the liqkit_ui glass-surface styling.
final class LiqTimerPicker extends StatelessWidget with Diagnosticable {
  /// Creates a timer picker.
  const LiqTimerPicker({
    required this.initialDuration,
    required this.onDurationChanged,
    this.mode = CupertinoTimerPickerMode.hms,
    this.minuteInterval = 1,
    this.height = 216,
    super.key,
  });

  final Duration initialDuration;
  final ValueChanged<Duration> onDurationChanged;
  final CupertinoTimerPickerMode mode;
  final int minuteInterval;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    return SizedBox(
      height: height,
      child: CupertinoTimerPicker(
        mode: mode,
        initialTimerDuration: initialDuration,
        minuteInterval: minuteInterval,
        backgroundColor: isDark
            ? const Color(0xCC1C1C1E)
            : const Color(0xCCF5F5F7),
        onTimerDurationChanged: onDurationChanged,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>('initialDuration', initialDuration))
      ..add(EnumProperty<CupertinoTimerPickerMode>('mode', mode));
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
    final isDark = context.liqIsDark;
    final ratios = columnWidthRatios ??
        List<double>.filled(columns.length, 1);
    return SizedBox(
      height: height,
      child: Row(
        children: <Widget>[
          for (var c = 0; c < columns.length; c++)
            Expanded(
              flex: (ratios[c] * 10).toInt(),
              child: CupertinoPicker.builder(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedIndices[c]
                      .clamp(0, columns[c].length - 1),
                ),
                backgroundColor: isDark
                    ? const Color(0xCC1C1C1E)
                    : const Color(0xCCF5F5F7),
                itemExtent: itemExtent,
                childCount: columns[c].length,
                itemBuilder: (context, index) => Center(
                  child: Text(
                    columns[c][index].label,
                    style: LiqAppleTypography.body(
                      isDark ? Brightness.dark : Brightness.light,
                    ),
                  ),
                ),
                onSelectedItemChanged: (index) {
                  final next = List<int>.from(selectedIndices)..[c] = index;
                  onSelectionChanged(next);
                },
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
