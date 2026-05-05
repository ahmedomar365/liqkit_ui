// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget menuWithSectionBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 380,
    height: 620,
    surface: SnippetFrameSurface.liquidThemed,
    child: LiqMenu(
      quickActions: <LiqMenuQuickAction>[
        LiqMenuQuickAction(
          label: 'Cut',
          icon: const Icon(Icons.content_cut_rounded, size: 18),
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Copy',
          icon: const Icon(Icons.content_copy_rounded, size: 18),
          selected: true,
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Paste',
          icon: const Icon(Icons.content_paste_rounded, size: 18),
          onPressed: () {},
        ),
      ],
      children: <Widget>[
        const LiqMenuSectionTitle(title: 'Edit'),
        LiqMenuItem(
          label: 'Cut',
          icon: const Icon(Icons.content_cut_rounded),
          trailing: const Text('Cmd X'),
          onPressed: () {},
        ),
        LiqMenuItem(
          label: 'Copy',
          icon: const Icon(Icons.content_copy_rounded),
          trailing: const Text('Cmd C'),
          onPressed: () {},
        ),
        LiqMenuItem(
          label: 'Paste',
          icon: const Icon(Icons.content_paste_rounded),
          trailing: const Text('Cmd V'),
          onPressed: () {},
        ),
        const LiqMenuSeparator(),
        const LiqMenuSectionTitle(title: 'Format'),
        LiqMenuItem(
          label: 'Bold',
          icon: const Icon(Icons.format_bold_rounded),
          trailing: const Text('Cmd B'),
          onPressed: () {},
        ),
        LiqMenuItem(
          label: 'Italic',
          icon: const Icon(Icons.format_italic_rounded),
          trailing: const Text('Cmd I'),
          onPressed: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
