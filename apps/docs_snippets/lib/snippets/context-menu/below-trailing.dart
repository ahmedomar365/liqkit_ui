// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget contextMenuBelowTrailingBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 360,
    height: 320,
    child: LiqContextMenu(
      arrangement: LiqContextMenuArrangement.belowTrailing,
      preview: const LiqContextMenuPreview(),
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
