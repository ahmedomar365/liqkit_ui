import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget segmentedThreeBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<int>(
      initial: 1,
      builder: (v, set) {
        // {@highlight}
        return LiqSegmentedControl<int>(
          segments: const [
            (value: 0, label: 'Day'),
            (value: 1, label: 'Week'),
            (value: 2, label: 'Month'),
          ],
          value: v,
          onChanged: set,
        );
        // {@endhighlight}
      },
    ),
  );
}
