// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget commandPaletteDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 560,
    height: 360,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
    // {@highlight}
    child: LiqCommandPalette(
      commands: <LiqCommand>[
        LiqCommand(
          label: 'New project',
          icon: Icons.add,
          shortcut: '⌘N',
          onSelected: () {},
        ),
        LiqCommand(
          label: 'Open recent',
          icon: Icons.folder_open,
          shortcut: '⌘O',
          onSelected: () {},
        ),
        LiqCommand(
          label: 'Settings',
          icon: Icons.settings,
          shortcut: '⌘,',
          onSelected: () {},
        ),
        LiqCommand(
          label: 'Quit',
          icon: Icons.power_settings_new,
          shortcut: '⌘Q',
          onSelected: () {},
        ),
      ],
    ),
    // {@endhighlight}
  );
}
