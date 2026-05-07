import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(400, 400)),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

List<Widget> _slides() {
  return const <Widget>[
    ColoredBox(color: Color(0xFFFF0000), child: Center(child: Text('Slide 1'))),
    ColoredBox(color: Color(0xFF00FF00), child: Center(child: Text('Slide 2'))),
    ColoredBox(color: Color(0xFF0000FF), child: Center(child: Text('Slide 3'))),
  ];
}

void main() {
  group('LiqCarousel', () {
    testWidgets('renders the first item visible', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(width: 360, child: LiqCarousel(items: _slides())),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Slide 1'), findsOneWidget);
    });

    testWidgets('drag-flick advances to the next item', (tester) async {
      final controller = PageController(viewportFraction: 0.92);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 360,
              child: LiqCarousel(controller: controller, items: _slides()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Slide 1'), findsOneWidget);

      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(controller.page!.round(), greaterThan(0));
      expect(find.text('Slide 2'), findsOneWidget);
    });

    testWidgets('admits mouse and trackpad drag on web and desktop', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(width: 360, child: LiqCarousel(items: _slides())),
          ),
        ),
      );
      await tester.pump();

      final config = tester.widget<ScrollConfiguration>(
        find.ancestor(
          of: find.byType(PageView),
          matching: find.byType(ScrollConfiguration),
        ),
      );

      expect(config.behavior.dragDevices, contains(PointerDeviceKind.mouse));
      expect(config.behavior.dragDevices, contains(PointerDeviceKind.trackpad));
      expect(config.behavior.dragDevices, contains(PointerDeviceKind.touch));
    });

    testWidgets('uses grabbing cursor while the pointer is held', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(width: 360, child: LiqCarousel(items: _slides())),
          ),
        ),
      );
      await tester.pump();

      MouseRegion carouselMouseRegion() => tester.widget<MouseRegion>(
        find
            .ancestor(
              of: find.byType(PageView),
              matching: find.byType(MouseRegion),
            )
            .first,
      );

      expect(carouselMouseRegion().cursor, SystemMouseCursors.grab);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(
        location: tester.getCenter(find.byType(PageView)),
      );
      await tester.pump();
      await gesture.down(tester.getCenter(find.byType(PageView)));
      await tester.pump();

      expect(carouselMouseRegion().cursor, SystemMouseCursors.grabbing);

      await gesture.up();
      await tester.pump();

      expect(carouselMouseRegion().cursor, SystemMouseCursors.grab);
    });

    testWidgets('showIndicator: false hides the LiqPageControl', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 360,
              child: LiqCarousel(showIndicator: false, items: _slides()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LiqPageControl), findsNothing);
    });

    testWidgets('showIndicator default true renders the LiqPageControl', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(width: 360, child: LiqCarousel(items: _slides())),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LiqPageControl), findsOneWidget);
    });

    testWidgets('tapping an indicator dot animates to that page', (
      tester,
    ) async {
      final controller = PageController(viewportFraction: 0.92);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 360,
              child: LiqCarousel(controller: controller, items: _slides()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Slide 1'), findsOneWidget);

      final indicatorRect = tester.getRect(find.byType(LiqPageControl));
      await tester.tapAt(indicatorRect.center + const Offset(16, 0));
      await tester.pumpAndSettle();

      expect(controller.page!.round(), 2);
      expect(find.text('Slide 3'), findsOneWidget);
    });

    testWidgets('autoplay advances the page on each tick', (tester) async {
      final controller = PageController(viewportFraction: 0.92);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 360,
              child: LiqCarousel(
                controller: controller,
                autoplay: true,
                autoplayInterval: const Duration(milliseconds: 100),
                items: _slides(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final initialPage = controller.page ?? 0.0;

      // Drive the autoplay timer past one tick, then pump enough frames
      // for the page-transition animation to complete. We can't use
      // pumpAndSettle because Timer.periodic never settles.
      await tester.pump(const Duration(milliseconds: 110));
      // Pump several frames at small intervals to advance the animation.
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 32));
      }

      expect(
        controller.page,
        greaterThan(initialPage),
        reason: 'autoplay should have advanced the page',
      );

      // Replace the carousel with one that has autoplay disabled so the
      // periodic timer is cancelled before the test ends.
      await tester.pumpWidget(
        _wrap(
          Center(
            child: SizedBox(
              width: 360,
              child: LiqCarousel(controller: controller, items: _slides()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    test('AssertionError when items list is empty', () {
      expect(() => LiqCarousel(items: const <Widget>[]), throwsAssertionError);
    });

    test('AssertionError when viewportFraction == 0', () {
      expect(
        () =>
            LiqCarousel(viewportFraction: 0, items: const <Widget>[SizedBox()]),
        throwsAssertionError,
      );
    });

    test('AssertionError when viewportFraction > 1', () {
      expect(
        () => LiqCarousel(
          viewportFraction: 1.5,
          items: const <Widget>[SizedBox()],
        ),
        throwsAssertionError,
      );
    });
  });
}
