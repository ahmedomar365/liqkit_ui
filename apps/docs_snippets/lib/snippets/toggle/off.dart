import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleOffBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: LiqDemo<bool>(
      initial: false,
      builder: (v, set) {
        // {@highlight}
        return LiqToggle(value: v, onChanged: set);
        // {@endhighlight}
      },
    ),
  );
}
