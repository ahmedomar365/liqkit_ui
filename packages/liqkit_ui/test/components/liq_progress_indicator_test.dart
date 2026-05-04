import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child, {LiqThemeData data = LiqThemeData.light}) {
    return LiqTheme(
      data: data,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 200, child: child)),
      ),
    );
  }

  Color progressDecorationColorAt(WidgetTester tester, int index) {
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(LiqProgressBar),
            matching: find.byWidgetPredicate((widget) {
              if (widget is! Container) return false;
              final decoration = widget.decoration;
              return decoration is BoxDecoration && decoration.color != null;
            }),
          )
          .at(index),
    );
    final decoration = container.decoration! as BoxDecoration;
    return decoration.color!;
  }

  group('LiqProgressBar', () {
    testWidgets('canonical 4pt height', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(width: 200, child: LiqProgressBar(value: 0.5)),
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
              child: SizedBox(width: 200, child: LiqProgressBar(value: 0.42)),
            ),
          ),
        ),
      );
      expect(tester.getSemantics(find.byType(LiqProgressBar)).value, '42%');
    });

    testWidgets('dark theme resolves track and fill dynamically', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const LiqProgressBar(value: 0.42), data: LiqThemeData.dark),
      );

      expect(
        progressDecorationColorAt(tester, 0),
        const Color(0xB2EBEBF5).withValues(alpha: 0.24),
      );
      expect(progressDecorationColorAt(tester, 1), const Color(0xFF0091FF));
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
      expect(tester.getSize(find.byType(LiqSpinner)), const Size(30, 30));
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
      expect(tester.getSize(find.byType(LiqSpinner)), const Size(22, 22));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
