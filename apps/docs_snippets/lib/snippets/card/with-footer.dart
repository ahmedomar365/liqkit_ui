// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget cardWithFooterBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    height: 190,
    // {@highlight}
    child: LiqCard(
      header: SnippetLabel('Title', fontSize: 16, fontWeight: FontWeight.w600),
      footer: SnippetLabel('Updated 2 minutes ago', fontSize: 12),
      child: SnippetLabel('Body content with both a header and a footer.'),
    ),
    // {@endhighlight}
  );
}
