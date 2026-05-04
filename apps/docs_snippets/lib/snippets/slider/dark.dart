import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sliderDarkBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 420,
    surface: SnippetFrameSurface.dark,
    surfacePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: LiqDemo<double>(
      initial: 0.6,
      builder: (v, set) {
        // {@highlight}
        return LiqSlider(value: v, onChanged: set, brightness: Brightness.dark);
        // {@endhighlight}
      },
    ),
  );
}
