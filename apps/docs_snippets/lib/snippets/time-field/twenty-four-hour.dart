// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget timeFieldTwentyFourHourBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 240,
    child: LiqDemo<LiqTime?>(
      initial: const LiqTime(hour: 14, minute: 30),
      builder:
          (v, set) =>
          // {@highlight}
          LiqTimeField(value: v, onChanged: set, use24HourFormat: true),
      // {@endhighlight}
    ),
  );
}
