import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget paginationDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<int>(
      initial: 4,
      builder:
          (page, set) =>
          // {@highlight}
          LiqPagination(currentPage: page, totalPages: 12, onPageChanged: set),
      // {@endhighlight}
    ),
  );
}
