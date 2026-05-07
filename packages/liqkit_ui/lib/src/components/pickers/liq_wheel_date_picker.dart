import 'package:flutter/cupertino.dart'
    show CupertinoDatePicker, CupertinoDatePickerMode, CupertinoTheme,
        CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Mode axis for [LiqWheelDatePicker].
///
/// Mirrors `CupertinoDatePickerMode` so consumers don't have to import
/// `package:flutter/cupertino.dart` themselves.
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

CupertinoDatePickerMode _toCupertinoMode(LiqWheelDatePickerMode mode) {
  switch (mode) {
    case LiqWheelDatePickerMode.date:
      return CupertinoDatePickerMode.date;
    case LiqWheelDatePickerMode.time:
      return CupertinoDatePickerMode.time;
    case LiqWheelDatePickerMode.dateAndTime:
      return CupertinoDatePickerMode.dateAndTime;
    case LiqWheelDatePickerMode.monthYear:
      return CupertinoDatePickerMode.monthYear;
  }
}

/// iOS 26 wheel-style date / time picker.
///
/// Wraps [CupertinoDatePicker] (the canonical iOS spinning-wheels
/// picker that ships with the Flutter SDK) and presents it on a
/// liqkit_ui-themed glass surface. Use this when you want the iconic
/// iOS scroll-to-pick UX. For a calendar-grid-style picker, see
/// `LiqDatePicker`.
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
    super.key,
  });

  /// Called every time the wheels rest on a new value.
  final ValueChanged<DateTime> onDateChanged;

  /// Initial value. Defaults to `DateTime.now()`.
  final DateTime? initialDate;

  /// Optional lower bound.
  final DateTime? minimumDate;

  /// Optional upper bound.
  final DateTime? maximumDate;

  /// Mode axis (date / time / dateAndTime / monthYear).
  final LiqWheelDatePickerMode mode;

  /// Total picker height. iOS HIG default is 216pt.
  final double height;

  /// Whether to use a 24-hour clock when [mode] involves time.
  final bool use24hFormat;

  /// Minute snap interval. iOS canonical is 1; common alternatives are 5/15.
  final int minuteInterval;

  /// Whether to fire `HapticFeedback.selectionClick()` on tick.
  final bool enableHaptics;

  /// Override surface brightness. Defaults to the nearest LiqTheme.
  final Brightness? brightness;

  /// Glass tint preset.
  final LiqGlassTint tint;

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
  late DateTime _selected = widget.initialDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final brightness = widget.brightness ?? context.liqBrightness;
    return LiqGlassSurface(
      tint: widget.tint,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: SizedBox(
        height: widget.height,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
            primaryColor: const Color(0xFF0088FF),
          ),
          child: CupertinoDatePicker(
            mode: _toCupertinoMode(widget.mode),
            initialDateTime: _selected,
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            use24hFormat: widget.use24hFormat,
            minuteInterval: widget.minuteInterval,
            backgroundColor: const Color(0x00000000),
            onDateTimeChanged: (DateTime next) {
              if (widget.enableHaptics) HapticFeedback.selectionClick();
              setState(() => _selected = next);
              widget.onDateChanged(next);
            },
          ),
        ),
      ),
    );
  }
}

/// Modal-bottom-sheet variant — opens [LiqWheelDatePicker] with a
/// Cancel / Done header. Returns the picked `DateTime` (or `null` if
/// dismissed via Cancel).
///
/// ```dart
/// final picked = await LiqWheelDatePicker.showModal(
///   context: context,
///   initialDate: DateTime.now(),
///   mode: LiqWheelDatePickerMode.date,
/// );
/// ```
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
    final isDark = context.liqIsDark;
    final headerBg = isDark
        ? const Color(0xFF1C1C1E)
        : const Color(0xFFFFFFFF);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ColoredBox(
        color: headerBg,
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
              Container(
                height: 0.5,
                color: isDark
                    ? const Color(0x4A545458)
                    : const Color(0x4A3C3C43),
              ),
              child,
            ],
          ),
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
