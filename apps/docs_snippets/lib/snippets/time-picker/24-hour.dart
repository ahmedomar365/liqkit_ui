// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget timePicker24HourBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<DateTime>(
      initial: DateTime(2026, 4, 29, 14, 30),
      builder:
          (t, set) =>
          // {@highlight}
          LiqTimePicker(value: t, onChanged: set, use24HourFormat: true),
      // {@endhighlight}
    ),
  );
}
