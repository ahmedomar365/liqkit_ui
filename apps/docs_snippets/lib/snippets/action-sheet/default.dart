// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget actionSheetDefaultBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 420,
    child: LiqActionSheet(
      title: 'AirDrop',
      actions: <LiqAlertAction>[
        LiqAlertAction(label: 'Share via AirDrop', onPressed: _noop),
        LiqAlertAction(label: 'Copy Link', onPressed: _noop),
        LiqAlertAction(label: 'Add to Reading List', onPressed: _noop),
      ],
    ),
  );
  // {@endhighlight}
}

void _noop() {}
