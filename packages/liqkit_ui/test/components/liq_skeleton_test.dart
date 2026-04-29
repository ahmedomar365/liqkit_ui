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

  group('LiqSkeleton', () {
    testWidgets('rect skeleton sizes exactly to width and height', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const LiqSkeleton(width: 120, height: 20)));

      final size = tester.getSize(find.byType(LiqSkeleton));
      expect(size.width, 120);
      expect(size.height, 20);
    });

    testWidgets('circle skeleton sizes to width on both axes', (tester) async {
      await tester.pumpWidget(
        wrap(
          const LiqSkeleton(
            width: 40,
            height: 9999,
            shape: LiqSkeletonShape.circle,
          ),
        ),
      );

      final size = tester.getSize(find.byType(LiqSkeleton));
      expect(size.width, 40);
      expect(size.height, 40);
    });

    testWidgets('text skeleton fills parent width by default', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 200,
            height: 60,
            child: LiqSkeleton(shape: LiqSkeletonShape.text),
          ),
        ),
      );

      final size = tester.getSize(find.byType(LiqSkeleton));
      expect(size.width, 200);
    });

    testWidgets('animation runs without throwing', (tester) async {
      await tester.pumpWidget(wrap(const LiqSkeleton(width: 100, height: 20)));

      await tester.pump(const Duration(milliseconds: 100));
      // Pump a couple of additional frames to advance the controller
      // without using pumpAndSettle, which would time out on the
      // repeating animation.
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LiqSkeleton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('LiqSkeletonText', () {
    testWidgets('renders one LiqSkeleton per line', (tester) async {
      await tester.pumpWidget(
        wrap(const SizedBox(width: 200, child: LiqSkeletonText(lines: 4))),
      );

      expect(find.byType(LiqSkeleton), findsNWidgets(4));
    });
  });
}
