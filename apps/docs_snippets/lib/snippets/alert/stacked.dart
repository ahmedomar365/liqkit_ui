import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget alertStackedBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 420,
    child: LiqAlert(
      title: 'Allow Notifications',
      description: 'This app would like to send you notifications.',
      actions: <LiqAlertAction>[
        LiqAlertAction(label: "Don't Allow", onPressed: _noop),
        LiqAlertAction(
          label: 'Allow',
          style: LiqAlertActionStyle.filled,
          onPressed: _noop,
        ),
      ],
    ),
  );
  // {@endhighlight}
}

void _noop() {}
