import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popupButtonRegularBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<int>(
      initial: 0,
      builder: (v, set) {
        // {@highlight}
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LiqPopupButton(label: 'Today', onPressed: () => set(v + 1)),
            if (v > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SnippetLabel(
                  'Tapped $v time${v == 1 ? '' : 's'}',
                  fontSize: 13,
                ),
              ),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
