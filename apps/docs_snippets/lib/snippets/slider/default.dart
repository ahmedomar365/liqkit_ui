import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sliderDefaultBuilder(BuildContext context) {
  return Center(
    child: LiqDemo<double>(
      initial: 0.4,
      builder: (v, set) {
        // {@highlight}
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LiqSlider(value: v, onChanged: set),
        );
        // {@endhighlight}
      },
    ),
  );
}
