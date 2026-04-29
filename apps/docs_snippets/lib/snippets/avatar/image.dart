import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget avatarImageBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: LiqAvatar(
        image: NetworkImage('https://i.pravatar.cc/120?img=12'),
        initials: 'AB',
      ),
      // {@endhighlight}
    ),
  );
}
