import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popoverBottomBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 260,
    height: 170,
    surface: SnippetFrameSurface.liquidLight,
    child: LiqPopover(
      side: LiqPopoverSide.bottom,
      child: SnippetLabel('Tip on bottom'),
    ),
  );
  // {@endhighlight}
}
