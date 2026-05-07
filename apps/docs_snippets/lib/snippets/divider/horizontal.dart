import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dividerHorizontalBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SnippetLabel('Section A'),
        SizedBox(height: 12),
        LiqDivider(),
        SizedBox(height: 12),
        SnippetLabel('Section B'),
      ],
    ),
    // {@endhighlight}
  );
}
