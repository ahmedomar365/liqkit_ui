import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toolbarChipsBuilder(BuildContext context) {
  // {@highlight}
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LiqToolbar(
        leading: <Widget>[
          LiqToolbarChip(label: 'All', onPressed: () {}),
          LiqToolbarChip(label: 'Unread', onPressed: () {}),
          LiqToolbarChip(label: 'Flagged', onPressed: () {}),
        ],
      ),
    ),
  );
  // {@endhighlight}
}
