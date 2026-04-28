import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget colorPickerGridBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: LiqColorGrid(
        colors: const <Color>[
          Color(0xFFFF3B30),
          Color(0xFFFF9500),
          Color(0xFFFFCC00),
          Color(0xFF34C759),
          Color(0xFF00C7BE),
          Color(0xFF30B0C7),
          Color(0xFF32ADE6),
          Color(0xFF0088FF),
          Color(0xFF5856D6),
          Color(0xFFAF52DE),
          Color(0xFFFF2D55),
          Color(0xFFA2845E),
        ],
        selectedIndex: 7,
        onSelected: (_) {},
      ),
    ),
  );
  // {@endhighlight}
}
