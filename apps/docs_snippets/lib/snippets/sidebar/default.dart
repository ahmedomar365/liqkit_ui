import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sidebarDefaultBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqSidebar(
      children: <Widget>[
        const LiqSidebarSectionHeader(title: 'Mailboxes'),
        LiqSidebarRow(
          title: 'Inbox',
          detail: '12',
          selected: true,
          onPressed: () {},
        ),
        LiqSidebarRow(title: 'Sent', onPressed: () {}),
        LiqSidebarRow(title: 'Drafts', detail: '3', onPressed: () {}),
        LiqSidebarRow(title: 'Trash', onPressed: () {}),
      ],
    ),
  );
  // {@endhighlight}
}
