import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget radioSingleBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<String>(
      initial: 'a',
      builder: (v, set) {
        // {@highlight}
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LiqRadio<String>(value: 'a', groupValue: v, onChanged: set),
            const SizedBox(width: 16),
            LiqRadio<String>(value: 'b', groupValue: v, onChanged: set),
            const SizedBox(width: 16),
            LiqRadio<String>(value: 'c', groupValue: v, onChanged: set),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
