import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('LiqCollapsible', () {
    testWidgets('body is not visible by default', (tester) async {
      await tester.pumpWidget(
        wrap(const LiqCollapsible(header: Text('header'), child: Text('body'))),
      );

      expect(find.text('header'), findsOneWidget);
      expect(find.text('body'), findsNothing);
    });

    testWidgets('body is visible when initiallyExpanded is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const LiqCollapsible(
            initiallyExpanded: true,
            header: Text('header'),
            child: Text('body'),
          ),
        ),
      );

      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('tapping the header toggles body visibility', (tester) async {
      await tester.pumpWidget(
        wrap(const LiqCollapsible(header: Text('header'), child: Text('body'))),
      );

      expect(find.text('body'), findsNothing);

      await tester.tap(find.text('header'));
      await tester.pumpAndSettle();
      expect(find.text('body'), findsOneWidget);

      await tester.tap(find.text('header'));
      await tester.pumpAndSettle();
      expect(find.text('body'), findsNothing);
    });

    testWidgets('onChanged fires with the new expanded value', (tester) async {
      final events = <bool>[];
      await tester.pumpWidget(
        wrap(
          LiqCollapsible(
            header: const Text('header'),
            onChanged: events.add,
            child: const Text('body'),
          ),
        ),
      );

      await tester.tap(find.text('header'));
      await tester.pumpAndSettle();
      expect(events, <bool>[true]);

      await tester.tap(find.text('header'));
      await tester.pumpAndSettle();
      expect(events, <bool>[true, false]);
    });

    testWidgets('onChanged null does not crash; state still toggles', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const LiqCollapsible(header: Text('header'), child: Text('body'))),
      );

      await tester.tap(find.text('header'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('chevron rotates 90 degrees on expand', (tester) async {
      await tester.pumpWidget(
        wrap(const LiqCollapsible(header: Text('header'), child: Text('body'))),
      );

      AnimatedRotation rotation() =>
          tester.widget<AnimatedRotation>(find.byType(AnimatedRotation));

      expect(rotation().turns, 0.0);

      await tester.tap(find.text('header'));
      await tester.pumpAndSettle();

      expect(rotation().turns, 0.25);
    });
  });
}
