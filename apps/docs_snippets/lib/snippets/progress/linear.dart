import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget progressLinearBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(child: LiqProgressBar(value: 0.6));
  // {@endhighlight}
}
