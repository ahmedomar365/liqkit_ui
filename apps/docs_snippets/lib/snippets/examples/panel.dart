// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget examplesPanelBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: SizedBox(
      width: 300,
      child: LiqExamplesPanel(
        title: 'Components',
        body: 'Browse the available UI components.',
        child: SizedBox(height: 40),
      ),
    ),
  );
  // {@endhighlight}
}
