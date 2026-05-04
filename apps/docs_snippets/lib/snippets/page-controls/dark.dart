import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget pageControlsDarkBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    surface: SnippetFrameSurface.dark,
    child: LiqPageControl(
      count: 5,
      activeIndex: 2,
      brightness: LiqPageControlBrightness.dark,
    ),
  );
  // {@endhighlight}
}
