import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sliderDarkBuilder(BuildContext context) {
  return LiqDemo<double>(
    initial: 0.6,
    builder: (v, set) {
      // {@highlight}
      return ColoredBox(
        color: const Color(0xFF1C1C1E),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: LiqSlider(
              value: v,
              onChanged: set,
              brightness: Brightness.dark,
            ),
          ),
        ),
      );
      // {@endhighlight}
    },
  );
}
