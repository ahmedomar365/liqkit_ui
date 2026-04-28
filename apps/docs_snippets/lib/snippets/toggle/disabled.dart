import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleDisabledBuilder(BuildContext context) {
  // {@highlight}
  return const Center(child: LiqToggle(value: true, onChanged: null));
  // {@endhighlight}
}
