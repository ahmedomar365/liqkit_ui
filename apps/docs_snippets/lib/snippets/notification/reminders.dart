import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget notificationRemindersBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 420,
    height: 190,
    surface: SnippetFrameSurface.liquidDark,
    surfacePadding: EdgeInsets.all(20),
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
