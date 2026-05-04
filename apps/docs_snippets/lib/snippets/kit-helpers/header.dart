// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget kitHelpersHeaderBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 400,
    child: LiqKitHelpersHeader(
      title: 'Buttons',
      description: 'Tappable controls for iOS 26.',
    ),
  );
  // {@endhighlight}
}
