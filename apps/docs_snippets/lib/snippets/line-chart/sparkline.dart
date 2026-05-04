// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget lineChartSparklineBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 200,
    height: 40,
    // {@highlight}
    child: LiqLineChart(
      values: const <double>[3, 5, 4, 7, 6, 9, 8, 12, 10, 14],
      fillArea: false,
      strokeWidth: 1.5,
    ),
    // {@endhighlight}
  );
}
