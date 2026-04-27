import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 inline date picker — month grid with selectable days.
///
/// Sourced from `native/components/pickers.css` (`.ios26-picker-inline`):
/// 370pt wide, 13pt corner radius, white surface, soft drop shadow.
/// Header shows the month/year title with prev/next arrows; weekday row
/// (uppercase, 590 13/18 30%); 7×N grid of 44pt day cells with the
/// `current` day shown as a blue ring and the `selected` day(s) tinted
/// light blue (or solid blue when current+selected).
final class LiqDatePicker extends StatelessWidget {
  /// Creates an inline date picker for [month]/[year].
  ///
  /// [selectedDay] is highlighted with a tinted background; [currentDay]
  /// (today) is drawn with a blue ring. When both match, the cell is
  /// rendered with a solid blue fill.
  const LiqDatePicker({
    required this.year,
    required this.month,
    this.selectedDay,
    this.currentDay,
    this.onDayTap,
    this.onPrev,
    this.onNext,
    super.key,
  })  : assert(month >= 1 && month <= 12, 'month must be 1..12'),
        assert(year >= 1, 'year must be ≥ 1');

  /// Year (gregorian).
  final int year;

  /// Month (1..12).
  final int month;

  /// Day currently selected (1..31). Null = nothing selected.
  final int? selectedDay;

  /// Today's day-of-month (1..31). Null = no current marker.
  final int? currentDay;

  /// Callback when a day cell is tapped.
  final ValueChanged<int>? onDayTap;

  /// Optional callback for the previous-month arrow.
  final VoidCallback? onPrev;

  /// Optional callback for the next-month arrow.
  final VoidCallback? onNext;

  static const Color _bg = Color(0xFFFFFFFF);
  static const Color _rim = Color(0x140F141C);
  static const Color _shadow = Color(0x1F131925);
  static const Color _title = Color(0xFF000000);
  static const Color _accent = Color(0xFF0088FF);
  static const Color _accentTint = Color(0x2E0088FF);
  static const Color _weekdayColor = Color(0x4D3C3C43);
  static const Color _nullColor = Color(0x4D3C3C43);

  static const List<String> _weekdayLabels = <String>[
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  static const List<String> _monthNames = <String>[
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

  int _daysInMonth() {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        final isLeap =
            (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        return isLeap ? 29 : 28;
    }
    return 30;
  }

  /// Returns 0..6 (Sunday..Saturday) for the first day of [month]/[year].
  int _firstDayOfWeek() {
    return DateTime(year, month).weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysInMonth();
    final lead = _firstDayOfWeek();
    final cells = <int?>[
      for (var i = 0; i < lead; i++) null,
      for (var d = 1; d <= daysInMonth; d++) d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return SizedBox(
      width: 370,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.all(Radius.circular(13)),
            border: Border.fromBorderSide(BorderSide(color: _rim)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _shadow,
                offset: Offset(0, 10),
                blurRadius: 40,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildHeader(),
                _buildWeekdays(),
                const SizedBox(height: 10),
                _buildGrid(cells),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${_monthNames[month - 1]} $year',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                  fontSize: 17,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  fontWeight: FontWeight.w600,
                  color: _title,
                ),
              ),
            ),
            _Arrow(direction: _ArrowDir.left, onPressed: onPrev),
            const SizedBox(width: 20),
            _Arrow(direction: _ArrowDir.right, onPressed: onNext),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdays() {
    return SizedBox(
      height: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (final label in _weekdayLabels)
              SizedBox(
                width: 32,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w600,
                    color: _weekdayColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<int?> cells) {
    final rows = <Widget>[];
    for (var r = 0; r < cells.length / 7; r++) {
      final row = <Widget>[];
      for (var c = 0; c < 7; c++) {
        final day = cells[r * 7 + c];
        row.add(_buildDayCell(day));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: row,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }

  Widget _buildDayCell(int? day) {
    if (day == null) {
      return const SizedBox(width: 44, height: 44);
    }
    final isSelected = day == selectedDay;
    final isCurrent = day == currentDay;
    final BoxDecoration? decoration;
    final Color textColor;
    if (isSelected && isCurrent) {
      decoration = const BoxDecoration(
        color: _accent,
        shape: BoxShape.circle,
      );
      textColor = const Color(0xFFFFFFFF);
    } else if (isSelected) {
      decoration = const BoxDecoration(
        color: _accentTint,
        shape: BoxShape.circle,
      );
      textColor = _accent;
    } else if (isCurrent) {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _accent),
      );
      textColor = _accent;
    } else {
      decoration = null;
      textColor = _title;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onDayTap == null ? null : () => onDayTap!(day),
      child: Container(
        width: 44,
        height: 44,
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          '$day',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: 20,
            height: 25 / 20,
            letterSpacing: -0.45,
            color: day < 1 ? _nullColor : textColor,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('year', year))
      ..add(IntProperty('month', month))
      ..add(IntProperty('selectedDay', selectedDay))
      ..add(IntProperty('currentDay', currentDay));
  }
}

enum _ArrowDir { left, right }

class _Arrow extends StatelessWidget {
  const _Arrow({required this.direction, required this.onPressed});
  final _ArrowDir direction;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: SizedBox(
        width: 20,
        height: 24,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CustomPaint(painter: _ArrowPainter(direction)),
          ),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter(this.direction);
  final _ArrowDir direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0088FF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.8;
    final path = Path();
    if (direction == _ArrowDir.left) {
      path
        ..moveTo(size.width * 0.65, size.height * 0.18)
        ..lineTo(size.width * 0.32, size.height * 0.5)
        ..lineTo(size.width * 0.65, size.height * 0.82);
    } else {
      path
        ..moveTo(size.width * 0.35, size.height * 0.18)
        ..lineTo(size.width * 0.68, size.height * 0.5)
        ..lineTo(size.width * 0.35, size.height * 0.82);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) =>
      oldDelegate.direction != direction;
}
