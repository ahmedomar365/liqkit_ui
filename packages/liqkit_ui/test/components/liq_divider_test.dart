import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );

  // The visible hairline is rendered by a single [Container] descendant
  // of the [LiqDivider]; reading its margin and computed size lets us
  // assert thickness and indent behavior.
  Container innerContainer(WidgetTester tester, Finder divider) {
    return tester.widget<Container>(
      find.descendant(of: divider, matching: find.byType(Container)),
    );
  }

  group('LiqDivider', () {
    testWidgets('horizontal divider has height equal to thickness', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const SizedBox(width: 200, child: LiqDivider())),
      );

      final size = tester.getSize(find.byType(LiqDivider));
      expect(size.height, LiqDivider.thickness);
    });

    testWidgets('vertical divider has width equal to thickness', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            height: 200,
            child: LiqDivider(orientation: LiqDividerOrientation.vertical),
          ),
        ),
      );

      final size = tester.getSize(find.byType(LiqDivider));
      expect(size.width, LiqDivider.thickness);
    });

    testWidgets('horizontal indent + endIndent become left/right margins', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 200,
            child: LiqDivider(indent: 16, endIndent: 24),
          ),
        ),
      );

      final container = innerContainer(tester, find.byType(LiqDivider));
      final margin = container.margin! as EdgeInsets;
      expect(margin.left, 16);
      expect(margin.right, 24);
      expect(margin.top, 0);
      expect(margin.bottom, 0);
    });

    testWidgets('vertical indent + endIndent become top/bottom margins', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            height: 200,
            child: LiqDivider(
              orientation: LiqDividerOrientation.vertical,
              indent: 8,
              endIndent: 12,
            ),
          ),
        ),
      );

      final container = innerContainer(tester, find.byType(LiqDivider));
      final margin = container.margin! as EdgeInsets;
      expect(margin.top, 8);
      expect(margin.bottom, 12);
      expect(margin.left, 0);
      expect(margin.right, 0);
    });
  });

  group('LiqLabeledDivider', () {
    testWidgets('renders the label between two LiqDivider lines', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const SizedBox(width: 320, child: LiqLabeledDivider(label: 'OR'))),
      );

      expect(find.text('OR'), findsOneWidget);
      expect(find.byType(LiqDivider), findsNWidgets(2));
    });
  });
}
