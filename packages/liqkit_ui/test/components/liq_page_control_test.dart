import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqPageControl', () {
    testWidgets('count <= maxVisible renders one dot per page', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqPageControl(count: 5, activeIndex: 2),
            ),
          ),
        ),
      );
      // 5 dots are rendered as a single LiqPageControl widget; we
      // assert via Semantics that the value message reflects the
      // active index.
      final semantics = tester.getSemantics(find.byType(LiqPageControl));
      expect(semantics.value, '3 of 5');
    });

    testWidgets('count > maxVisible centers around activeIndex',
        (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqPageControl(
                count: 20,
                activeIndex: 10,
              ),
            ),
          ),
        ),
      );
      final semantics = tester.getSemantics(find.byType(LiqPageControl));
      expect(semantics.value, '11 of 20');
    });

    testWidgets('count==0 collapses to empty', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqPageControl(count: 0, activeIndex: 0),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(LiqPageControl)), Size.zero);
    });
  });
}
