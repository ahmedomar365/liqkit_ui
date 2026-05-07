// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget pickerInlineCalendarBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 420,
    height: 360,
    child: _InlineCalendarExample(),
  );
}

class _InlineCalendarExample extends StatefulWidget {
  const _InlineCalendarExample();

  @override
  State<_InlineCalendarExample> createState() => _InlineCalendarExampleState();
}

class _InlineCalendarExampleState extends State<_InlineCalendarExample> {
  DateTime _visibleMonth = DateTime(2026, 4);
  int? _selectedDay = 15;

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // {@highlight}
    return LiqDatePicker(
      year: _visibleMonth.year,
      month: _visibleMonth.month,
      selectedDay: _selectedDay,
      currentDay:
          _visibleMonth.year == 2026 && _visibleMonth.month == 4 ? 27 : null,
      onPrev: () => _shiftMonth(-1),
      onNext: () => _shiftMonth(1),
      onDayTap: (day) => setState(() => _selectedDay = day),
    );
    // {@endhighlight}
  }
}
