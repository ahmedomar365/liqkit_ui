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
  testWidgets('LiqSheet renders the configured title', (tester) async {
    await tester.pumpWidget(_wrap(const LiqSheet(title: 'Inspector')));
    expect(find.text('Inspector'), findsOneWidget);
  });

  testWidgets('LiqSheet shows a grabber and default top buttons', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const LiqSheet(title: 'Title')));
    expect(find.byType(LiqSheetGrabber), findsOneWidget);
    expect(find.byType(LiqSheetTopButton), findsNWidgets(2));
  });

  testWidgets('LiqSheet shrinks to fit narrow constraints', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(width: 320, child: LiqSheet(title: 'Responsive Sheet')),
      ),
    );

    expect(tester.getSize(find.byType(LiqSheet)), const Size(320, 360));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SizedBox && (widget.width ?? 0) > 320,
      ),
      findsNothing,
    );
  });

  testWidgets('LiqSheetTopButton invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(LiqSheetTopButton(onPressed: () => taps++, child: const Text('×'))),
    );
    await tester.tap(find.byType(LiqSheetTopButton));
    expect(taps, 1);
  });

  testWidgets('LiqSheetTopButton exposes click cursor when enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(LiqSheetTopButton(onPressed: () {}, child: const Text('×'))),
    );

    final mouseRegion = tester.widget<MouseRegion>(
      find.descendant(
        of: find.byType(LiqSheetTopButton),
        matching: find.byType(MouseRegion),
      ),
    );
    expect(mouseRegion.cursor, SystemMouseCursors.click);
  });

  testWidgets('LiqSheetTopButton scales while pressed', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqSheetTopButton(onPressed: () {}, child: const Text('×'))),
    );

    AnimatedScale scale() => tester.widget<AnimatedScale>(
      find.descendant(
        of: find.byType(LiqSheetTopButton),
        matching: find.byType(AnimatedScale),
      ),
    );

    expect(scale().scale, 1);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(LiqSheetTopButton)),
    );
    await tester.pump();

    expect(scale().scale, 0.92);

    await gesture.up();
    await tester.pump();

    expect(scale().scale, 1);
  });
}
