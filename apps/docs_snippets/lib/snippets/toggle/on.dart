import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleOnBuilder(BuildContext context) {
  // {@highlight}
  return Center(child: LiqToggle(value: true, onChanged: (_) {}));
  // {@endhighlight}
}
