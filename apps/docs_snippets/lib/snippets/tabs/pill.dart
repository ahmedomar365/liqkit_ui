import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget tabsPillBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    child: LiqDemo<int>(
      initial: 0,
      builder: (i, set) {
        // {@highlight}
        return LiqTabs(
          variant: LiqTabsVariant.pill,
          items: const <LiqTabItem>[
            LiqTabItem(label: 'Overview'),
            LiqTabItem(label: 'Comments'),
            LiqTabItem(label: 'History'),
          ],
          selectedIndex: i,
          onChanged: set,
        );
        // {@endhighlight}
      },
    ),
  );
}
