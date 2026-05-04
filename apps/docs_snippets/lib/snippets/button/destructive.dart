import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget buttonDestructiveBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    child: LiqButton(label: 'Delete', destructive: true, onPressed: () {}),
  );
  // {@endhighlight}
}
