import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: SizedBox(width: 320, height: 120, child: child)),
  );

  group('LiqLineChart', () {
    testWidgets('renders with two values without throwing', (tester) async {
      await tester.pumpWidget(wrap(LiqLineChart(values: const <double>[0, 1])));
      expect(find.byType(LiqLineChart), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with multiple values without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqLineChart(
            values: const <double>[3, 7, 5, 12, 8, 14, 11, 18, 15, 20],
          ),
        ),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    test('asserts when fewer than 2 values are provided', () {
      expect(
        () => LiqLineChart(values: const <double>[1]),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => LiqLineChart(values: const <double>[]),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('renders with showDots: true', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqLineChart(values: const <double>[1, 4, 2, 6, 3], showDots: true),
        ),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    testWidgets('renders with showDots: false', (tester) async {
      await tester.pumpWidget(
        wrap(LiqLineChart(values: const <double>[1, 4, 2, 6, 3])),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    testWidgets('renders with smooth: true', (tester) async {
      await tester.pumpWidget(
        wrap(LiqLineChart(values: const <double>[1, 4, 2, 6, 3])),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    testWidgets('renders with smooth: false', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqLineChart(values: const <double>[1, 4, 2, 6, 3], smooth: false),
        ),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    test('default color is iOS blue (#FF007AFF)', () {
      final chart = LiqLineChart(values: const <double>[1, 2]);
      expect(chart.color, const Color(0xFF007AFF));
      expect(LiqLineChart.lineColor, const Color(0xFF007AFF));
    });

    testWidgets('rebuilds when values change without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(LiqLineChart(values: const <double>[1, 2, 3])),
      );
      await tester.pumpWidget(
        wrap(LiqLineChart(values: const <double>[5, 1, 9, 4])),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    testWidgets('renders a degenerate (flat) series without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(LiqLineChart(values: const <double>[5, 5, 5, 5])),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });

    testWidgets('renders sparkline configuration without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: LiqLineChart(
                values: const <double>[3, 5, 4, 7, 6, 9, 8, 12],
                fillArea: false,
                strokeWidth: 1.5,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(LiqLineChart), findsOneWidget);
    });
  });
}
