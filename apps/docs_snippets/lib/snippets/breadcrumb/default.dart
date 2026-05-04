import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget breadcrumbDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 520,
    // {@highlight}
    child: LiqBreadcrumb(
      items: <LiqBreadcrumbItem>[
        LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
        LiqBreadcrumbItem(label: 'Library', onPressed: () {}),
        LiqBreadcrumbItem(label: 'Components', onPressed: () {}),
        const LiqBreadcrumbItem(label: 'Breadcrumb'),
      ],
    ),
    // {@endhighlight}
  );
}
