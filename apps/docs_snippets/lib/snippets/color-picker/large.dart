import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget colorPickerLargeBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqColorPickerButton(
      color: const Color(0xFF0088FF),
      onPressed: () {},
    ),
  );
  // {@endhighlight}
}
