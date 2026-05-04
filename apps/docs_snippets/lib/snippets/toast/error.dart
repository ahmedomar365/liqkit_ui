import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toastErrorBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: LiqToast(
      message: 'Could not connect to server',
      variant: LiqToastVariant.error,
    ),
    // {@endhighlight}
  );
}
