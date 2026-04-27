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
  testWidgets('LiqSidebar renders rows + section headers + search',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqSidebar(
          children: <Widget>[
            LiqSidebarSearch(),
            LiqSidebarSectionHeader(title: 'Mailboxes', detail: '12'),
            LiqSidebarRow(title: 'All Inboxes', detail: '42'),
            LiqSidebarRow(title: 'VIP', selected: true),
          ],
        ),
      ),
    );
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Mailboxes'), findsOneWidget);
    expect(find.text('All Inboxes'), findsOneWidget);
    expect(find.text('VIP'), findsOneWidget);
  });

  testWidgets('LiqSidebarRow invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqSidebar(
          children: <Widget>[
            LiqSidebarRow(title: 'Tap me', onPressed: () => taps++),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Tap me'));
    expect(taps, 1);
  });
}
