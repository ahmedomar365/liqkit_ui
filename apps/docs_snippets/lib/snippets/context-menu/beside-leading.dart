// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget contextMenuBesideLeadingBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 440,
    height: 260,
    child: LiqContextMenu(
      arrangement: LiqContextMenuArrangement.besideLeading,
      preview: const LiqContextMenuPreview(size: Size(132, 168)),
      menu: LiqMenu(
        children: <Widget>[
          LiqMenuItem(label: 'Share', onPressed: () {}),
          LiqMenuItem(label: 'Copy', onPressed: () {}),
          LiqMenuItem(
            label: 'Delete',
            style: LiqMenuItemStyle.destructive,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
  // {@endhighlight}
}
