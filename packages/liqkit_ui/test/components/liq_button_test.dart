import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqButton', () {
    testWidgets('renders label and reports tap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqButton(label: 'Confirm', onPressed: () => taps += 1),
            ),
          ),
        ),
      );
      expect(find.text('Confirm'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      expect(taps, 1);
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: LiqButton(label: 'Off', onPressed: null)),
          ),
        ),
      );
      const taps = 0;
      await tester.tap(find.byType(LiqButton));
      expect(taps, 0, reason: 'disabled button must not invoke onPressed');
    });

    testWidgets('applies the right height per size axis', (tester) async {
      for (final entry
          in <LiqButtonSize, double>{
            LiqButtonSize.small: 28,
            LiqButtonSize.medium: 34,
            LiqButtonSize.large: 50,
          }.entries) {
        await tester.pumpWidget(
          LiqTheme(
            data: LiqThemeData.light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: LiqButton(label: '_', onPressed: () {}, size: entry.key),
              ),
            ),
          ),
        );
        expect(
          tester.getSize(find.byType(LiqButton)).height,
          entry.value,
          reason: '${entry.key} should be ${entry.value}pt tall',
        );
      }
    });

    testWidgets('liquid style samples backdrop content', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqButton(
                label: 'Glass',
                style: LiqButtonStyle.liquid,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
