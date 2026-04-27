import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqToolbarGlassButton', () {
    testWidgets('44pt height + tap fires', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topCenter,
              child: LiqToolbarGlassButton(
                label: 'Save',
                onPressed: () => taps += 1,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(LiqToolbarGlassButton));
      expect(taps, 1);
      expect(tester.getSize(find.byType(LiqToolbarGlassButton)).height, 44);
    });
  });

  group('LiqToolbar', () {
    testWidgets('renders leading + trailing groups', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 360,
                child: LiqToolbar(
                  leading: <Widget>[
                    LiqToolbarGlassButton(label: 'A', onPressed: () {}),
                  ],
                  trailing: <Widget>[
                    LiqToolbarGlassButton(label: 'B', onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(tester.getSize(find.byType(LiqToolbar)).height, 44);
    });
  });

  group('LiqToolbarChip', () {
    testWidgets('renders label and is at least 30pt tall', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqToolbarChip(label: 'Filter')),
          ),
        ),
      );
      expect(find.text('Filter'), findsOneWidget);
      expect(
        tester.getSize(find.byType(LiqToolbarChip)).height,
        greaterThanOrEqualTo(30),
      );
    });
  });
}
