import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popupButtonRegularBuilder(BuildContext context) {
  // {@highlight}
  return Center(child: LiqPopupButton(label: 'Today', onPressed: () {}));
  // {@endhighlight}
}
