import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  Iterable<Container> dividers(WidgetTester tester) {
    return tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(LiqCard),
            matching: find.byType(Container),
          ),
        )
        .where((Container c) => c.color == LiqCard.dividerColor);
  }

  group('LiqCard', () {
    testWidgets('renders the supplied child', (tester) async {
      await tester.pumpWidget(wrap(const LiqCard(child: Text('Body'))));
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets(
      'renders header + footer separated from child by two hairline dividers',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const LiqCard(
              header: Text('Title'),
              footer: Text('Footer'),
              child: Text('Body'),
            ),
          ),
        );

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);

        expect(dividers(tester).length, 2);
      },
    );

    testWidgets('without header/footer there are no dividers', (tester) async {
      await tester.pumpWidget(wrap(const LiqCard(child: Text('Body'))));
      expect(dividers(tester), isEmpty);
    });

    testWidgets('onTap fires on tap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(LiqCard(onTap: () => taps += 1, child: const Text('Tap me'))),
      );

      await tester.tap(find.byType(LiqCard));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('onTap=null: tap does not throw or change state', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const LiqCard(child: Text('Body'))));

      await tester.tap(find.byType(LiqCard), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('default padding is EdgeInsets.all(16)', (tester) async {
      await tester.pumpWidget(wrap(const LiqCard(child: Text('Body'))));

      final bodyPadding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Body'), matching: find.byType(Padding))
            .first,
      );
      expect(bodyPadding.padding, const EdgeInsets.all(16));
    });

    testWidgets('custom padding passes through', (tester) async {
      const custom = EdgeInsets.fromLTRB(4, 8, 12, 20);
      await tester.pumpWidget(
        wrap(const LiqCard(padding: custom, child: Text('Body'))),
      );

      final bodyPadding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Body'), matching: find.byType(Padding))
            .first,
      );
      expect(bodyPadding.padding, custom);
    });
  });
}
