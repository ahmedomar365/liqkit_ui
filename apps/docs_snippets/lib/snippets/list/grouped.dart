import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget listGroupedBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 420,
    surface: SnippetFrameSurface.light,
    surfacePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: LiqListGroup(
      brightness: Brightness.light,
      rows: <LiqListRow>[
        LiqListRow(
          title: 'Notifications',
          detail: 'On',
          showChevron: true,
          brightness: Brightness.light,
          onTap: () {},
        ),
        LiqListRow(
          title: 'Sound',
          detail: 'Chime',
          showChevron: true,
          brightness: Brightness.light,
          onTap: () {},
        ),
        LiqListRow(
          title: 'Badge App Icon',
          showChevron: true,
          brightness: Brightness.light,
          onTap: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
