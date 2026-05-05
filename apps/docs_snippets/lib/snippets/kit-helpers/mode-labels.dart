// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget kitHelpersModeLabelsBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 160,
    height: 150,
    surface: SnippetFrameSurface.themed,
    surfacePadding: EdgeInsets.all(18),
    child: LiqKitHelpersModeLabels(
      children: <Widget>[
        LiqKitHelpersModePill(label: 'Light'),
        LiqKitHelpersModePill(
          label: 'Dark',
          brightness: LiqKitHelpersBrightness.dark,
        ),
      ],
    ),
  );
  // {@endhighlight}
}
