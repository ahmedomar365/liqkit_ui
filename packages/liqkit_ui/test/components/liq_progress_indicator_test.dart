import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqProgressBar', () {
    testWidgets('canonical 4pt height', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 200,
                child: LiqProgressBar(value: 0.5),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(LiqProgressBar)).height, 4);
    });

    testWidgets('Semantics value reports percentage', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 200,
                child: LiqProgressBar(value: 0.42),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(LiqProgressBar)).value,
        '42%',
      );
    });
  });

  group('LiqSpinner', () {
    testWidgets('regular size is 30x30', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqSpinner()),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(LiqSpinner)),
        const Size(30, 30),
      );
      // Pump a frame so the animation controller doesn't keep the test
      // ticker alive.
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('small size is 22x22', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqSpinner(size: LiqSpinnerSize.small)),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(LiqSpinner)),
        const Size(22, 22),
      );
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
