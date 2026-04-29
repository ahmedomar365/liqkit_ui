import 'dart:async';

import 'package:flutter/material.dart' show Icons;
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
          builder: (BuildContext context) =>
              SizedBox.expand(key: contextKey),
        ),
      ],
    ),
  );
}

void main() {
  group('LiqToast widget', () {
    testWidgets('renders the message text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Center(
            child: LiqToast(message: 'Saved', variant: LiqToastVariant.success),
          ),
        ),
      );
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('default icon for success is check_circle_outline', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const Center(
            child: LiqToast(message: 'ok', variant: LiqToastVariant.success),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.check_circle_outline);
    });

    testWidgets('default icon for error is error_outline', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Center(
            child: LiqToast(message: 'bad', variant: LiqToastVariant.error),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.error_outline);
    });

    testWidgets('default icon for info is info_outline', (tester) async {
      await tester.pumpWidget(
        _wrap(const Center(child: LiqToast(message: 'fyi'))),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.info_outline);
    });

    testWidgets('custom icon overrides default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Center(child: LiqToast(message: 'custom', icon: Icons.star)),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.star);
    });
  });

  group('LiqToastOverlay.show', () {
    testWidgets('inserts overlay entry containing the message', (tester) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      // Fire-and-forget the show — do not await, since it only completes
      // after the toast has fully dismissed.
      unawaited(LiqToastOverlay.show(ctxKey.currentContext!, 'Hello'));
      await tester.pump();
      // Past the slide-up animation (240ms) so the toast is on screen.
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Hello'), findsOneWidget);

      // Pump well past duration + dismiss animation to settle.
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('removes the toast after duration elapses', (tester) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqToastOverlay.show(
          ctxKey.currentContext!,
          'Bye',
          duration: const Duration(milliseconds: 600),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Bye'), findsOneWidget);

      // Past duration + dismiss animation.
      await tester.pump(const Duration(milliseconds: 850));
      await tester.pumpAndSettle();
      expect(find.text('Bye'), findsNothing);
    });

    testWidgets('a second show dismisses the first', (tester) async {
      final ctxKey = GlobalKey();
      await tester.pumpWidget(_withOverlay(ctxKey));
      await tester.pump();

      unawaited(
        LiqToastOverlay.show(
          ctxKey.currentContext!,
          'First',
          duration: const Duration(seconds: 5),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('First'), findsOneWidget);

      unawaited(
        LiqToastOverlay.show(
          ctxKey.currentContext!,
          'Second',
          duration: const Duration(seconds: 5),
        ),
      );
      // Allow first to dismiss + second to show.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);

      // Settle.
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });
  });
}
