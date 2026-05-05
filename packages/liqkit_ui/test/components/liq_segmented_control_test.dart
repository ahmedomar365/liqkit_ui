import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child, {LiqThemeData data = LiqThemeData.light}) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: LiqTheme(
        data: data,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: SizedBox(width: 300, child: child)),
        ),
      ),
    );
  }

  group('LiqSegmentedControl', () {
    testWidgets('tap selects a segment', (tester) async {
      var v = 'a';
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => LiqTheme(
                data: LiqThemeData.light,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: LiqSegmentedControl<String>(
                        segments: const <({String value, String label})>[
                          (value: 'a', label: 'One'),
                          (value: 'b', label: 'Two'),
                          (value: 'c', label: 'Three'),
                        ],
                        value: v,
                        onChanged: (String next) => setState(() => v = next),
                      ),
                    ),
                  ),
                ),
              ),
        ),
      );
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(v, 'b');
    });

    testWidgets('press-drag selects segments continuously', (tester) async {
      var v = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => wrap(
                LiqSegmentedControl<int>(
                  segments: const <({int value, String label})>[
                    (value: 0, label: 'Day'),
                    (value: 1, label: 'Week'),
                    (value: 2, label: 'Month'),
                    (value: 3, label: 'Year'),
                  ],
                  value: v,
                  onChanged: (int next) => setState(() => v = next),
                ),
              ),
        ),
      );
      await tester.pumpAndSettle();

      final box = tester.getRect(find.byType(LiqSegmentedControl<int>));
      final gesture = await tester.startGesture(
        box.centerLeft + const Offset(8, 0),
      );
      await tester.pump();
      expect(v, 0);

      await gesture.moveTo(box.centerRight - const Offset(8, 0));
      await tester.pump();
      expect(v, 3);

      await gesture.moveTo(box.center);
      await tester.pump();
      expect(v, anyOf(1, 2));

      await gesture.up();
    });

    testWidgets('disabled rejects tap', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 200,
                child: LiqSegmentedControl<int>(
                  segments: <({int value, String label})>[
                    (value: 0, label: 'A'),
                    (value: 1, label: 'B'),
                  ],
                  value: 0,
                  onChanged: null,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      // No callback => no state change to assert. Just confirm no error.
    });

    testWidgets('canonical 32pt height', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 200,
                child: LiqSegmentedControl<int>(
                  segments: const <({int value, String label})>[
                    (value: 0, label: 'A'),
                    (value: 1, label: 'B'),
                  ],
                  value: 0,
                  onChanged: (int _) {},
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(LiqSegmentedControl<int>)).height, 32);
    });

    testWidgets('selection capsule animates to the selected segment', (
      tester,
    ) async {
      var v = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => wrap(
                LiqSegmentedControl<int>(
                  segments: const <({int value, String label})>[
                    (value: 0, label: 'A'),
                    (value: 1, label: 'B'),
                    (value: 2, label: 'C'),
                  ],
                  value: v,
                  onChanged: (int next) => setState(() => v = next),
                ),
              ),
        ),
      );
      await tester.pumpAndSettle();
      final initial = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(initial.left, 0);

      await tester.tap(find.text('C'));
      await tester.pump();
      final target = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(target.duration, LiqMotion.normal);
      expect(target.left, greaterThan(initial.left!));
    });

    testWidgets('selection capsule honors reduced motion settings', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: LiqTheme(
            data: LiqThemeData.light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: LiqSegmentedControl<int>(
                    segments: const <({int value, String label})>[
                      (value: 0, label: 'Day'),
                      (value: 1, label: 'Week'),
                    ],
                    value: 0,
                    onChanged: (int _) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final capsule = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(capsule.duration, Duration.zero);
    });

    testWidgets('dark theme uses dark selected and inactive label colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqSegmentedControl<int>(
            segments: const <({int value, String label})>[
              (value: 0, label: 'A'),
              (value: 1, label: 'B'),
            ],
            value: 0,
            onChanged: (int _) {},
          ),
          data: LiqThemeData.dark,
        ),
      );

      final selected = tester.widget<Text>(find.text('A'));
      expect(selected.style?.color, const Color(0xFFFFFFFF));

      final inactive = tester.widget<Text>(find.text('B'));
      expect(inactive.style?.color, const Color(0xB2EBEBF5));

      final selectedDecoration = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(LiqSegmentedControl<int>),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere(
            (decoration) => decoration.color == const Color(0xFF636366),
          );
      expect(selectedDecoration.color, const Color(0xFF636366));
    });
  });
}
