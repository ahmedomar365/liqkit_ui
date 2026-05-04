import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget alertDestructiveBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 420,
    child: LiqAlert(
      title: 'Delete Item',
      description: 'This action cannot be undone.',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Delete',
          style: LiqAlertActionStyle.destructive,
          onPressed: _noop,
        ),
        LiqAlertAction(label: 'Cancel', onPressed: _noop),
      ],
    ),
  );
  // {@endhighlight}
}

void _noop() {}
