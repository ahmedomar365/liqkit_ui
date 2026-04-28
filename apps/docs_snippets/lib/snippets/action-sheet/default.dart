// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget actionSheetDefaultBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqActionSheet(
      title: 'AirDrop',
      actions: <LiqAlertAction>[
        LiqAlertAction(label: 'Share via AirDrop'),
        LiqAlertAction(label: 'Copy Link'),
        LiqAlertAction(label: 'Add to Reading List'),
      ],
    ),
  );
  // {@endhighlight}
}
