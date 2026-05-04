import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popoverLeadingBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 260,
    child: LiqPopover(
      side: LiqPopoverSide.leading,
      child: SnippetLabel('Tip on leading'),
    ),
  );
  // {@endhighlight}
}
