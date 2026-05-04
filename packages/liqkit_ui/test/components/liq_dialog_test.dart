import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

/// Build an [Overlay] tree that exposes a child [BuildContext] to the
/// test (via [contextKey]) so the imperative helper can target it.
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

void main() {
  group('LiqDialog widget', () {
    testWidgets('renders title, message, and action labels', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: LiqDialog(
              title: 'Discard changes?',
              message: 'Your edits will be lost.',
              actions: <LiqDialogAction>[
                LiqDialogAction(label: 'Cancel', onPressed: () {}),
                LiqDialogAction(
                  label: 'Discard',
                  onPressed: () {},
                  destructive: true,
                  isDefault: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Discard changes?'), findsOneWidget);
      expect(find.text('Your edits will be lost.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);
    });

    testWidgets('tapping a default action fires its onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          Center(
            child: LiqDialog(
              title: 'Hi',
              actions: <LiqDialogAction>[
                LiqDialogAction(
                  label: 'OK',
                  onPressed: () => taps++,
                  isDefault: true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('OK'));
      expect(taps, 1);
    });

    testWidgets('destructive action label renders in red', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: LiqDialog(
              title: 'Confirm',
              actions: <LiqDialogAction>[
                LiqDialogAction(
                  label: 'Delete',
                  onPressed: () {},
                  destructive: true,
                ),
              ],
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Delete'));
      expect(textWidget.style?.color, LiqDialog.destructiveActionColor);
    });

    testWidgets('uses dark theme colors for title message and action', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            Center(
              child: LiqDialog(
                title: 'Dark dialog',
                message: 'Secondary copy',
                actions: <LiqDialogAction>[
                  LiqDialogAction(label: 'OK', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Dark dialog')).style?.color,
        const Color(0xFFFFFFFF),
      );
      expect(
        tester.widget<Text>(find.text('Secondary copy')).style?.color,
        const Color(0xB2EBEBF5),
      );
      expect(
        tester.widget<Text>(find.text('OK')).style?.color,
        const Color(0xFF0091FF),
      );
    });
  });

  group('LiqDialogOverlay.show', () {
    testWidgets('inserts an entry showing the dialog title', (tester) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDialogOverlay.show(
          context: ctxKey.currentContext!,
          title: 'Hello',
          message: 'World',
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);

      // Settle by dismissing.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping the scrim dismisses when barrierDismissible: true', (
      tester,
    ) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDialogOverlay.show(
          context: ctxKey.currentContext!,
          title: 'Dismiss me',
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Dismiss me'), findsOneWidget);

      // Tap the scrim well outside the centered dialog.
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss me'), findsNothing);
    });

    testWidgets('tap on scrim does nothing when barrierDismissible: false', (
      tester,
    ) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDialogOverlay.show(
          context: ctxKey.currentContext!,
          title: 'Sticky',
          barrierDismissible: false,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Sticky'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Sticky'), findsOneWidget);

      // Settle via Escape key.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    });

    testWidgets('Escape key dismisses the dialog', (tester) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDialogOverlay.show(
          context: ctxKey.currentContext!,
          title: 'Esc test',
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Esc test'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Esc test'), findsNothing);
    });
  });
}
