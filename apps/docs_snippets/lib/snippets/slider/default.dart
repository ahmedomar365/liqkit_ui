import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sliderDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    surface: SnippetFrameSurface.light,
    child: LiqDemo<double>(
      initial: 0.4,
      builder: (v, set) {
        // {@highlight}
        return LiqSlider(
          value: v,
          onChanged: set,
          brightness: Brightness.light,
        );
        // {@endhighlight}
      },
    ),
  );
}
