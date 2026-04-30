import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );
}

const Key _firstKey = Key('first');
const Key _secondKey = Key('second');

LiqResizable _resizable({
  LiqResizableDirection direction = LiqResizableDirection.horizontal,
  double initialRatio = 0.5,
  double minRatio = 0.15,
  double maxRatio = 0.85,
  double dividerThickness = 8,
  ValueChanged<double>? onRatioChanged,
}) {
  return LiqResizable(
    direction: direction,
    initialRatio: initialRatio,
    minRatio: minRatio,
    maxRatio: maxRatio,
    dividerThickness: dividerThickness,
    onRatioChanged: onRatioChanged,
    first: const SizedBox.expand(key: _firstKey),
    second: const SizedBox.expand(key: _secondKey),
  );
}

void main() {
  group('LiqResizable', () {
    testWidgets('default initialRatio=0.5 lays out both panes equally', (
      tester,
    ) async {
      const total = 400.0;
      const thickness = 12.0;
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: total,
            height: 200,
            child: LiqResizable(
              dividerThickness: thickness,
              first: SizedBox.expand(key: _firstKey),
              second: SizedBox.expand(key: _secondKey),
            ),
          ),
        ),
      );

      final firstWidth = tester.getSize(find.byKey(_firstKey)).width;
      final secondWidth = tester.getSize(find.byKey(_secondKey)).width;
      // initialRatio=0.5 → first = 200, second = 400 - 200 - 12 = 188.
      expect(firstWidth, closeTo(total * 0.5, 0.5));
      expect(secondWidth, closeTo(total - firstWidth - thickness, 0.5));
    });

    testWidgets('dragging the divider right increases first pane width', (
      tester,
    ) async {
      const total = 400.0;
      await tester.pumpWidget(
        _wrap(SizedBox(width: total, height: 200, child: _resizable())),
      );

      final initialWidth = tester.getSize(find.byKey(_firstKey)).width;
      await tester.drag(
        find.byKey(LiqResizable.dividerKey),
        const Offset(50, 0),
      );
      await tester.pumpAndSettle();

      final newWidth = tester.getSize(find.byKey(_firstKey)).width;
      expect(newWidth, greaterThan(initialWidth));
      expect(newWidth, closeTo(initialWidth + 50, 1));
    });

    testWidgets('onRatioChanged fires on each drag update', (tester) async {
      final ratios = <double>[];
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 400,
            height: 200,
            child: _resizable(onRatioChanged: ratios.add),
          ),
        ),
      );

      await tester.drag(
        find.byKey(LiqResizable.dividerKey),
        const Offset(50, 0),
      );
      await tester.pumpAndSettle();

      expect(ratios, isNotEmpty);
      expect(ratios.last, greaterThan(0.5));
    });

    testWidgets('minRatio clamps when dragging far left', (tester) async {
      const total = 400.0;
      const minRatio = 0.2;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: total,
            height: 200,
            child: _resizable(minRatio: minRatio, maxRatio: 0.8),
          ),
        ),
      );

      // Drag far past the lower bound.
      await tester.drag(
        find.byKey(LiqResizable.dividerKey),
        const Offset(-2000, 0),
      );
      await tester.pumpAndSettle();

      final firstWidth = tester.getSize(find.byKey(_firstKey)).width;
      expect(firstWidth, closeTo(total * minRatio, 1));
    });

    testWidgets('maxRatio clamps when dragging far right', (tester) async {
      const total = 400.0;
      const maxRatio = 0.8;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: total,
            height: 200,
            child: _resizable(minRatio: 0.2, maxRatio: maxRatio),
          ),
        ),
      );

      await tester.drag(
        find.byKey(LiqResizable.dividerKey),
        const Offset(2000, 0),
      );
      await tester.pumpAndSettle();

      final firstWidth = tester.getSize(find.byKey(_firstKey)).width;
      expect(firstWidth, closeTo(total * maxRatio, 1));
    });

    testWidgets('vertical direction lays panes top/bottom', (tester) async {
      const total = 400.0;
      const thickness = 12.0;
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 200,
            height: total,
            child: _resizable(
              direction: LiqResizableDirection.vertical,
              dividerThickness: thickness,
            ),
          ),
        ),
      );

      final firstSize = tester.getSize(find.byKey(_firstKey));
      final secondSize = tester.getSize(find.byKey(_secondKey));
      expect(firstSize.height, closeTo(total * 0.5, 0.5));
      expect(
        secondSize.height,
        closeTo(total - firstSize.height - thickness, 0.5),
      );

      // Dragging downward should grow the top pane.
      final initialHeight = firstSize.height;
      await tester.drag(
        find.byKey(LiqResizable.dividerKey),
        const Offset(0, 50),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(_firstKey)).height,
        greaterThan(initialHeight),
      );
    });

    test('AssertionError when initialRatio is 0 or 1', () {
      expect(
        () => LiqResizable(
          first: const SizedBox.shrink(),
          second: const SizedBox.shrink(),
          initialRatio: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => LiqResizable(
          first: const SizedBox.shrink(),
          second: const SizedBox.shrink(),
          initialRatio: 1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
