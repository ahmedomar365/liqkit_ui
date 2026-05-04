import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget menuDefaultBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    child: LiqMenu(
      quickActions: <LiqMenuQuickAction>[
        LiqMenuQuickAction(
          label: 'Copy',
          icon: const Text('C'),
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Share',
          icon: const Text('S'),
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Delete',
          icon: const Text('D'),
          destructive: true,
          onPressed: () {},
        ),
      ],
      children: <Widget>[
        LiqMenuItem(
          label: 'Copy',
          trailing: const Text('Cmd C'),
          onPressed: () {},
        ),
        LiqMenuItem(
          label: 'Paste',
          trailing: const Text('Cmd V'),
          onPressed: () {},
        ),
        const LiqMenuItem(label: 'Disabled Action', trailing: Text('Cmd B')),
        const LiqMenuSeparator(),
        LiqMenuItem(
          label: 'Delete',
          trailing: const Text('Del'),
          style: LiqMenuItemStyle.destructive,
          onPressed: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
