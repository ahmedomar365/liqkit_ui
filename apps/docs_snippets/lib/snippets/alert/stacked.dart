import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget alertStackedBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqAlert(
      title: 'Allow Notifications',
      description: 'This app would like to send you notifications.',
      actions: <LiqAlertAction>[
        LiqAlertAction(label: "Don't Allow"),
        LiqAlertAction(label: 'Allow', style: LiqAlertActionStyle.filled),
      ],
    ),
  );
  // {@endhighlight}
}
