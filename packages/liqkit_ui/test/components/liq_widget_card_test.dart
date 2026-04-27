import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: SizedBox(width: 200, height: 200, child: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('LiqWidgetCard renders caption', (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqWidgetCard(caption: 'Mail', size: LiqWidgetSize.small)),
    );
    expect(find.text('Mail'), findsOneWidget);
  });

  testWidgets('LiqWidgetCard invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqWidgetCard(
          size: LiqWidgetSize.small,
          onPressed: () => taps++,
        ),
      ),
    );
    await tester.tap(find.byType(LiqWidgetCard));
    expect(taps, 1);
  });
}
