import 'package:docs_snippets/src/materials_specimen.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget materialsDarkBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 780,
    height: 500,
    surface: SnippetFrameSurface.liquidDark,
    surfacePadding: EdgeInsets.all(40),
    child: MaterialsSpecimen(brightness: LiqMaterialBrightness.dark),
  );
  // {@endhighlight}
}
