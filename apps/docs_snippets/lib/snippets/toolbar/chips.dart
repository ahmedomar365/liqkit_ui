import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toolbarChipsBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    child: LiqToolbar(
      leading: <Widget>[
        LiqToolbarChip(label: 'All', onPressed: () {}),
        LiqToolbarChip(label: 'Unread', onPressed: () {}),
        LiqToolbarChip(label: 'Flagged', onPressed: () {}),
      ],
    ),
  );
  // {@endhighlight}
}
