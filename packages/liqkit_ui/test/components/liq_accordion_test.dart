import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  Widget wrapDark(Widget child) => LiqTheme(
    data: LiqThemeData.dark,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('LiqAccordion', () {
    testWidgets('tapping a header expands its body', (tester) async {
      await tester.pumpWidget(
        wrap(
          const LiqAccordion(
            items: <LiqAccordionItem>[
              LiqAccordionItem(title: 'A', child: Text('body-a')),
              LiqAccordionItem(title: 'B', child: Text('body-b')),
            ],
          ),
        ),
      );

      expect(find.text('body-a'), findsNothing);
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(find.text('body-a'), findsOneWidget);
    });

    testWidgets('single mode collapses the previously open item', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const LiqAccordion(
            items: <LiqAccordionItem>[
              LiqAccordionItem(title: 'A', child: Text('body-a')),
              LiqAccordionItem(title: 'B', child: Text('body-b')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(find.text('body-a'), findsOneWidget);

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(find.text('body-b'), findsOneWidget);
      expect(find.text('body-a'), findsNothing);
    });

    testWidgets('multiple mode keeps both items expanded', (tester) async {
      await tester.pumpWidget(
        wrap(
          const LiqAccordion(
            type: LiqAccordionType.multiple,
            items: <LiqAccordionItem>[
              LiqAccordionItem(title: 'A', child: Text('body-a')),
              LiqAccordionItem(title: 'B', child: Text('body-b')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(find.text('body-a'), findsOneWidget);
      expect(find.text('body-b'), findsOneWidget);
    });

    testWidgets('initialExpanded renders that item open on first build', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const LiqAccordion(
            initialExpanded: <int>{0},
            items: <LiqAccordionItem>[
              LiqAccordionItem(title: 'A', child: Text('body-a')),
              LiqAccordionItem(title: 'B', child: Text('body-b')),
            ],
          ),
        ),
      );

      expect(find.text('body-a'), findsOneWidget);
      expect(find.text('body-b'), findsNothing);
    });

    testWidgets('dark theme resolves title, subtitle, and divider colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapDark(
          const LiqAccordion(
            items: <LiqAccordionItem>[
              LiqAccordionItem(
                title: 'A',
                subtitle: 'Details',
                child: Text('body-a'),
              ),
              LiqAccordionItem(title: 'B', child: Text('body-b')),
            ],
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('A')).style?.color,
        const Color(0xFFFFFFFF),
      );
      expect(
        tester.widget<Text>(find.text('Details')).style?.color,
        const Color(0xB2EBEBF5),
      );

      final divider = tester.widget<DecoratedBox>(
        find.byWidgetPredicate((widget) {
          if (widget is! DecoratedBox) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration &&
              decoration.color == const Color(0x29FFFFFF);
        }),
      );
      expect(
        (divider.decoration as BoxDecoration).color,
        const Color(0x29FFFFFF),
      );
    });
  });
}
