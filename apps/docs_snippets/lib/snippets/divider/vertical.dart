import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dividerVerticalBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Left'),
          SizedBox(width: 12),
          LiqDivider(orientation: LiqDividerOrientation.vertical),
          SizedBox(width: 12),
          Text('Right'),
        ],
      ),
    ),
    // {@endhighlight}
  );
}
