import 'package:flutter/gestures.dart';
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

const Duration _openDelay = Duration(milliseconds: 80);
const Duration _closeDelay = Duration(milliseconds: 60);
const Duration _animation = Duration(milliseconds: 220);

LiqHoverCard _hoverCard({
  required Widget child,
  LiqHoverCardPlacement placement = LiqHoverCardPlacement.top,
  double maxWidth = 320,
}) {
  return LiqHoverCard(
    placement: placement,
    openDelay: _openDelay,
    closeDelay: _closeDelay,
    maxWidth: maxWidth,
    content: const Text('Profile preview', textDirection: TextDirection.ltr),
    child: child,
  );
}

Future<TestGesture> _hoverInto(WidgetTester tester, Offset position) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  // Park the pointer outside the surface, then move into the target.
  await gesture.addPointer(location: const Offset(-100, -100));
  await tester.pump();
  await gesture.moveTo(position);
  return gesture;
}

void main() {
  group('LiqHoverCard', () {
    testWidgets('not visible on first pump', (tester) async {
      await tester.pumpWidget(
        _wrap(_hoverCard(child: const SizedBox(width: 120, height: 40))),
      );
      expect(find.text('Profile preview'), findsNothing);
    });

    testWidgets('hovering target reveals popover after openDelay', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_hoverCard(child: const SizedBox(width: 120, height: 40))),
      );

      final gesture = await _hoverInto(
        tester,
        tester.getCenter(find.byType(LiqHoverCard)),
      );
      // Before openDelay the popover is still hidden.
      await tester.pump(const Duration(milliseconds: 30));
      expect(find.text('Profile preview'), findsNothing);

      // After openDelay + animation the popover is visible.
      await tester.pump(_openDelay);
      await tester.pump(_animation);
      expect(find.text('Profile preview'), findsOneWidget);

      await gesture.removePointer();
      await tester.pumpAndSettle();
    });

    testWidgets('moving pointer away dismisses popover after closeDelay', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_hoverCard(child: const SizedBox(width: 120, height: 40))),
      );

      final gesture = await _hoverInto(
        tester,
        tester.getCenter(find.byType(LiqHoverCard)),
      );
      await tester.pump(_openDelay);
      await tester.pump(_animation);
      expect(find.text('Profile preview'), findsOneWidget);

      // Move pointer far away from the target and the popover.
      await gesture.moveTo(const Offset(5, 5));
      await tester.pump(_closeDelay);
      await tester.pump(_animation);
      expect(find.text('Profile preview'), findsNothing);

      await gesture.removePointer();
      await tester.pumpAndSettle();
    });

    testWidgets('moving from target into popover keeps it open', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_hoverCard(child: const SizedBox(width: 120, height: 40))),
      );

      final targetCenter = tester.getCenter(find.byType(LiqHoverCard));
      final gesture = await _hoverInto(tester, targetCenter);
      await tester.pump(_openDelay);
      await tester.pump(_animation);
      expect(find.text('Profile preview'), findsOneWidget);

      // Move from target onto the popover content.
      final popoverCenter = tester.getCenter(find.text('Profile preview'));
      await gesture.moveTo(popoverCenter);
      // Wait past closeDelay; popover should still be visible because
      // the popover-region's onEnter cancelled the close timer.
      await tester.pump(_closeDelay + const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Profile preview'), findsOneWidget);

      await gesture.removePointer();
      await tester.pumpAndSettle();
    });

    testWidgets('placement=bottom positions popover below the child', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _hoverCard(
            placement: LiqHoverCardPlacement.bottom,
            child: const SizedBox(width: 120, height: 40, key: Key('child')),
          ),
        ),
      );

      final gesture = await _hoverInto(
        tester,
        tester.getCenter(find.byKey(const Key('child'))),
      );
      await tester.pump(_openDelay);
      await tester.pump(_animation);

      final childBox = tester.renderObject<RenderBox>(
        find.byKey(const Key('child')),
      );
      final childGlobal = childBox.localToGlobal(Offset.zero);
      final childBottom = childGlobal.dy + childBox.size.height;

      final popoverBox = tester.renderObject<RenderBox>(
        find.text('Profile preview'),
      );
      final popoverTop = popoverBox.localToGlobal(Offset.zero).dy;
      expect(
        popoverTop,
        greaterThan(childBottom),
        reason: 'popover top should sit below the child bottom',
      );

      await gesture.removePointer();
      await tester.pumpAndSettle();
    });

    testWidgets('maxWidth caps the popover width', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LiqHoverCard(
            openDelay: _openDelay,
            closeDelay: _closeDelay,
            maxWidth: 160,
            content: SizedBox(
              width: 1000,
              child: Text('wide content', textDirection: TextDirection.ltr),
            ),
            child: SizedBox(width: 120, height: 40),
          ),
        ),
      );

      final gesture = await _hoverInto(
        tester,
        tester.getCenter(find.byType(LiqHoverCard)),
      );
      await tester.pump(_openDelay);
      await tester.pump(_animation);

      final popoverBox = tester.renderObject<RenderBox>(
        find.text('wide content'),
      );
      // Walk up the render tree to find the constrained surface — the
      // text layout box is constrained by the surface's maxWidth so its
      // own width must be <= maxWidth - padding.
      expect(popoverBox.size.width, lessThanOrEqualTo(160));

      await gesture.removePointer();
      await tester.pumpAndSettle();
    });
  });
}
