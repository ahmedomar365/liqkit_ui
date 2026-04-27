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
}
