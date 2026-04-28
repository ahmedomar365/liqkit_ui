import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget stepperDefaultBuilder(BuildContext context) {
  // {@highlight}
  return Center(child: LiqStepper(value: 3, onChanged: (_) {}));
  // {@endhighlight}
}
