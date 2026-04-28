import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget listGroupedBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          LiqListRow(
            title: 'Badge App Icon',
            showChevron: true,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
  // {@endhighlight}
}
