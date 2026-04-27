import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: ColoredBox(
        color: const Color(0xFF202020),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('LiqNotification renders title, body, and time', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqNotification(
          title: 'Mail',
          body: 'New message from Sam.',
          time: 'now',
          icon: LiqNotificationIcon(
            colors: LiqNotificationIconColors.mail,
            glyph: SizedBox.shrink(),
          ),
        ),
      ),
    );
    expect(find.text('Mail'), findsOneWidget);
    expect(find.text('New message from Sam.'), findsOneWidget);
    expect(find.text('now'), findsOneWidget);
  });

  testWidgets('LiqNotification omits time chip when null', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqNotification(
          title: 'Reminders',
          body: 'Buy milk.',
          icon: LiqNotificationIcon(
            colors: LiqNotificationIconColors.reminders,
            glyph: SizedBox.shrink(),
          ),
        ),
      ),
    );
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('now'), findsNothing);
  });
}
