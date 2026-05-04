// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget widgetLargeBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 200,
    child: SizedBox(
      width: 160,
      child: LiqWidgetCard(size: LiqWidgetSize.large, caption: 'Maps'),
    ),
  );
  // {@endhighlight}
}
