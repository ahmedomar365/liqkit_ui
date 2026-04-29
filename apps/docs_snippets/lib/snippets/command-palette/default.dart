// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget commandPaletteDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 560,
        height: 360,
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
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
