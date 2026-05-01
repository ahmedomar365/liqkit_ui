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

void main() {
  group('LiqScrollArea', () {
    testWidgets('renders the child', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 200,
            height: 200,
            child: LiqScrollArea(child: Text('hello')),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('default axis is vertical', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 200,
            height: 200,
            child: LiqScrollArea(child: SizedBox(width: 100, height: 1000)),
          ),
        ),
      );

      final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scroll.scrollDirection, Axis.vertical);
    });

    testWidgets(
      'axis: Axis.horizontal sets the SingleChildScrollView accordingly',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SizedBox(
              width: 200,
              height: 200,
              child: LiqScrollArea(
                axis: Axis.horizontal,
                child: SizedBox(width: 1000, height: 100),
              ),
            ),
          ),
        );

        final scroll = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scroll.scrollDirection, Axis.horizontal);
      },
    );

    testWidgets('external controller is wired', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 200,
            height: 200,
            child: LiqScrollArea(
              controller: controller,
              child: const SizedBox(width: 100, height: 2000),
            ),
          ),
        ),
      );

      controller.jumpTo(50);
      await tester.pump();

      expect(controller.offset, 50);
    });

    testWidgets('padding is applied to inner Padding widget', (tester) async {
      const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 200,
            height: 200,
            child: LiqScrollArea(
              padding: padding,
              child: SizedBox(width: 100, height: 1000),
            ),
          ),
        ),
      );

      final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scroll.padding, padding);
    });

    testWidgets('scrolling produces a RawScrollbar', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 200,
            height: 200,
            child: LiqScrollArea(child: SizedBox(width: 100, height: 1000)),
          ),
        ),
      );

      expect(find.byType(RawScrollbar), findsOneWidget);
    });
  });
}
