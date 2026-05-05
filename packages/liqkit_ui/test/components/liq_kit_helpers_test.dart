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
  testWidgets('LiqKitHelpersHeader renders title and description', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqKitHelpersHeader(
          title: 'Buttons',
          description: 'Tappable controls.',
        ),
      ),
    );
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Tappable controls.'), findsOneWidget);
  });

  testWidgets('LiqKitHelpersModePill light renders label', (tester) async {
    await tester.pumpWidget(_wrap(const LiqKitHelpersModePill(label: 'Light')));
    expect(find.text('Light'), findsOneWidget);
  });

  testWidgets('LiqKitHelpersModePill keeps compact minimum size', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const LiqKitHelpersModePill(label: 'Light')));

    expect(
      tester.getSize(find.byType(LiqKitHelpersModePill)).width,
      greaterThanOrEqualTo(54),
    );
    expect(tester.getSize(find.byType(LiqKitHelpersModePill)).height, 19);
  });

  testWidgets('LiqKitHelpersModePill expands for longer labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const LiqKitHelpersModePill(label: 'High Contrast')),
    );

    expect(
      tester.getSize(find.byType(LiqKitHelpersModePill)).width,
      greaterThan(54),
    );
    expect(find.text('High Contrast'), findsOneWidget);
  });

  testWidgets('LiqKitHelpersModeLabels stacks pills', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqKitHelpersModeLabels(
          children: <Widget>[
            LiqKitHelpersModePill(label: 'Light'),
            LiqKitHelpersModePill(
              label: 'Dark',
              brightness: LiqKitHelpersBrightness.dark,
            ),
          ],
        ),
      ),
    );
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });
}
