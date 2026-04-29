import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget paginationDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: LiqDemo<int>(
        initial: 4,
        builder:
            (page, set) => LiqPagination(
              currentPage: page,
              totalPages: 12,
              onPageChanged: set,
            ),
      ),
      // {@endhighlight}
    ),
  );
}
