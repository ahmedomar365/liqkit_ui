// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget examplesItemBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 240,
    child: SizedBox(
      width: 200,
      child: LiqExamplesItem(
        name: 'LiqButton',
        meta: 'Inputs',
        code: 'LiqButton()',
      ),
    ),
  );
  // {@endhighlight}
}
