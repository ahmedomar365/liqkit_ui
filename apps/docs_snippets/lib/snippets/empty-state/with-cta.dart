// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget emptyStateWithCtaBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqEmptyState(
      title: 'No Photos Yet',
      description: 'Photos you take will appear here.',
      cta: LiqEmptyStateCta(label: 'Open Camera', onPressed: () {}),
    ),
  );
  // {@endhighlight}
}
