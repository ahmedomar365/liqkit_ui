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
