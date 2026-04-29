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
  group('LiqDrawer widget', () {
    testWidgets('sizes to the requested width and aligns to the left edge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.centerLeft,
            child: LiqDrawer(width: 240, child: Text('Drawer body')),
          ),
        ),
      );

      expect(find.text('Drawer body'), findsOneWidget);
      final size = tester.getSize(find.byType(LiqDrawer));
      expect(size.width, 240);
      final topLeft = tester.getTopLeft(find.byType(LiqDrawer));
      expect(topLeft.dx, 0);
    });

    testWidgets('aligns to the right edge when side=right', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.centerRight,
            child: LiqDrawer(
              side: LiqDrawerSide.right,
              width: 240,
              child: Text('Right'),
            ),
          ),
        ),
      );

      final topRight = tester.getTopRight(find.byType(LiqDrawer));
      // Outer constraint width is 800 from the MediaQuery wrapper.
      expect(topRight.dx, 800);
    });
  });

  group('LiqDrawerOverlay.show', () {
    testWidgets('inserts an entry showing the drawer child after slide-in', (
      tester,
    ) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDrawerOverlay.show(
          context: ctxKey.currentContext!,
          child: const Text('Drawer Content'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Drawer Content'), findsOneWidget);

      // Settle by dismissing.
      await tester.tapAt(const Offset(700, 300));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping the scrim dismisses the drawer', (tester) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDrawerOverlay.show(
          context: ctxKey.currentContext!,
          child: const Text('Dismiss me'),
          width: 200,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Dismiss me'), findsOneWidget);

      // Tap the scrim well outside the drawer (to the right of x=200).
      await tester.tapAt(const Offset(700, 300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss me'), findsNothing);
    });

    testWidgets('returned future resolves when fully dismissed', (
      tester,
    ) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      var resolved = false;
      final fut = LiqDrawerOverlay.show(
        context: ctxKey.currentContext!,
        child: const Text('Future test'),
        width: 200,
      ).then((_) => resolved = true);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(resolved, false);

      await tester.tapAt(const Offset(700, 300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      await fut;
      expect(resolved, true);
    });

    testWidgets('side=right places the drawer on the right edge', (
      tester,
    ) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqDrawerOverlay.show(
          context: ctxKey.currentContext!,
          child: const Text('Right side'),
          side: LiqDrawerSide.right,
          width: 200,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final drawerFinder = find.byType(LiqDrawer);
      expect(drawerFinder, findsOneWidget);
      final topRight = tester.getTopRight(drawerFinder);
      // 800 width MediaQuery; right-anchored drawer's right edge sits at 800.
      expect(topRight.dx, 800);

      // Settle.
      await tester.tapAt(const Offset(50, 300));
      await tester.pumpAndSettle();
    });
  });

  testWidgets('Escape key dismisses the drawer', (tester) async {
    final ctxKey = GlobalKey();
    await tester.pumpWidget(_withOverlay(ctxKey));
    await tester.pump();

    unawaited(
      LiqDrawerOverlay.show(
        context: ctxKey.currentContext!,
        child: const Text('Esc test'),
        width: 200,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Esc test'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Esc test'), findsNothing);
  });
}
