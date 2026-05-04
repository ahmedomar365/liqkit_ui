// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget menuWithSectionBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    child: LiqMenu(
      quickActions: <LiqMenuQuickAction>[
        LiqMenuQuickAction(
          label: 'Cut',
          icon: const Text('X'),
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Copy',
          icon: const Text('C'),
          selected: true,
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Paste',
          icon: const Text('V'),
          onPressed: () {},
        ),
      ],
      children: <Widget>[
        const LiqMenuSectionTitle(title: 'Edit'),
        LiqMenuItem(
          label: 'Cut',
          trailing: const Text('Cmd X'),
          onPressed: () {},
        ),
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
        const LiqMenuSeparator(),
        const LiqMenuSectionTitle(title: 'Format'),
        LiqMenuItem(
          label: 'Bold',
          trailing: const Text('Cmd B'),
          onPressed: () {},
        ),
        LiqMenuItem(
          label: 'Italic',
          trailing: const Text('Cmd I'),
          onPressed: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
