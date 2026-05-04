import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget resizableVerticalBuilder(BuildContext context) {
  return const SnippetFrame(
    surface: SnippetFrameSurface.light,
    maxWidth: 480,
    height: 320,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: ColoredBox(
        color: Color(0xFFEFEFF4),
        // {@highlight}
        child: LiqResizable(
          direction: LiqResizableDirection.vertical,
          first: ColoredBox(
            color: Color(0xFFFAFAFA),
            child: Center(
              child: SnippetLabel('Top', fontWeight: FontWeight.w500),
            ),
          ),
          second: ColoredBox(
            color: Color(0xFFFFFFFF),
            child: Center(
              child: SnippetLabel('Bottom', fontWeight: FontWeight.w500),
            ),
          ),
        ),
        // {@endhighlight}
      ),
    ),
  );
}
