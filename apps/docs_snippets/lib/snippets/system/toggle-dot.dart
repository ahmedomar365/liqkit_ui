// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget systemToggleDotBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<bool>(
      initial: true,
      builder: (v, set) {
        // {@highlight}
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LiqSystemToggleDot(selected: !v, onPressed: () => set(true)),
            const SizedBox(width: 16),
            LiqSystemToggleDot(selected: v, onPressed: () => set(false)),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
