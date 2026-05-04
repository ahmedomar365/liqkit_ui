import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textStylesAccessibilityBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 760,
    child: LiqTypeColumn(header: 'AX2', scale: LiqDynamicTypeScale.ax2),
  );
  // {@endhighlight}
}
