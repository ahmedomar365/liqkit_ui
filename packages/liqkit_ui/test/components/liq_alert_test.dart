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
  testWidgets('LiqAlert renders title, description, and a single action',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqAlert(
          title: 'Confirm',
          description: 'Are you sure?',
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'OK'),
          ],
        ),
      ),
    );
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('LiqAlert sideBySide layout requires exactly two actions',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqAlert(
          title: 'X',
          layout: LiqAlertActionLayout.sideBySide,
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'Only'),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('LiqAlert action invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqAlert(
          title: 'Tap',
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'Hit', onPressed: () => taps++),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Hit'));
    expect(taps, 1);
  });
}
