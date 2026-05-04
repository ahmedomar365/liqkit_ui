import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget buttonGlassBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 560,
    height: 172,
    surface: SnippetFrameSurface.liquidLight,
    // {@highlight}
    child: LiqButton(
      label: 'Glass',
      style: LiqButtonStyle.liquid,
      onPressed: () {},
    ),
    // {@endhighlight}
  );
}
