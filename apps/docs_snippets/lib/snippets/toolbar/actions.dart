import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toolbarActionsBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LiqToolbar(
        leading: <Widget>[
          LiqToolbarGlassButton(
            label: 'Back',
            onPressed: () {},
          ),
        ],
        trailing: <Widget>[
          LiqToolbarGlassButton(
            label: 'Done',
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
  // {@endhighlight}
}
