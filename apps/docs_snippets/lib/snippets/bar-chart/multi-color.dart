// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget barChartMultiColorBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 480,
        height: 200,
        // {@highlight}
        child: LiqBarChart(
          bars: const <LiqBar>[
            LiqBar(value: 12, label: 'Mon', color: Color(0xFF34C759)),
            LiqBar(value: 18, label: 'Tue', color: Color(0xFF007AFF)),
            LiqBar(value: 9, label: 'Wed', color: Color(0xFF34C759)),
            LiqBar(value: 24, label: 'Thu', color: Color(0xFF007AFF)),
            LiqBar(value: 16, label: 'Fri', color: Color(0xFF007AFF)),
            LiqBar(value: 22, label: 'Sat', color: Color(0xFF007AFF)),
            LiqBar(value: 14, label: 'Sun', color: Color(0xFF34C759)),
          ],
        ),
        // {@endhighlight}
      ),
    ),
  );
}
