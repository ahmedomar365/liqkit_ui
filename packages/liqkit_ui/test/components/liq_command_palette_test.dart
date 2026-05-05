import 'dart:async';

import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[OverlayEntry(builder: (_) => child)],
      ),
    ),
  );
}

Widget _withOverlay(GlobalKey contextKey) {
  return _wrap(
    Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext context) => SizedBox.expand(key: contextKey),
        ),
      ],
    ),
  );
}

List<LiqCommand> _flatCommands(VoidCallback onNew) {
  return <LiqCommand>[
    LiqCommand(
      label: 'New project',
      icon: Icons.add,
      shortcut: '⌘N',
      onSelected: onNew,
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
  ];
}

Color? _rowBackgroundOf(WidgetTester tester, String label) {
  final container = tester.widget<Container>(
    find.ancestor(of: find.text(label), matching: find.byType(Container)).first,
  );
  return container.color;
}

void main() {
  group('LiqCommandPalette widget', () {
    testWidgets('renders all command labels initially', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(commands: _flatCommands(() {})),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('New project'), findsOneWidget);
      expect(find.text('Open recent'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('typing a query filters to matching commands', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(commands: _flatCommands(() {})),
            ),
          ),
        ),
      );
      await tester.pump();

      final editable = find.byType(EditableText).first;
      await tester.enterText(editable, 'sett');
      await tester.pump();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('New project'), findsNothing);
      expect(find.text('Open recent'), findsNothing);
    });

    testWidgets('"No commands found" appears when filter is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(commands: _flatCommands(() {})),
            ),
          ),
        ),
      );
      await tester.pump();

      final editable = find.byType(EditableText).first;
      await tester.enterText(editable, 'zzzzzz');
      await tester.pump();

      expect(find.text('No commands found'), findsOneWidget);
    });

    testWidgets("tap on a row fires that command's onSelected", (tester) async {
      var newProjectFired = 0;
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(
                commands: _flatCommands(() => newProjectFired++),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('New project'));
      expect(newProjectFired, 1);
    });

    testWidgets('rows expose click cursors', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(commands: _flatCommands(() {})),
            ),
          ),
        ),
      );
      await tester.pump();

      final mouseRegions = tester.widgetList<MouseRegion>(
        find.byType(MouseRegion),
      );
      expect(
        mouseRegions.where(
          (region) => region.cursor == SystemMouseCursors.click,
        ),
        hasLength(3),
      );
    });

    testWidgets('clear button exposes a click cursor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(commands: _flatCommands(() {})),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(EditableText).first, 'sett');
      await tester.pump();

      final mouseRegions = tester.widgetList<MouseRegion>(
        find.byType(MouseRegion),
      );
      expect(
        mouseRegions.where(
          (region) => region.cursor == SystemMouseCursors.click,
        ),
        hasLength(2),
      );
    });

    testWidgets('Up/Down arrow keys move the active highlight', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(commands: _flatCommands(() {})),
            ),
          ),
        ),
      );
      // Allow post-frame focus request to settle.
      await tester.pumpAndSettle();

      // Initially the first row ("New project") is active.
      expect(
        _rowBackgroundOf(tester, 'New project'),
        equals(LiqCommandPalette.activeRowBackgroundColor),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      expect(
        _rowBackgroundOf(tester, 'Open recent'),
        equals(LiqCommandPalette.activeRowBackgroundColor),
      );
      // First row should no longer have the active background.
      expect(
        _rowBackgroundOf(tester, 'New project'),
        isNot(equals(LiqCommandPalette.activeRowBackgroundColor)),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(
        _rowBackgroundOf(tester, 'New project'),
        equals(LiqCommandPalette.activeRowBackgroundColor),
      );
    });

    testWidgets('Enter triggers the active command', (tester) async {
      var newProjectFired = 0;
      var openRecentFired = 0;
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(
                commands: <LiqCommand>[
                  LiqCommand(
                    label: 'New project',
                    onSelected: () => newProjectFired++,
                  ),
                  LiqCommand(
                    label: 'Open recent',
                    onSelected: () => openRecentFired++,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(newProjectFired, 0);
      expect(openRecentFired, 1);
    });

    testWidgets('section headers appear when commands have section set', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 560,
              height: 360,
              child: LiqCommandPalette(
                commands: <LiqCommand>[
                  LiqCommand(
                    label: 'New project',
                    section: 'File',
                    onSelected: () {},
                  ),
                  LiqCommand(
                    label: 'Open recent',
                    section: 'File',
                    onSelected: () {},
                  ),
                  LiqCommand(label: 'Cut', section: 'Edit', onSelected: () {}),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('FILE'), findsOneWidget);
      expect(find.text('EDIT'), findsOneWidget);
      expect(find.text('New project'), findsOneWidget);
      expect(find.text('Cut'), findsOneWidget);
    });

    testWidgets('uses dark theme colors for rows, icons, and shortcuts', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            Center(
              child: SizedBox(
                width: 560,
                height: 360,
                child: LiqCommandPalette(commands: _flatCommands(() {})),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final label = tester.widget<Text>(find.text('New project'));
      expect(label.style?.color, const Color(0xFFFFFFFF));

      final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
      expect(searchIcon.color, const Color(0xB2EBEBF5));

      final activeRow = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('New project'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(activeRow.color, const Color(0xB2EBEBF5).withValues(alpha: 0.14));

      final shortcutText = tester.widget<Text>(find.text('⌘N'));
      expect(shortcutText.style?.color, const Color(0xB2EBEBF5));
    });

    testWidgets('uses an explicit Liquid Glass surface recipe', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            Center(
              child: SizedBox(
                width: 560,
                height: 360,
                child: LiqCommandPalette(commands: _flatCommands(() {})),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final glass = tester.widget<LiqGlassSurface>(
        find.byType(LiqGlassSurface),
      );
      expect(glass.borderRadius, const BorderRadius.all(Radius.circular(34)));
      expect(glass.blurSigma, 20);
      expect(glass.baseFill, isNull);
      expect(glass.highlightStart, isNull);
    });
  });

  group('LiqCommandPalette.show', () {
    testWidgets('Escape dismisses the palette when shown via .show()', (
      tester,
    ) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqCommandPalette.show(
          context: ctxKey.currentContext!,
          commands: <LiqCommand>[
            LiqCommand(label: 'Esc target', onSelected: () {}),
          ],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Esc target'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Esc target'), findsNothing);
    });
  });
}
