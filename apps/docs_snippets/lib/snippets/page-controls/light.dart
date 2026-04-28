import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget pageControlsLightBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqPageControl(
      count: 5,
      activeIndex: 2,
    ),
  );
  // {@endhighlight}
}
