import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget accordionSingleBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    // {@highlight}
    child: LiqAccordion(
      initialExpanded: <int>{0},
      items: <LiqAccordionItem>[
        LiqAccordionItem(
          title: 'What is liqkit_ui?',
          child: Text('A Flutter port of the liqkit iOS 26 design system.'),
        ),
        LiqAccordionItem(
          title: 'Is it production-ready?',
          child: Text(
            'Yes — every component has goldens and Playwright '
            'fidelity tests.',
          ),
        ),
        LiqAccordionItem(
          title: 'Where can I file issues?',
          child: Text(
            'On the GitHub repo at github.com/ahmedomar365/liqkit_ui.',
          ),
        ),
      ],
    ),
    // {@endhighlight}
  );
}
