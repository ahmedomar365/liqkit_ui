import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget breadcrumbDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
    ),
  );
}
