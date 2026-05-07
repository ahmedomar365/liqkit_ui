// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget glassSurfaceFlatBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 400,
    height: 200,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: EdgeInsets.all(24),
    // {@highlight}
    child: LiqGlassSurface(
      elevation: LiqGlassElevation.flat,
      padding: EdgeInsets.all(24),
      child: SizedBox(
        width: 240,
        child: SnippetLabel(
          'Flat elevation — sits inline on its parent with no '
          'outer drop shadow. Use for sidebars, inline panels, '
          'and grouped settings rows.',
          fontSize: 14,
        ),
      ),
    ),
    // {@endhighlight}
  );
}
