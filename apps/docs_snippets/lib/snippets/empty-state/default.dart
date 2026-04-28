// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget emptyStateDefaultBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqEmptyState(
      title: 'No Results',
      description: 'Try adjusting your search or filters.',
    ),
  );
  // {@endhighlight}
}
