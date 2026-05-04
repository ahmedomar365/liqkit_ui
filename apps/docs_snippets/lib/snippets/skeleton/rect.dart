import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget skeletonRectBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LiqSkeleton(width: double.infinity, height: 24),
        SizedBox(height: 12),
        FractionallySizedBox(
          widthFactor: 0.78,
          alignment: Alignment.centerLeft,
          child: LiqSkeleton(width: double.infinity, height: 24),
        ),
      ],
    ),
    // {@endhighlight}
  );
}
