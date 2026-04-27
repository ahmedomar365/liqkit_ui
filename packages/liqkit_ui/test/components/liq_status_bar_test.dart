import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: SizedBox(width: 402, child: child),
    ),
  );
}

void main() {
  testWidgets('LiqStatusBar renders the time', (tester) async {
    await tester.pumpWidget(_wrap(const LiqStatusBar()));
    expect(find.text('9:41'), findsOneWidget);
  });

  testWidgets('LiqStatusBar accepts a custom time', (tester) async {
    await tester.pumpWidget(_wrap(const LiqStatusBar(time: '12:34')));
    expect(find.text('12:34'), findsOneWidget);
  });

  testWidgets('LiqStatusBar dark surface still renders', (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqStatusBar(brightness: Brightness.dark)),
    );
    expect(find.text('9:41'), findsOneWidget);
  });
}
