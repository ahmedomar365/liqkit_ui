import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget notificationMailBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqNotification(
      title: 'Mail',
      body: 'You have a new message from Alex.',
      time: 'now',
      icon: LiqNotificationIcon(
        colors: LiqNotificationIconColors.mail,
        glyph: SizedBox(
          width: 22,
          height: 16,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
      ),
    ),
  );
  // {@endhighlight}
}
