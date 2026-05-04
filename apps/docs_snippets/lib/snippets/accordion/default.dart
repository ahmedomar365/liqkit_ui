// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget accordionDefaultBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    // {@highlight}
    child: LiqAccordion(
      items: <LiqAccordionItem>[
        LiqAccordionItem(
          title: 'Section one',
          child: Text('Body content for section one.'),
        ),
        LiqAccordionItem(
          title: 'Section two',
          child: Text('Body content for section two.'),
        ),
      ],
    ),
    // {@endhighlight}
  );
}
