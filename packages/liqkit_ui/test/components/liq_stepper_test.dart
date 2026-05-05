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

    testWidgets('canonical 92×32 visual control', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqStepper(value: 5, onChanged: (int _) {})),
          ),
        ),
      );
      final control =
          find
              .descendant(
                of: find.byType(LiqStepper),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is SizedBox &&
                      widget.width == 92 &&
                      widget.height == 32,
                ),
              )
              .first;
      final size = tester.getSize(control);
      expect(size.width, 92);
      expect(size.height, 32);
    });

    testWidgets('keeps a 44pt-tall tap target', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqStepper(value: 5, onChanged: (int _) {})),
          ),
        ),
      );

      expect(tester.getSize(find.byType(LiqStepper)), const Size(92, 44));
    });

    testWidgets('pressing a button animates the symbol scale', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqStepper(value: 5, onChanged: (int _) {})),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<AnimatedScale>(find.byType(AnimatedScale))
            .map((scale) => scale.scale),
        everyElement(1),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('+')),
      );
      await tester.pump();
      expect(
        tester
            .widgetList<AnimatedScale>(find.byType(AnimatedScale))
            .map((scale) => scale.scale),
        contains(0.92),
      );

      await gesture.up();
      await tester.pump();
      expect(
        tester
            .widgetList<AnimatedScale>(find.byType(AnimatedScale))
            .map((scale) => scale.scale),
        everyElement(1),
      );
    });

    testWidgets('disabled state remains visible in dark theme', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.dark,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqStepper(value: 5, onChanged: null)),
          ),
        ),
      );

      final background = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(LiqStepper),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final backgroundDecoration = background.decoration as BoxDecoration;
      expect(backgroundDecoration.color, const Color(0x33767680));

      final minus = tester.widget<Text>(find.text('−'));
      expect(minus.style?.color, const Color(0x99EBEBF5));

      final plus = tester.widget<Text>(find.text('+'));
      expect(plus.style?.color, const Color(0x99EBEBF5));
    });

    testWidgets('reduced motion disables press transition durations', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: LiqTheme(
            data: LiqThemeData.light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(child: LiqStepper(value: 5, onChanged: (int _) {})),
            ),
          ),
        ),
      );

      expect(
        tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .map((container) => container.duration),
        everyElement(Duration.zero),
      );
      expect(
        tester
            .widgetList<AnimatedScale>(find.byType(AnimatedScale))
            .map((scale) => scale.duration),
        everyElement(Duration.zero),
      );
    });
  });
}
