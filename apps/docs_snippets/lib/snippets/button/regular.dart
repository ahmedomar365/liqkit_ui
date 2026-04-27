import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget buttonRegularBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqButton(
      label: 'Regular',
      onPressed: () {},
    ),
  );
  // {@endhighlight}
}
