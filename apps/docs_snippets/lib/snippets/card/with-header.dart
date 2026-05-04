// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget cardWithHeaderBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    // {@highlight}
    child: LiqCard(
      header: SnippetLabel('Title', fontSize: 16, fontWeight: FontWeight.w600),
      child: SnippetLabel('Body content under a header divider.'),
    ),
    // {@endhighlight}
  );
}
