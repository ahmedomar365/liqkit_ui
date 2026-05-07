import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 standalone month-grid calendar.
///
/// Renders a 7-column grid of date cells with weekday headers, a
/// month/year title, and previous/next month chevrons. The grid lays
/// out a Sunday-first US locale by default.
///
/// Distinct from the inline calendar embedded inside `LiqDatePicker`:
/// `LiqCalendar` is a top-level component that consumers can drop
/// anywhere — without the surrounding picker chrome — for grid-style
/// date selection.
///
/// The consumer owns the [selectedDate] (controlled). The currently
/// shown month is managed internally; it follows [selectedDate] when
/// the parent passes a new date in a different month and can be set
/// initially via [initialMonth].
final class LiqCalendar extends StatefulWidget {
  /// Creates a month-grid date picker.
  const LiqCalendar({
    required this.selectedDate,
    required this.onDateChanged,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    super.key,
  });

  /// The currently-selected date (highlighted in the grid).
  final DateTime selectedDate;

  /// Called with the new date when the user taps a day cell.
  final ValueChanged<DateTime> onDateChanged;

  /// Month to show on first paint. Defaults to [selectedDate]'s month.
  ///
  /// Only the year/month components are used; the day is ignored.
  final DateTime? initialMonth;

  /// Optional inclusive lower bound. Days before this date are dimmed
  /// and non-tappable.
  final DateTime? firstDate;

  /// Optional inclusive upper bound. Days after this date are dimmed
  /// and non-tappable.
  final DateTime? lastDate;

  /// Side length of every day cell.
  static const double cellSize = 36;

  /// Corner radius for day cells (full circle at [cellSize] = 36).
  static const double cellRadius = 18;

  /// Spacing between cells (and between header and grid).
  static const double cellSpacing = 4;

  /// Spacing between the weekday-header row and the day grid.
  static const double headerGridSpacing = 8;

  /// iOS 26 system blue used for the selected cell fill and today text.
  static const Color accent = Color(0xFF007AFF);

  /// Text color on the filled selected cell.
  static const Color selectedTextColor = Color(0xFFFFFFFF);

  /// Default in-month day text color.
  static const Color dayTextColor = Color(0xFF1C1C1E);

  /// Out-of-month leading/trailing day text color (visible only when
  /// the grid spills into adjacent months).
  static const Color outOfMonthTextColor = Color(0xFFC7C7CC);

  /// Out-of-bounds day text color (firstDate/lastDate clamped days).
  static const Color outOfBoundsTextColor = Color(0xFFE5E5EA);

  /// Weekday-header (e.g. "MO") text color.
  static const Color weekdayColor = Color(0xFF8E8E93);

  /// Month/year title text color.
  static const Color titleColor = Color(0xFF000000);

  /// Side length of each prev/next chevron tap target.
  static const double chevronSize = 44;

  /// Two-letter weekday labels in Sunday-first order.
  static const List<String> weekdayLabels = <String>[
    'SU',
    'MO',
    'TU',
    'WE',
    'TH',
    'FR',
    'SA',
  ];

  /// Long month names indexed `monthName[month - 1]` for `month` in 1..12.
  static const List<String> monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Style for the month/year title.
  static const TextStyle titleTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: titleColor,
  );

  /// Style for weekday-header labels.
  static const TextStyle weekdayTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: weekdayColor,
  );

  /// Base style for day-cell numerals.
  static const TextStyle dayTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: dayTextColor,
  );

  @override
  State<LiqCalendar> createState() => _LiqCalendarState();
}

