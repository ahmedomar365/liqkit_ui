import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textStylesDynamicBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqTypeColumn(
      header: 'Dynamic Type',
      scale: LiqDynamicTypeScale.large,
    ),
  );
  // {@endhighlight}
}
