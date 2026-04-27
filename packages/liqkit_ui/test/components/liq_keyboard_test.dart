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
  testWidgets('LiqKeyboard renders default suggestions', (tester) async {
    await tester.pumpWidget(_wrap(const LiqKeyboard()));
    expect(find.text('"The"'), findsOneWidget);
    expect(find.text('the'), findsOneWidget);
    expect(find.text('to'), findsOneWidget);
  });

  testWidgets('LiqKeyboard renders all default key labels', (tester) async {
    await tester.pumpWidget(_wrap(const LiqKeyboard()));
    expect(find.text('q'), findsOneWidget);
    expect(find.text('a'), findsOneWidget);
    expect(find.text('m'), findsOneWidget);
  });

  testWidgets('LiqKeyboard accepts custom rows and suggestions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqKeyboard(
          suggestions: <String>['I', 'I am', 'I will'],
          keyRows: <List<String>>[
            <String>['1', '2', '3'],
          ],
        ),
      ),
    );
    expect(find.text('I am'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('q'), findsNothing);
  });
}
