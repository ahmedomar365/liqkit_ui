import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget menuDefaultBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqMenu(
      children: <Widget>[
        LiqMenuItem(label: 'Copy', onPressed: () {}),
        LiqMenuItem(label: 'Paste', onPressed: () {}),
        LiqMenuItem(label: 'Select All', onPressed: () {}),
        LiqMenuItem(
          label: 'Delete',
          style: LiqMenuItemStyle.destructive,
          onPressed: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
