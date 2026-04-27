import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: SizedBox(width: 360, child: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('LiqEmptyState renders title + description', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqEmptyState(
          title: 'No Messages',
          description: 'Your inbox is empty.',
        ),
      ),
    );
    expect(find.text('No Messages'), findsOneWidget);
    expect(find.text('Your inbox is empty.'), findsOneWidget);
  });

  testWidgets('LiqEmptyStateCta invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqEmptyState(
          title: 'X',
          cta: LiqEmptyStateCta(label: 'Compose', onPressed: () => taps++),
        ),
      ),
    );
    await tester.tap(find.text('Compose'));
    expect(taps, 1);
  });
}
