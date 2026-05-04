import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget listDarkBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 420,
    surface: SnippetFrameSurface.dark,
    surfacePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: LiqListGroup(
      brightness: Brightness.dark,
      rows: <LiqListRow>[
        LiqListRow(
          title: 'Notifications',
          detail: 'On',
          showChevron: true,
          brightness: Brightness.dark,
          onTap: () {},
        ),
        LiqListRow(
          title: 'Sound',
          detail: 'Chime',
          showChevron: true,
          brightness: Brightness.dark,
          onTap: () {},
        ),
        LiqListRow(
          title: 'Badge App Icon',
          showChevron: true,
          brightness: Brightness.dark,
          onTap: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
