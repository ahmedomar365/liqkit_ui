// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget glassSurfaceFloatingBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 400,
    height: 200,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: EdgeInsets.all(24),
    // {@highlight}
    child: LiqGlassSurface(
      padding: EdgeInsets.all(24),
      child: SizedBox(
        width: 240,
        child: SnippetLabel(
          'Liquid Glass — translucent surface with backdrop blur, '
          'a uniform material tint, and a hairline rim.',
          fontSize: 14,
        ),
      ),
    ),
    // {@endhighlight}
  );
}
