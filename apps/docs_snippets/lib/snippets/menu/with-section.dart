// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget menuWithSectionBuilder(BuildContext context) {
  // {@highlight}
  return Align(
    heightFactor: 1,
    child: LiqMenu(
      children: <Widget>[
        const LiqMenuSectionTitle(title: 'Edit'),
        LiqMenuItem(label: 'Cut', onPressed: () {}),
        LiqMenuItem(label: 'Copy', onPressed: () {}),
        LiqMenuItem(label: 'Paste', onPressed: () {}),
        const LiqMenuSeparator(),
        const LiqMenuSectionTitle(title: 'Format'),
        LiqMenuItem(label: 'Bold', onPressed: () {}),
        LiqMenuItem(label: 'Italic', onPressed: () {}),
      ],
    ),
  );
  // {@endhighlight}
}
