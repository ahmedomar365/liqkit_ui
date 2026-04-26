import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/theme.dart';

void main() {
  group('LiqTheme', () {
    testWidgets('LiqTheme.of returns the data installed by an ancestor',
        (tester) async {
      late LiqThemeData captured;
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: Builder(
            builder: (context) {
              captured = LiqTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(captured, LiqThemeData.dark);
    });

    testWidgets('LiqTheme.maybeOf returns null when no ancestor installed',
        (tester) async {
      LiqThemeData? captured = LiqThemeData.light;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            captured = LiqTheme.maybeOf(context);
            return const SizedBox();
          },
        ),
      );
      expect(captured, isNull);
    });

    testWidgets('LiqTheme.of throws an assertion when no ancestor installed',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => LiqTheme.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('updateShouldNotify reports when data changes', (tester) async {
      var builds = 0;
      Widget build(LiqThemeData data) => LiqTheme(
            data: data,
            child: Builder(
              builder: (context) {
                LiqTheme.of(context);
                builds += 1;
                return const SizedBox();
              },
            ),
          );

      await tester.pumpWidget(build(LiqThemeData.light));
      await tester.pumpWidget(build(LiqThemeData.dark));
      expect(builds, 2);
    });
  });
}
