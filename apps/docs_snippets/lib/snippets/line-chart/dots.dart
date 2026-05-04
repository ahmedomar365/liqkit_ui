// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget lineChartDotsBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 480,
    height: 180,
    // {@highlight}
    child: LiqLineChart(
      values: const <double>[3, 7, 5, 12, 8, 14, 11, 18, 15, 20],
      showDots: true,
      smooth: false,
    ),
    // {@endhighlight}
  );
}
