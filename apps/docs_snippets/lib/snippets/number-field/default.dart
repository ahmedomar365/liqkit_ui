// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget numberFieldDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<num>(
      initial: 1,
      builder:
          (n, set) =>
          // {@highlight}
          LiqNumberField(value: n, onChanged: set, max: 99),
      // {@endhighlight}
    ),
  );
}
