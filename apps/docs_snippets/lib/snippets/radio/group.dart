import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget radioGroupBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<String>(
      initial: 'auto',
      builder: (v, set) {
        // {@highlight}
        return LiqRadioGroup<String>(
          value: v,
          onChanged: set,
          options: const <({String value, String label})>[
            (value: 'auto', label: 'Auto'),
            (value: 'light', label: 'Light'),
            (value: 'dark', label: 'Dark'),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
