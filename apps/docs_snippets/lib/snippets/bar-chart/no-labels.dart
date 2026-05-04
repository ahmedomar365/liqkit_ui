// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget barChartNoLabelsBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 200,
    height: 60,
    // {@highlight}
    child: LiqBarChart(
      showLabels: false,
      bars: const <LiqBar>[
        LiqBar(value: 12),
        LiqBar(value: 18),
        LiqBar(value: 9),
        LiqBar(value: 24),
        LiqBar(value: 16),
        LiqBar(value: 22),
        LiqBar(value: 14),
      ],
    ),
    // {@endhighlight}
  );
}
