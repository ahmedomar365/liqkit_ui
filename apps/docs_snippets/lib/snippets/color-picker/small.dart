import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget colorPickerSmallBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqColorPickerButton(
      color: const Color(0xFF34C759),
      size: LiqColorPickerButtonSize.small,
      onPressed: () {},
    ),
  );
  // {@endhighlight}
}
