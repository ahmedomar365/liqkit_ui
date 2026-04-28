import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleOnBuilder(BuildContext context) {
  return Center(
    child: LiqDemo<bool>(
      initial: true,
      builder: (v, set) {
        // {@highlight}
        return LiqToggle(value: v, onChanged: set);
        // {@endhighlight}
      },
    ),
  );
}
