import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget notificationRemindersBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqNotification(
      title: 'Reminders',
      body: 'Team standup starts in 5 minutes.',
      time: '5m',
      icon: LiqNotificationIcon(
        colors: LiqNotificationIconColors.reminders,
        glyph: SizedBox(
          width: 18,
          height: 18,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ),
  );
  // {@endhighlight}
}
