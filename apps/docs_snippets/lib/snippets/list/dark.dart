import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget listDarkBuilder(BuildContext context) {
  // {@highlight}
  return ColoredBox(
    color: const Color(0xFF000000),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
      ),
    ),
  );
  // {@endhighlight}
}
