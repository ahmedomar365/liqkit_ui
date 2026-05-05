// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget kitHelpersModePillBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 220,
    height: 72,
    surface: SnippetFrameSurface.themed,
    surfacePadding: EdgeInsets.symmetric(horizontal: 18),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LiqKitHelpersModePill(label: 'Light'),
        SizedBox(width: 12),
        LiqKitHelpersModePill(
          label: 'Dark',
          brightness: LiqKitHelpersBrightness.dark,
        ),
      ],
    ),
  );
  // {@endhighlight}
}
