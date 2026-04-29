import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget avatarGroupBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: LiqAvatarGroup(
        avatars: <LiqAvatar>[
          LiqAvatar(initials: 'JD'),
          LiqAvatar(initials: 'AB'),
          LiqAvatar(initials: 'KL'),
          LiqAvatar(initials: 'MN'),
          LiqAvatar(initials: 'OP'),
        ],
      ),
      // {@endhighlight}
    ),
  );
}
