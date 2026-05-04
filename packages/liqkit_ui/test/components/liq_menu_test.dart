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

Color menuPanelColor(WidgetTester tester) {
  final boxes = tester.widgetList<DecoratedBox>(
    find.descendant(
      of: find.byType(LiqMenu),
      matching: find.byType(DecoratedBox),
    ),
  );
  for (final box in boxes) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color != null) {
      return decoration.color!;
    }
  }
  throw StateError('No menu panel fill found.');
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

    expect(menuPanelColor(tester), const Color(0xD91A1A1A));

    final label = tester.widget<Text>(find.text('Copy'));
    expect(label.style?.color, const Color(0xFFF5F5F5));
  });
}
