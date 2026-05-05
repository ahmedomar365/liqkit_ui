import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child, {MediaQueryData media = const MediaQueryData()}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(data: media, child: Center(child: child)),
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

  testWidgets('LiqPopupButton keeps a 44pt tap target', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqPopupButton(label: 'Sort', onPressed: () {})),
    );
    expect(tester.getSize(find.byType(LiqPopupButton)).height, 44);
  });

  testWidgets('LiqPopupButton scales and fades while pressed', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqPopupButton(label: 'Sort', onPressed: () {})),
    );

    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(LiqPopupButton)),
    );
    await tester.pump();

    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
      0.96,
    );
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0.72,
    );

    await gesture.up();
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
  });

  testWidgets('LiqPopupButton honors reduced motion', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqPopupButton(label: 'Sort', onPressed: () {}),
        media: const MediaQueryData(disableAnimations: true),
      ),
    );

    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
      Duration.zero,
    );
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).duration,
      Duration.zero,
    );
  });

  testWidgets('LiqPopupButton disables when onPressed is null', (tester) async {
    await tester.pumpWidget(_wrap(const LiqPopupButton(label: 'X')));
    expect(find.text('X'), findsOneWidget);
  });
}
