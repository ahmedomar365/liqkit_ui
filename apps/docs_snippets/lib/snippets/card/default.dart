import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget cardDefaultBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    // {@highlight}
    child: LiqCard(
      child: Text(
        'A simple card with body content. Hairline border, soft '
        'shadow, 16pt radius.',
      ),
    ),
    // {@endhighlight}
  );
}
