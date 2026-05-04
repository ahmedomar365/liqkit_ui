// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dialogDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    height: 220,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: const ColoredBox(
        color: Color(0xFFEFEFF4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: ColoredBox(color: Color(0x66000000))),
            Center(
              // {@highlight}
              child: LiqDialog(
                title: 'Discard changes?',
                message: 'Your edits will be lost. This cannot be undone.',
              ),
              // {@endhighlight}
            ),
          ],
        ),
      ),
    ),
  );
}
