// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget examplesSectionBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 300,
    child: LiqExamplesSection(
      title: 'Buttons',
      meta: '3 variants',
      child: SizedBox(height: 32),
    ),
  );
  // {@endhighlight}
}
