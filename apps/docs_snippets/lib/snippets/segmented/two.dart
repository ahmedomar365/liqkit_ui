import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget segmentedTwoBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqSegmentedControl<int>(
        segments: const [
          (value: 0, label: 'Day'),
          (value: 1, label: 'Night'),
        ],
        value: 0,
        onChanged: (_) {},
      ),
    ),
  );
  // {@endhighlight}
}
