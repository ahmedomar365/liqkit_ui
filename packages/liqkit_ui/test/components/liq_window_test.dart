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
  testWidgets('LiqWindow renders default size', (tester) async {
    await tester.pumpWidget(
      _wrap(const SizedBox(width: 1024, height: 720, child: LiqWindow())),
    );
    expect(find.byType(LiqWindow), findsOneWidget);
  });

  testWidgets('LiqWindowToolbar renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 800,
          child: LiqWindowToolbar(title: 'Mail', subtitle: 'Inbox'),
        ),
      ),
    );
    expect(find.text('Mail'), findsOneWidget);
    expect(find.text('Inbox'), findsOneWidget);
  });

  testWidgets('LiqWindowControls renders three dots', (tester) async {
    await tester.pumpWidget(_wrap(const LiqWindowControls()));
    expect(find.byType(LiqWindowControls), findsOneWidget);
  });
}