class _LiqCalendarState extends State<LiqCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMonth ?? widget.selectedDate;
    _focusedMonth = DateTime(initial.year, initial.month);
  }

  @override
  void didUpdateWidget(covariant LiqCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selected = widget.selectedDate;
    if (selected.year != _focusedMonth.year ||
        selected.month != _focusedMonth.month) {
      // Only follow when the parent really changed the selected date.
      if (selected != oldWidget.selectedDate) {
        _focusedMonth = DateTime(selected.year, selected.month);
      }
    }
  }

  void _shiftMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  bool _isDateOnly(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isOutOfBounds(DateTime date) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    final dayOnly = DateTime(date.year, date.month, date.day);
    if (first != null) {
      final firstOnly = DateTime(first.year, first.month, first.day);
      if (dayOnly.isBefore(firstOnly)) return true;
    }
    if (last != null) {
      final lastOnly = DateTime(last.year, last.month, last.day);
      if (dayOnly.isAfter(lastOnly)) return true;
    }
    return false;
  }

  void _handleTap(DateTime date) {
    if (_isOutOfBounds(date)) return;
    setState(() {
      _focusedMonth = DateTime(date.year, date.month);
    });
    widget.onDateChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildHeader(),
        const SizedBox(height: LiqCalendar.headerGridSpacing),
        _buildWeekdayRow(),
        const SizedBox(height: LiqCalendar.headerGridSpacing),
        _buildGrid(),
      ],
    );
  }

  Widget _buildHeader() {
    final palette = _CalendarPalette.resolve(context);
    final name = LiqCalendar.monthNames[_focusedMonth.month - 1];
    final monthLabel = '$name ${_focusedMonth.year}';
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            monthLabel,
            textDirection: TextDirection.ltr,
            style: LiqCalendar.titleTextStyle.copyWith(color: palette.title),
          ),
        ),
        _ChevronButton(
          icon: LucideIcons.chevronLeft,
          semanticLabel: 'Previous month',
          onTap: () => _shiftMonth(-1),
        ),
        const SizedBox(width: LiqCalendar.cellSpacing),
        _ChevronButton(
          icon: LucideIcons.chevronRight,
          semanticLabel: 'Next month',
          onTap: () => _shiftMonth(1),
        ),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    final palette = _CalendarPalette.resolve(context);
    return Row(
      children: <Widget>[
        for (final label in LiqCalendar.weekdayLabels)
          Expanded(
            child: SizedBox(
              height: LiqCalendar.cellSize,
              child: Center(
                child: Text(
                  label,
                  textDirection: TextDirection.ltr,
                  style: LiqCalendar.weekdayTextStyle.copyWith(
                    color: palette.weekday,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGrid() {
    final cells = _buildGridCells();
    final rows = <Widget>[];
    for (var r = 0; r < cells.length; r += 7) {
      final rowCells = <Widget>[];
      for (var c = 0; c < 7; c++) {
        if (c > 0) rowCells.add(const SizedBox(width: LiqCalendar.cellSpacing));
        rowCells.add(Expanded(child: _buildDayCell(cells[r + c])));
      }
      if (r > 0) {
        rows.add(const SizedBox(height: LiqCalendar.cellSpacing));
      }
      rows.add(Row(children: rowCells));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  /// Builds a flat list of 42 `DateTime`s representing the 6 rows of
  /// the visible grid, including leading days from the previous month
  /// and trailing days from the next month so each row is fully
  /// populated.
  List<DateTime> _buildGridCells() {
    final firstOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month);
    // DateTime.weekday: Mon=1..Sun=7. Sunday-first index = weekday % 7.
    final lead = firstOfMonth.weekday % 7;
    final start = firstOfMonth.subtract(Duration(days: lead));
    return <DateTime>[
      for (var i = 0; i < 42; i++) start.add(Duration(days: i)),
    ];
  }

  Widget _buildDayCell(DateTime date) {
    final palette = _CalendarPalette.resolve(context);
    final inFocusedMonth =
        date.month == _focusedMonth.month && date.year == _focusedMonth.year;
    final isSelected = _isDateOnly(date, widget.selectedDate);
    final isOutOfBounds = _isOutOfBounds(date);
    final today = DateTime.now();
    final isToday = _isDateOnly(date, today);

    final Color bg;
    final Color textColor;
    if (isSelected) {
      bg = palette.accent;
      textColor = LiqCalendar.selectedTextColor;
    } else {
      bg = const Color(0x00000000);
      if (isOutOfBounds) {
        textColor = palette.outOfBounds;
      } else if (!inFocusedMonth) {
        textColor = palette.outOfMonth;
      } else if (isToday) {
        textColor = palette.accent;
      } else {
        textColor = palette.day;
      }
    }

    final cell = Center(
      child: Container(
        width: LiqCalendar.cellSize,
        height: LiqCalendar.cellSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(LiqCalendar.cellRadius),
        ),
        child: Text(
          '${date.day}',
          textDirection: TextDirection.ltr,
          style: LiqCalendar.dayTextStyle.copyWith(color: textColor),
        ),
      ),
    );

    if (isOutOfBounds) {
      return SizedBox(
        height: LiqCalendar.cellSize,
        child: Semantics(
          button: false,
          enabled: false,
          label: 'Day ${date.day}',
          child: cell,
        ),
      );
    }

    return SizedBox(
      height: LiqCalendar.cellSize,
      child: Semantics(
        button: true,
        enabled: true,
        selected: isSelected,
        label: 'Day ${date.day}',
        child: LiqPointerCursor(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _handleTap(date),
            child: cell,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('selectedDate', widget.selectedDate))
      ..add(DiagnosticsProperty<DateTime>('focusedMonth', _focusedMonth))
      ..add(DiagnosticsProperty<DateTime?>('firstDate', widget.firstDate))
      ..add(DiagnosticsProperty<DateTime?>('lastDate', widget.lastDate));
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _CalendarPalette.resolve(context);
    return Semantics(
      button: true,
      enabled: true,
      label: semanticLabel,
      child: LiqPointerCursor(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: LiqCalendar.chevronSize,
            height: LiqCalendar.chevronSize,
            child: Center(child: Icon(icon, size: 18, color: palette.accent)),
          ),
        ),
      ),
    );
  }
}

class _CalendarPalette {
  const _CalendarPalette({
    required this.accent,
    required this.title,
    required this.day,
    required this.weekday,
    required this.outOfMonth,
    required this.outOfBounds,
  });

  factory _CalendarPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _CalendarPalette(
        accent: LiqCalendar.accent,
        title: LiqCalendar.titleColor,
        day: LiqCalendar.dayTextColor,
        weekday: LiqCalendar.weekdayColor,
        outOfMonth: LiqCalendar.outOfMonthTextColor,
        outOfBounds: LiqCalendar.outOfBoundsTextColor,
      );
    }

    final label = context.liqLabelColor;
    final secondary = context.liqSecondaryLabelColor;
    return _CalendarPalette(
      accent: context.liqPrimaryColor,
      title: label,
      day: label,
      weekday: secondary,
      outOfMonth: secondary.withValues(alpha: 0.48),
      outOfBounds: secondary.withValues(alpha: 0.24),
    );
  }

  final Color accent;
  final Color title;
  final Color day;
  final Color weekday;
  final Color outOfMonth;
  final Color outOfBounds;
}
