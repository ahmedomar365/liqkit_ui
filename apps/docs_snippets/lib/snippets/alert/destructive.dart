import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget alertDestructiveBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqAlert(
      title: 'Delete Item',
      description: 'This action cannot be undone.',
      actions: <LiqAlertAction>[
        LiqAlertAction(label: 'Delete', style: LiqAlertActionStyle.destructive),
        LiqAlertAction(label: 'Cancel'),
      ],
    ),
  );
  // {@endhighlight}
}
