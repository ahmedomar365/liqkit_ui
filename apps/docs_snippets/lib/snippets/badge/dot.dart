import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget badgeDotBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: Wrap(
        spacing: 12,
        children: <Widget>[
          LiqBadge(dot: true, variant: LiqBadgeVariant.primary),
          LiqBadge(dot: true, variant: LiqBadgeVariant.success),
          LiqBadge(dot: true, variant: LiqBadgeVariant.warning),
          LiqBadge(dot: true, variant: LiqBadgeVariant.destructive),
        ],
      ),
      // {@endhighlight}
    ),
  );
}
