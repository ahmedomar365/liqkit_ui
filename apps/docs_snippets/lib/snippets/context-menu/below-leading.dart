// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget contextMenuBelowLeadingBuilder(BuildContext context) {
  // {@highlight}
  return Align(
    heightFactor: 1,
    child: LiqContextMenu(
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
