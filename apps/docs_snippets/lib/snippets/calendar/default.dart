import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget calendarDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<DateTime>(
      initial: DateTime(2026, 4, 29),
      builder:
          (date, set) => SizedBox(
            width: double.infinity,
            // {@highlight}
            child: LiqCalendar(selectedDate: date, onDateChanged: set),
            // {@endhighlight}
          ),
    ),
  );
}
