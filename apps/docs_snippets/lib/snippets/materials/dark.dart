import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget materialsDarkBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: ColoredBox(
      color: Color(0xFF1C1C1E),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: LiqMaterialChip(brightness: LiqMaterialBrightness.dark),
      ),
    ),
  );
  // {@endhighlight}
}
