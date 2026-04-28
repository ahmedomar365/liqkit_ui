import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget segmentedThreeBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: LiqDemo<int>(
      initial: 1,
      builder: (v, set) {
        // {@highlight}
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LiqSegmentedControl<int>(
            segments: const [
              (value: 0, label: 'Day'),
              (value: 1, label: 'Week'),
              (value: 2, label: 'Month'),
            ],
            value: v,
            onChanged: set,
          ),
        );
        // {@endhighlight}
      },
    ),
  );
}
