// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget lineChartDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 480,
        height: 180,
        // {@highlight}
        child: LiqLineChart(
          values: const <double>[3, 7, 5, 12, 8, 14, 11, 18, 15, 20],
        ),
        // {@endhighlight}
      ),
    ),
  );
}
