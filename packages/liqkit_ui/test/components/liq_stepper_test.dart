import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqStepper', () {
    testWidgets('+ and − tap update value', (tester) async {
      var v = 5;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => LiqTheme(
                data: LiqThemeData.light,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: LiqStepper(
                      value: v,
                      onChanged: (int next) => setState(() => v = next),
                    ),
                  ),
                ),
              ),
        ),
      );
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      expect(v, 6);
      await tester.tap(find.text('−'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('−'));
      await tester.pumpAndSettle();
      expect(v, 4);
    });

    testWidgets('respects min/max bounds', (tester) async {
      var v = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => LiqTheme(
                data: LiqThemeData.light,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: LiqStepper(
                      value: v,
                      max: 1,
                      onChanged: (int next) => setState(() => v = next),
                    ),
                  ),
                ),
              ),
        ),
      );
      // Tap minus at value=0 — should NOT decrement past min.
      await tester.tap(find.text('−'));
      await tester.pumpAndSettle();
      expect(v, 0);
      // Tap plus to reach max.
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      expect(v, 1);
      // Tap plus again — should not exceed max.
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      expect(v, 1);
    });

    testWidgets('canonical 92×32 size', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqStepper(value: 5, onChanged: (int _) {})),
          ),
        ),
      );
      final size = tester.getSize(find.byType(LiqStepper));
      expect(size.width, 92);
      expect(size.height, 32);
    });
  });
}
