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
  testWidgets('LiqPopover renders its child', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqPopover(
          child: Text('Hello', textDirection: TextDirection.ltr),
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('LiqPopover supports all four sides', (tester) async {
    for (final side in LiqPopoverSide.values) {
      await tester.pumpWidget(
        _wrap(
          LiqPopover(
            side: side,
            child: const Text('x', textDirection: TextDirection.ltr),
          ),
        ),
      );
      expect(find.text('x'), findsOneWidget);
    }
  });
}
