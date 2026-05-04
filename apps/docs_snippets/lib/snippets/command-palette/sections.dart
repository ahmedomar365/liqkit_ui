// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget commandPaletteSectionsBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 560,
    height: 420,
    child: Stack(
      children: <Widget>[
        const Positioned.fill(child: ColoredBox(color: Color(0xFFEFEFF4))),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            // {@highlight}
            child: LiqCommandPalette(
              commands: <LiqCommand>[
                LiqCommand(
                  label: 'New project',
                  section: 'File',
                  icon: Icons.add,
                  shortcut: '⌘N',
                  onSelected: () {},
                ),
                LiqCommand(
                  label: 'Open recent',
                  section: 'File',
                  icon: Icons.folder_open,
                  shortcut: '⌘O',
                  onSelected: () {},
                ),
                LiqCommand(
                  label: 'Cut',
                  section: 'Edit',
                  icon: Icons.content_cut,
                  shortcut: '⌘X',
                  onSelected: () {},
                ),
                LiqCommand(
                  label: 'Copy',
                  section: 'Edit',
                  icon: Icons.content_copy,
                  shortcut: '⌘C',
                  onSelected: () {},
                ),
                LiqCommand(
                  label: 'Toggle sidebar',
                  section: 'View',
                  icon: Icons.view_sidebar,
                  shortcut: '⌘B',
                  onSelected: () {},
                ),
              ],
            ),
            // {@endhighlight}
          ),
        ),
      ],
    ),
  );
}
