import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: SizedBox(width: 320, height: 160, child: child)),
  );

  Widget wrapDark(Widget child) => LiqTheme(
    data: LiqThemeData.dark,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 320, height: 160, child: child)),
    ),
  );

  group('LiqBarChart', () {
    testWidgets('renders with one bar without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(LiqBarChart(bars: const <LiqBar>[LiqBar(value: 5)])),
      );
      expect(find.byType(LiqBarChart), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with multiple bars without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            bars: const <LiqBar>[
              LiqBar(value: 12),
              LiqBar(value: 18),
              LiqBar(value: 9),
              LiqBar(value: 24),
              LiqBar(value: 16),
            ],
          ),
        ),
      );
      expect(find.byType(LiqBarChart), findsOneWidget);
    });

    test('asserts when bars list is empty', () {
      expect(
        () => LiqBarChart(bars: const <LiqBar>[]),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('renders bar labels when showLabels is true', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            bars: const <LiqBar>[
              LiqBar(value: 12, label: 'Mon'),
              LiqBar(value: 18, label: 'Tue'),
              LiqBar(value: 9, label: 'Wed'),
            ],
          ),
        ),
      );
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
    });

    testWidgets('renders no label widgets when showLabels is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            showLabels: false,
            bars: const <LiqBar>[
              LiqBar(value: 12, label: 'Mon'),
              LiqBar(value: 18, label: 'Tue'),
              LiqBar(value: 9, label: 'Wed'),
            ],
          ),
        ),
      );
      expect(find.text('Mon'), findsNothing);
      expect(find.text('Tue'), findsNothing);
      expect(find.text('Wed'), findsNothing);
    });

    testWidgets('per-bar color override is accepted without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            bars: const <LiqBar>[
              LiqBar(value: 12, label: 'Mon', color: Color(0xFF34C759)),
              LiqBar(value: 18, label: 'Tue', color: Color(0xFF007AFF)),
              LiqBar(value: 9, label: 'Wed'),
            ],
          ),
        ),
      );
      expect(find.byType(LiqBarChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('custom min and max are accepted without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            min: -5,
            max: 30,
            bars: const <LiqBar>[
              LiqBar(value: 12),
              LiqBar(value: 18),
              LiqBar(value: 24),
            ],
          ),
        ),
      );
      expect(find.byType(LiqBarChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test('default color is iOS blue (#FF007AFF)', () {
      final chart = LiqBarChart(bars: const <LiqBar>[LiqBar(value: 1)]);
      expect(chart.color, const Color(0xFF007AFF));
      expect(LiqBarChart.barColor, const Color(0xFF007AFF));
    });

    testWidgets('rebuilds when bars change without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(bars: const <LiqBar>[LiqBar(value: 1), LiqBar(value: 2)]),
        ),
      );
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            bars: const <LiqBar>[
              LiqBar(value: 5),
              LiqBar(value: 1),
              LiqBar(value: 9),
            ],
          ),
        ),
      );
      expect(find.byType(LiqBarChart), findsOneWidget);
    });

    testWidgets('renders a degenerate (all-zero) series without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqBarChart(
            max: 0,
            bars: const <LiqBar>[
              LiqBar(value: 0),
              LiqBar(value: 0),
              LiqBar(value: 0),
            ],
          ),
        ),
      );
      expect(find.byType(LiqBarChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('dark theme resolves default fill and labels dynamically', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapDark(
          LiqBarChart(
            bars: const <LiqBar>[
              LiqBar(value: 12, label: 'Mon'),
              LiqBar(value: 18, label: 'Tue'),
            ],
          ),
        ),
      );

      final label = tester.widget<Text>(find.text('Mon'));
      expect(label.style?.color, const Color(0xB2EBEBF5));

      late Color effectiveColor;
      await tester.pumpWidget(
        wrapDark(
          Builder(
            builder: (context) {
              effectiveColor = LiqBarChart.effectiveColorFor(
                context,
                LiqBarChart.barColor,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(effectiveColor, const Color(0xFF0091FF));
    });
  });
}
