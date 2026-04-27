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
  testWidgets('LiqActionSheet renders title, actions, and cancel', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqActionSheet(
          title: 'Sort by',
          actions: <LiqAlertAction>[
            LiqAlertAction(label: 'Date'),
            LiqAlertAction(label: 'Name'),
            LiqAlertAction(label: 'Size'),
          ],
          cancelAction: LiqAlertAction(label: 'Cancel'),
        ),
      ),
    );
    expect(find.text('Sort by'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('LiqActionSheet without header renders only actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqActionSheet(
          actions: <LiqAlertAction>[
            LiqAlertAction(
              label: 'Delete',
              style: LiqAlertActionStyle.destructive,
            ),
          ],
        ),
      ),
    );
    expect(find.text('Delete'), findsOneWidget);
  });
}
