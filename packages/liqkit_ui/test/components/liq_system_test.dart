import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: SizedBox(width: 400, child: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('LiqHomeIndicator renders bar', (tester) async {
    await tester.pumpWidget(_wrap(const LiqHomeIndicator()));
    expect(find.byType(LiqHomeIndicator), findsOneWidget);
  });

  testWidgets('LiqSystemActionPill renders label', (tester) async {
    await tester.pumpWidget(_wrap(const LiqSystemActionPill(label: 'Mute')));
    expect(find.text('Mute'), findsOneWidget);
  });

  testWidgets('LiqSystemActionPill keeps a 44pt tap target', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqSystemActionPill(label: 'Mute', onPressed: () {})),
    );

    expect(tester.getSize(find.byType(LiqSystemActionPill)).height, 44);
  });

  testWidgets('LiqSystemToggleDot renders selected variant', (tester) async {
    await tester.pumpWidget(_wrap(const LiqSystemToggleDot(selected: true)));
    expect(find.byType(LiqSystemToggleDot), findsOneWidget);
  });

  testWidgets('LiqSystemToggleDot keeps a 44pt tap target', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqSystemToggleDot(selected: true, onPressed: () {})),
    );

    expect(tester.getSize(find.byType(LiqSystemToggleDot)), const Size(44, 44));
  });
}
