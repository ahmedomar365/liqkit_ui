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

  // The visible 22x22 ring is the first `Container` descendant of
  // the [LiqRadio]; the SizedBox at the root is the 44x44 hit target.
  Finder visibleRing(Finder radio) {
    return find.descendant(of: radio, matching: find.byType(Container)).first;
  }

  // The inner filled dot is wrapped in [AnimatedScale]; in the selected
  // state it animates to scale 1, in the unselected state to scale 0.
  bool isSelected(WidgetTester tester, Finder radio) {
    final scale = tester.widget<AnimatedScale>(
      find.descendant(of: radio, matching: find.byType(AnimatedScale)),
    );
    return scale.scale == 1.0;
  }

  group('LiqRadio', () {
    testWidgets('value == groupValue renders selected (inner dot present)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(LiqRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(isSelected(tester, find.byType(LiqRadio<String>)), isTrue);
    });

    testWidgets('value != groupValue renders unselected', (tester) async {
      await tester.pumpWidget(
        wrap(LiqRadio<String>(value: 'a', groupValue: 'b', onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(isSelected(tester, find.byType(LiqRadio<String>)), isFalse);
    });

    testWidgets('tap on unselected reports its value', (tester) async {
      String? received;
      await tester.pumpWidget(
        wrap(
          LiqRadio<String>(
            value: 'b',
            groupValue: 'a',
            onChanged: (v) => received = v,
          ),
        ),
      );

      await tester.tap(find.byType(LiqRadio<String>));
      await tester.pumpAndSettle();
      expect(received, 'b');
    });

    testWidgets('disabled (onChanged == null): tap does nothing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const LiqRadio<String>(value: 'a', groupValue: 'a', onChanged: null),
        ),
      );

      await tester.tap(find.byType(LiqRadio<String>));
      await tester.pumpAndSettle();
      // No exception; nothing else to assert.
    });

    testWidgets('visible ring measures exactly 22x22', (tester) async {
      await tester.pumpWidget(
        wrap(LiqRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {})),
      );

      final size = tester.getSize(visibleRing(find.byType(LiqRadio<String>)));
      expect(size.width, LiqRadio.ringSize);
      expect(size.height, LiqRadio.ringSize);
    });
  });

  group('LiqRadioGroup', () {
    const options = <({String value, String label})>[
      (value: 'a', label: 'Alpha'),
      (value: 'b', label: 'Bravo'),
      (value: 'c', label: 'Charlie'),
    ];

    testWidgets(
      'three options with value "b" render the second row as selected',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            SizedBox(
              width: 320,
              child: LiqRadioGroup<String>(
                options: options,
                value: 'b',
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final radios = find.byType(LiqRadio<String>);
        expect(radios, findsNWidgets(3));

        expect(isSelected(tester, radios.at(0)), isFalse);
        expect(isSelected(tester, radios.at(1)), isTrue);
        expect(isSelected(tester, radios.at(2)), isFalse);
      },
    );

    testWidgets('tapping a different row fires onChanged with that value', (
      tester,
    ) async {
      String? received;
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: LiqRadioGroup<String>(
              options: options,
              value: 'a',
              onChanged: (v) => received = v,
            ),
          ),
        ),
      );

      // Tap the third row by tapping its label text. The whole row is
      // wrapped in a GestureDetector with HitTestBehavior.opaque.
      await tester.tap(find.text('Charlie'));
      await tester.pumpAndSettle();
      expect(received, 'c');
    });
  });
}
