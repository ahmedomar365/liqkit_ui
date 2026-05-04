// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget activityViewDefaultBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 420,
    child: LiqActivitySheet(
      header: LiqActivityHeader(
        title: 'Design System.sketch',
        subtitle: '4.2 MB',
        onClose: () {},
      ),
      child: const SnippetLabel('Share this file with your team.'),
    ),
  );
  // {@endhighlight}
}
