import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget timePickerIntervalsBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 420,
    height: 276,
    surface: SnippetFrameSurface.themed,
    surfacePadding: const EdgeInsets.all(20),
    child: LiqDemo<DateTime>(
      initial: DateTime(2026, 4, 29, 14, 30),
      builder:
          (t, set) =>
          // {@highlight}
          LiqTimePicker(value: t, onChanged: set, minuteInterval: 15),
      // {@endhighlight}
    ),
  );
}
