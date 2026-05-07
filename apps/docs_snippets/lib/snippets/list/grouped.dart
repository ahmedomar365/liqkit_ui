import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget listGroupedBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 420,
    surface: SnippetFrameSurface.themed,
    surfacePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: LiqListGroup(
      rows: <LiqListRow>[
        LiqListRow(
          title: 'Notifications',
          detail: 'On',
          showChevron: true,
          onTap: () {},
        ),
        LiqListRow(
          title: 'Sound',
          detail: 'Chime',
          showChevron: true,
          onTap: () {},
        ),
        LiqListRow(title: 'Badge App Icon', showChevron: true, onTap: () {}),
      ],
    ),
  );
  // {@endhighlight}
}
