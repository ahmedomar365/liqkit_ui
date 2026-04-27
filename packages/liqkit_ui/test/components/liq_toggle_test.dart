import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqToggle', () {
    testWidgets('reports flipped value on tap', (tester) async {
      var v = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => LiqTheme(
                data: LiqThemeData.light,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: LiqToggle(
                      value: v,
                      onChanged: (next) => setState(() => v = next),
                    ),
                  ),
                ),
              ),
        ),
      );
      expect(v, isFalse);
      await tester.tap(find.byType(LiqToggle));
      await tester.pumpAndSettle();
      expect(v, isTrue);
      await tester.tap(find.byType(LiqToggle));
      await tester.pumpAndSettle();
      expect(v, isFalse);
    });

    testWidgets('measures the canonical 64x28 track', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqToggle(value: true, onChanged: (_) {})),
          ),
        ),
      );
      final size = tester.getSize(find.byType(LiqToggle));
      expect(size.width, LiqToggle.trackWidth);
      expect(size.height, LiqToggle.trackHeight);
    });

    testWidgets('disabled when onChanged is null', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqToggle(value: false, onChanged: null)),
          ),
        ),
      );
      // Tapping a disabled toggle does nothing — no exception, no
      // state change to assert against because there's no callback.
      await tester.tap(find.byType(LiqToggle));
      await tester.pumpAndSettle();
    });
  });
}
