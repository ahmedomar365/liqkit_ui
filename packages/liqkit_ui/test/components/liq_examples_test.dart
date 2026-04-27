import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: SizedBox(width: 400, child: child),
    ),
  );
}

void main() {
  testWidgets('LiqExamplesPanel renders title body and child',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const LiqExamplesPanel(
        title: 'Buttons',
        body: 'A few examples.',
        child: Text('Inner', textDirection: TextDirection.ltr),
      ),
    ));
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('A few examples.'), findsOneWidget);
    expect(find.text('Inner'), findsOneWidget);
  });

  testWidgets('LiqExamplesSection renders meta', (tester) async {
    await tester.pumpWidget(_wrap(
      const LiqExamplesSection(
        title: 'Pickers',
        meta: '12 examples',
        child: SizedBox.shrink(),
      ),
    ));
    expect(find.text('Pickers'), findsOneWidget);
    expect(find.text('12 examples'), findsOneWidget);
  });

  testWidgets('LiqExamplesItem renders name and code', (tester) async {
    await tester.pumpWidget(_wrap(
      const LiqExamplesItem(
        name: 'Default',
        code: 'LiqButton.regular',
      ),
    ));
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('LiqButton.regular'), findsOneWidget);
  });
}
