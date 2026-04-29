import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => Center(child: child)),
        ],
      ),
    ),
  );
}

/// Issue a long-press at the centre of [finder] and hold the gesture
/// open. Returns the gesture so callers can release it via `up()`.
Future<TestGesture> _startLongPress(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 600));
  // Past the show animation (160ms) so the tooltip is fully visible.
  await tester.pump(const Duration(milliseconds: 200));
  return gesture;
}

void main() {
  group('LiqTooltip', () {
    testWidgets('not visible on first pump', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LiqTooltip(
            message: 'Hi',
            child: SizedBox(width: 100, height: 40),
          ),
        ),
      );
      expect(find.text('Hi'), findsNothing);
    });

    testWidgets('long-press shows tooltip text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LiqTooltip(
            message: 'Hi',
            child: SizedBox(width: 100, height: 40),
          ),
        ),
      );

      final gesture = await _startLongPress(tester, find.byType(LiqTooltip));
      expect(find.text('Hi'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('long-press release dismisses tooltip', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LiqTooltip(
            message: 'Bye',
            child: SizedBox(width: 100, height: 40),
          ),
        ),
      );

      final gesture = await _startLongPress(tester, find.byType(LiqTooltip));
      expect(find.text('Bye'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Bye'), findsNothing);
    });

    testWidgets('showArrow=false renders no arrow', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LiqTooltip(
            message: 'NoArrow',
            showArrow: false,
            child: SizedBox(width: 100, height: 40),
          ),
        ),
      );
      final gesture = await _startLongPress(tester, find.byType(LiqTooltip));
      expect(find.text('NoArrow'), findsOneWidget);

      // The arrow uses CustomPaint inside the tooltip body. With
      // showArrow=false there should be no CustomPaint contributed
      // by the tooltip body.
      expect(find.byType(CustomPaint).evaluate().length, lessThan(2));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('placement=bottom positions tooltip below the child', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const LiqTooltip(
            message: 'Below',
            placement: LiqTooltipPlacement.bottom,
            child: SizedBox(width: 100, height: 40, key: Key('child')),
          ),
        ),
      );

      final gesture = await _startLongPress(tester, find.byType(LiqTooltip));

      final childBox = tester.renderObject<RenderBox>(
        find.byKey(const Key('child')),
      );
      final childGlobal = childBox.localToGlobal(Offset.zero);
      final childBottom = childGlobal.dy + childBox.size.height;

      final tooltipBox = tester.renderObject<RenderBox>(find.text('Below'));
      final tooltipTop = tooltipBox.localToGlobal(Offset.zero).dy;
      expect(
        tooltipTop,
        greaterThan(childBottom),
        reason: 'tooltip top should sit below the child bottom',
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
