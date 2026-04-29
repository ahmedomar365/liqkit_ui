import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget accordionMultipleBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 360,
        // {@highlight}
        child: LiqAccordion(
          type: LiqAccordionType.multiple,
          initialExpanded: <int>{0, 1},
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
      ),
    ),
  );
}
