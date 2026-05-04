import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget skeletonCircleBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LiqSkeleton(shape: LiqSkeletonShape.circle, width: 40),
        SizedBox(width: 12),
        Expanded(child: LiqSkeletonText(lines: 2)),
      ],
    ),
    // {@endhighlight}
  );
}
