import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget pageControlsDarkBuilder(BuildContext context) {
  // {@highlight}
  return const ColoredBox(
    color: Color(0xFF1C1C1E),
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: LiqPageControl(
          count: 5,
          activeIndex: 2,
          brightness: LiqPageControlBrightness.dark,
        ),
      ),
    ),
  );
  // {@endhighlight}
}
