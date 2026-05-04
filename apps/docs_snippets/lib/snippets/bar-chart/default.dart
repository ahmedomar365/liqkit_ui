// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget barChartDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 480,
    height: 200,
    // {@highlight}
    child: LiqBarChart(
      bars: const <LiqBar>[
        LiqBar(value: 12, label: 'Mon'),
        LiqBar(value: 18, label: 'Tue'),
        LiqBar(value: 9, label: 'Wed'),
        LiqBar(value: 24, label: 'Thu'),
        LiqBar(value: 16, label: 'Fri'),
        LiqBar(value: 22, label: 'Sat'),
        LiqBar(value: 14, label: 'Sun'),
      ],
    ),
    // {@endhighlight}
  );
}
