// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget glassSurfaceDarkBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 400,
    height: 200,
    surface: SnippetFrameSurface.liquidDark,
    surfacePadding: EdgeInsets.all(24),
    // {@highlight}
    child: LiqGlassSurface(
      tint: LiqGlassTint.dark,
      padding: EdgeInsets.all(24),
      child: SizedBox(
        width: 240,
        child: SnippetLabel(
          'Dark Liquid Glass — used by action sheets in dark mode, '
          'the dark status bar, and other surfaces overlaid on '
          'dark content.',
          fontSize: 14,
        ),
      ),
    ),
    // {@endhighlight}
  );
}
