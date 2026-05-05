import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Center(child: child),
      ),
    ),
  );
}

Widget _wrapDark(Widget child) {
  return LiqTheme(
    data: LiqThemeData.dark,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('LiqMenu renders all child rows', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqMenu(
          children: <Widget>[
            LiqMenuSectionTitle(title: 'Edit'),
            LiqMenuItem(label: 'Cut'),
            LiqMenuItem(label: 'Copy'),
            LiqMenuSeparator(),
            LiqMenuItem(label: 'Delete', style: LiqMenuItemStyle.destructive),
          ],
        ),
      ),
    );
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Cut'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('LiqMenuItem invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqMenu(
          children: <Widget>[
            LiqMenuItem(label: 'Tap me', onPressed: () => taps++),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Tap me'));
    expect(taps, 1);
  });

  testWidgets('LiqMenuItem scales while pressed', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqMenu(
          children: <Widget>[LiqMenuItem(label: 'Tap me', onPressed: () {})],
        ),
      ),
    );

    AnimatedScale scale() => tester.widget<AnimatedScale>(
      find
          .ancestor(
            of: find.text('Tap me'),
            matching: find.byType(AnimatedScale),
          )
          .first,
    );

    expect(scale().scale, 1);

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Tap me')),
    );
    await tester.pump();

    expect(scale().scale, 0.985);

    await gesture.up();
    await tester.pump();

    expect(scale().scale, 1);
  });

  testWidgets('LiqMenuQuickAction scales while pressed', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqMenu(
          quickActions: <LiqMenuQuickAction>[
            LiqMenuQuickAction(
              label: 'Copy',
              icon: const Text('C'),
              onPressed: () {},
            ),
          ],
          children: const <Widget>[LiqMenuItem(label: 'Row')],
        ),
      ),
    );

    AnimatedScale scale() => tester.widget<AnimatedScale>(
      find
          .ancestor(of: find.text('Copy'), matching: find.byType(AnimatedScale))
          .first,
    );

    expect(scale().scale, 1);

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Copy')),
    );
    await tester.pump();

    expect(scale().scale, 0.96);

    await gesture.up();
    await tester.pump();

    expect(scale().scale, 1);
  });

  testWidgets('LiqMenu resolves dark surface and row color from theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapDark(
        LiqMenu(
          children: <Widget>[
            const LiqMenuSectionTitle(title: 'Edit'),
            LiqMenuItem(label: 'Copy', onPressed: () {}),
            const LiqMenuSeparator(),
          ],
        ),
      ),
    );

    final glass = tester.widget<LiqGlassSurface>(find.byType(LiqGlassSurface));
    expect(glass.tint, LiqGlassTint.dark);
    expect(glass.borderRadius, const BorderRadius.all(Radius.circular(34)));
    expect(glass.baseFill, const Color(0xDC18181A));
    expect(glass.rimColor, const Color(0x70E4E9EF));
    expect(glass.highlightStart, const Color(0x06FFFFFF));
    expect(glass.blurSigma, 20);

    final label = tester.widget<Text>(find.text('Copy'));
    expect(label.style?.color, const Color(0xFFF5F5F5));
  });
}
