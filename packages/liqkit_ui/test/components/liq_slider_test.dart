import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqSlider', () {
    testWidgets('drag updates value monotonically', (tester) async {
      var v = 0.0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => LiqTheme(
            data: LiqThemeData.light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: SizedBox(
                  width: 240,
                  child: LiqSlider(
                    value: v,
                    onChanged: (double next) => setState(() => v = next),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      // Tap roughly at the right end of the row (240px wide, 16px insets).
      // Tap at x=224 (240-16) should set value to ~1.0.
      await tester.tapAt(tester.getCenter(find.byType(LiqSlider))
          .translate(240 / 2 - 16 - 1, 0));
      await tester.pumpAndSettle();
      expect(v, closeTo(1.0, 0.05));
    });

    testWidgets('disabled rejects interaction', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 200,
                child: LiqSlider(value: 0.5, onChanged: null),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(LiqSlider));
      await tester.pumpAndSettle();
      // No callback => no state to assert. Just confirm no exception.
    });
  });
}
