import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget skeletonCircleBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: SizedBox(
        width: 320,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LiqSkeleton(shape: LiqSkeletonShape.circle, width: 40),
            SizedBox(width: 12),
            Expanded(child: LiqSkeletonText(lines: 2)),
          ],
        ),
      ),
      // {@endhighlight}
    ),
  );
}
