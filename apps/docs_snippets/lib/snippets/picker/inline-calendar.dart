// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget pickerInlineCalendarBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqDatePicker(
      year: 2026,
      month: 4,
      selectedDay: 15,
      currentDay: 27,
      onDayTap: (_) {},
    ),
  );
  // {@endhighlight}
}
