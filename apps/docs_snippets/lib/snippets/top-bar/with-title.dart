// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget topBarWithTitleBuilder(BuildContext context) {
  // {@highlight}
  return Align(
    heightFactor: 1,
    child: LiqTopBar(
      title: 'Inbox',
      leading: LiqTopBarSymbolButton(glyph: '‹', onPressed: () {}),
      trailing: LiqTopBarAccentButton(glyph: '+', onPressed: () {}),
    ),
  );
  // {@endhighlight}
}
