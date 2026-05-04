// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget alertSideBySideBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 420,
    child: LiqAlert(
      title: 'Save Changes?',
      description: 'Your unsaved changes will be lost.',
      layout: LiqAlertActionLayout.sideBySide,
      actions: <LiqAlertAction>[
        LiqAlertAction(label: 'Cancel', onPressed: _noop),
        LiqAlertAction(
          label: 'Save',
          style: LiqAlertActionStyle.filled,
          onPressed: _noop,
        ),
      ],
    ),
  );
  // {@endhighlight}
}

void _noop() {}
