import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqSegmentedControl', () {
    testWidgets('tap selects a segment', (tester) async {
      var v = 'a';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => LiqTheme(
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
      expect(
        tester.getSize(find.byType(LiqSegmentedControl<int>)).height,
        32,
      );
    });
  });
}
