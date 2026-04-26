import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqListRow', () {
    testWidgets('renders title only at min 52pt', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 320,
                child: LiqListRow(title: 'Hello'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
      expect(
        tester.getSize(find.byType(LiqListRow)).height,
        greaterThanOrEqualTo(52),
      );
    });

    testWidgets('renders subtitle and grows to 68pt min', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 320,
                child: LiqListRow(
                  title: 'Wi-Fi',
                  subtitle: 'Connected to home',
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(find.text('Connected to home'), findsOneWidget);
      expect(
        tester.getSize(find.byType(LiqListRow)).height,
        greaterThanOrEqualTo(68),
      );
    });

    testWidgets('tap fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 320,
                child: LiqListRow(
                  title: 'Tap',
                  onTap: () => taps += 1,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(LiqListRow));
      expect(taps, 1);
    });
  });

  group('LiqListGroup', () {
    testWidgets('renders n rows with separators', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 320,
                child: LiqListGroup(
                  rows: <LiqListRow>[
                    LiqListRow(title: 'One'),
                    LiqListRow(title: 'Two'),
                    LiqListRow(title: 'Three'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(LiqListRow), findsNWidgets(3));
    });
  });
}
