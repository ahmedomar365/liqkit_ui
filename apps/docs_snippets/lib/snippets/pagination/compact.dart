import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget paginationCompactBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<int>(
      initial: 1,
      builder:
          (page, set) =>
          // {@highlight}
          LiqPagination(
            currentPage: page,
            totalPages: 24,
            compact: true,
            onPageChanged: set,
          ),
      // {@endhighlight}
    ),
  );
}
