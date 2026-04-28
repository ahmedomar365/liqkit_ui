// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget actionSheetWithCancelBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqActionSheet(
      title: 'Share',
      actions: <LiqAlertAction>[
        LiqAlertAction(label: 'Copy Link'),
        LiqAlertAction(label: 'Save to Files'),
      ],
      cancelAction: LiqAlertAction(label: 'Cancel'),
    ),
  );
  // {@endhighlight}
}
