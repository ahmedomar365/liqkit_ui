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
  testWidgets('LiqPopupButton renders the label', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqPopupButton(label: 'Sort', onPressed: () {})),
    );
    expect(find.text('Sort'), findsOneWidget);
  });

  testWidgets('LiqPopupButton invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(LiqPopupButton(label: 'Tap', onPressed: () => taps++)),
    );
    await tester.tap(find.byType(LiqPopupButton));
    expect(taps, 1);
  });

  testWidgets('LiqPopupButton disables when onPressed is null', (tester) async {
    await tester.pumpWidget(_wrap(const LiqPopupButton(label: 'X')));
    expect(find.text('X'), findsOneWidget);
  });
}
