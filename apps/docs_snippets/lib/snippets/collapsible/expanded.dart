// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget collapsibleExpandedBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    // {@highlight}
    child: LiqCollapsible(
      initiallyExpanded: true,
      header: SnippetLabel('What is liqkit_ui?', fontWeight: FontWeight.w600),
      child: Padding(
        padding: EdgeInsets.only(top: 8),
        child: SnippetLabel(
          'A Flutter port of the liqkit iOS 26 design system. 76 '
          'components ship with goldens, live previews, and '
          'interactive code snippets.',
          fontSize: 14,
        ),
      ),
    ),
    // {@endhighlight}
  );
}
