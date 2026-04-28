// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget statusBarDarkBuilder(BuildContext context) {
  // {@highlight}
  return const ColoredBox(
    color: Color(0xFF1C1C1E),
    child: LiqStatusBar(
      brightness: Brightness.dark,
    ),
  );
  // {@endhighlight}
}
