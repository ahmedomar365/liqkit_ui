import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('LiqDatePicker shows the month/year title', (tester) async {
    await tester.pumpWidget(_wrap(const LiqDatePicker(year: 2026, month: 4)));
    expect(find.text('April 2026'), findsOneWidget);
  });

  testWidgets('LiqDatePicker renders 7 weekday headers', (tester) async {
    await tester.pumpWidget(_wrap(const LiqDatePicker(year: 2026, month: 4)));
    expect(find.text('SUN'), findsOneWidget);
    expect(find.text('SAT'), findsOneWidget);
  });

  testWidgets('LiqDatePicker invokes onDayTap with the tapped day', (
    tester,
  ) async {
    var tapped = -1;
    await tester.pumpWidget(
      _wrap(LiqDatePicker(year: 2026, month: 4, onDayTap: (d) => tapped = d)),
    );
    await tester.tap(find.text('15'));
    expect(tapped, 15);
  });

  testWidgets('LiqDatePicker arrows keep 44pt tap targets', (tester) async {
    await tester.pumpWidget(_wrap(const LiqDatePicker(year: 2026, month: 4)));

    final arrows = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_ArrowPainter',
    );

    expect(arrows, findsNWidgets(2));
    for (final element in arrows.evaluate()) {
      final gesture = find.ancestor(
        of: find.byElementPredicate((candidate) => candidate == element),
        matching: find.byType(GestureDetector),
      );
      expect(tester.getSize(gesture.first), const Size(44, 44));
    }
  });

  testWidgets('LiqDatePicker arrows navigate months without external wiring', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const LiqDatePicker(year: 2026, month: 4)));

    final arrows = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_ArrowPainter',
    );

    expect(find.text('April 2026'), findsOneWidget);
    await tester.tap(arrows.last);
    await tester.pumpAndSettle();
    expect(find.text('May 2026'), findsOneWidget);

    await tester.tap(arrows.first);
    await tester.pumpAndSettle();
    expect(find.text('April 2026'), findsOneWidget);
  });

  testWidgets('LiqDatePicker arrows still invoke external callbacks', (
    tester,
  ) async {
    var previousCount = 0;
    var nextCount = 0;
    await tester.pumpWidget(
      _wrap(
        LiqDatePicker(
          year: 2026,
          month: 4,
          onPrev: () => previousCount += 1,
          onNext: () => nextCount += 1,
        ),
      ),
    );

    final arrows = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_ArrowPainter',
    );

    await tester.tap(arrows.last);
    await tester.pumpAndSettle();
    await tester.tap(arrows.first);
    await tester.pumpAndSettle();

    expect(nextCount, 1);
    expect(previousCount, 1);
  });

  testWidgets('LiqDatePicker interactive cells expose click cursors', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(LiqDatePicker(year: 2026, month: 4, onDayTap: (_) {})),
    );

    final mouseRegions = tester.widgetList<MouseRegion>(
      find.byType(MouseRegion),
    );
    expect(
      mouseRegions.any((region) => region.cursor == SystemMouseCursors.click),
      isTrue,
    );
  });
}
