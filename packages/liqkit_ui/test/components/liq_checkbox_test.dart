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

  Finder visibleBox() {
    // The visible 22x22 box is the AnimatedContainer descendant of
    // LiqCheckbox; the SizedBox at the root is the 44x44 hit target.
    return find
        .descendant(
          of: find.byType(LiqCheckbox),
          matching: find.byType(AnimatedContainer),
        )
        .first;
  }

  group('LiqCheckbox', () {
    testWidgets('tap on unchecked reports checked', (tester) async {
      LiqCheckboxState? received;
      await tester.pumpWidget(
        wrap(
          LiqCheckbox(
            value: LiqCheckboxState.unchecked,
            onChanged: (next) => received = next,
          ),
        ),
      );

      await tester.tap(find.byType(LiqCheckbox));
      await tester.pumpAndSettle();
      expect(received, LiqCheckboxState.checked);
    });

    testWidgets('tap on checked reports unchecked', (tester) async {
      LiqCheckboxState? received;
      await tester.pumpWidget(
        wrap(
          LiqCheckbox(
            value: LiqCheckboxState.checked,
            onChanged: (next) => received = next,
          ),
        ),
      );

      await tester.tap(find.byType(LiqCheckbox));
      await tester.pumpAndSettle();
      expect(received, LiqCheckboxState.unchecked);
    });

    testWidgets('tap on indeterminate reports checked', (tester) async {
      LiqCheckboxState? received;
      await tester.pumpWidget(
        wrap(
          LiqCheckbox(
            value: LiqCheckboxState.indeterminate,
            onChanged: (next) => received = next,
          ),
        ),
      );

      await tester.tap(find.byType(LiqCheckbox));
      await tester.pumpAndSettle();
      expect(received, LiqCheckboxState.checked);
    });

    testWidgets('disabled (onChanged == null): tap does nothing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const LiqCheckbox(value: LiqCheckboxState.unchecked, onChanged: null),
        ),
      );

      await tester.tap(find.byType(LiqCheckbox));
      await tester.pumpAndSettle();
      // No exception; nothing to assert other than survival.
    });

    testWidgets('visible box measures exactly 22x22', (tester) async {
      await tester.pumpWidget(
        wrap(LiqCheckbox(value: LiqCheckboxState.unchecked, onChanged: (_) {})),
      );

      final size = tester.getSize(visibleBox());
      expect(size.width, LiqCheckbox.boxSize);
      expect(size.height, LiqCheckbox.boxSize);
    });

    testWidgets('uses dark theme colors for unchecked box', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqCheckbox(
                value: LiqCheckboxState.unchecked,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final box = tester.widget<AnimatedContainer>(visibleBox());
      final decoration = box.decoration! as BoxDecoration;
      expect(decoration.color, const Color(0xFF000000));
    });
  });
}
