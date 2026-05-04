import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget checkboxIndeterminateBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<LiqCheckboxState>(
      initial: LiqCheckboxState.indeterminate,
      builder: (v, set) {
        // {@highlight}
        return LiqCheckbox(value: v, onChanged: set);
        // {@endhighlight}
      },
    ),
  );
}
