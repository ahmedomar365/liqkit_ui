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
  testWidgets('LiqAppIcon renders label and badge', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqAppIcon(
          color: Color(0xFF0088FF),
          label: 'Mail',
          badge: LiqAppIconBadge(count: 3),
        ),
      ),
    );
    expect(find.text('Mail'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('LiqAppIconBadge clamps at 99+', (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqAppIconBadge(count: 250)),
    );
    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets('LiqAppIcon invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqAppIcon(
          color: const Color(0xFFFF3B30),
          onPressed: () => taps++,
        ),
      ),
    );
    await tester.tap(find.byType(LiqAppIcon));
    expect(taps, 1);
  });
}
