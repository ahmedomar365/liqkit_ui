// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget pickerInlineCalendarBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: LiqDemo<int?>(
      initial: 15,
      builder: (v, set) {
        // {@highlight}
        return LiqDatePicker(
          year: 2026,
          month: 4,
          selectedDay: v,
          currentDay: 27,
          onDayTap: set,
        );
        // {@endhighlight}
      },
    ),
  );
}
