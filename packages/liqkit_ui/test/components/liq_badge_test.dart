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

  Color backgroundOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(LiqBadge),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = box.decoration as BoxDecoration;
    return decoration.color!;
  }

  group('LiqBadge', () {
    testWidgets('renders the supplied label', (tester) async {
      await tester.pumpWidget(wrap(const LiqBadge(label: 'New')));
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('count: 5 renders "5"', (tester) async {
      await tester.pumpWidget(wrap(const LiqBadge(count: 5)));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('count: 100 clamps to "99+"', (tester) async {
      await tester.pumpWidget(wrap(const LiqBadge(count: 100)));
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('100'), findsNothing);
    });

    testWidgets('count: 0 renders "0"', (tester) async {
      await tester.pumpWidget(wrap(const LiqBadge(count: 0)));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('count: -1 renders "0"', (tester) async {
      await tester.pumpWidget(wrap(const LiqBadge(count: -1)));
      expect(find.text('0'), findsOneWidget);
      expect(find.text('-1'), findsNothing);
    });

    testWidgets('dot: true ignores label/count and renders 8x8', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Align(
            alignment: Alignment.topLeft,
            child: LiqBadge(label: 'New', count: 5, dot: true),
          ),
        ),
      );
      expect(find.text('New'), findsNothing);
      expect(find.text('5'), findsNothing);
      expect(
        tester.getSize(find.byType(LiqBadge)),
        const Size(LiqBadge.dotSize, LiqBadge.dotSize),
      );
    });

    testWidgets('variant maps to expected background color', (tester) async {
      Future<Color> measure(LiqBadgeVariant variant) async {
        await tester.pumpWidget(wrap(LiqBadge(label: 'X', variant: variant)));
        return backgroundOf(tester);
      }

      expect(
        await measure(LiqBadgeVariant.neutral),
        equals(LiqBadge.neutralBackground),
      );
      expect(
        await measure(LiqBadgeVariant.primary),
        equals(LiqBadge.primaryBackground),
      );
      expect(
        await measure(LiqBadgeVariant.success),
        equals(LiqBadge.successBackground),
      );
      expect(
        await measure(LiqBadgeVariant.warning),
        equals(LiqBadge.warningBackground),
      );
      expect(
        await measure(LiqBadgeVariant.destructive),
        equals(LiqBadge.destructiveBackground),
      );
    });

    testWidgets('dark theme resolves dynamic iOS badge colors', (tester) async {
      Future<Color> measure(LiqBadgeVariant variant) async {
        await tester.pumpWidget(
          wrapDark(LiqBadge(label: 'X', variant: variant)),
        );
        return backgroundOf(tester);
      }

      expect(
        await measure(LiqBadgeVariant.neutral),
        equals(LiqBadge.darkNeutralBackground),
      );
      expect(
        await measure(LiqBadgeVariant.primary),
        equals(const Color(0xFF0091FF)),
      );
      expect(
        await measure(LiqBadgeVariant.success),
        equals(LiqBadge.darkSuccessBackground),
      );
      expect(
        await measure(LiqBadgeVariant.warning),
        equals(LiqBadge.darkWarningBackground),
      );
      expect(
        await measure(LiqBadgeVariant.destructive),
        equals(LiqBadge.darkDestructiveBackground),
      );
    });

    testWidgets('dark neutral badge keeps white foreground text', (
      tester,
    ) async {
      await tester.pumpWidget(wrapDark(const LiqBadge(label: 'New')));

      final label = tester.widget<Text>(find.text('New'));
      expect(label.style?.color, LiqBadge.contrastForeground);
    });

    test('label/count/dot all-null throws AssertionError', () {
      expect(LiqBadge.new, throwsAssertionError);
    });
  });
}
