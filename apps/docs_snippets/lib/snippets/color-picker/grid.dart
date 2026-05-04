import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget colorPickerGridBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: LiqDemo<int>(
        initial: 7,
        builder:
            (selected, set) =>
            // {@highlight}
            LiqColorGrid(
              colors: liqNativeColorGridColors,
              selectedIndex: selected,
              onSelected: set,
            ),
        // {@endhighlight}
      ),
    ),
  );
}
