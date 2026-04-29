import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget badgeStatusBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: Wrap(
        spacing: 8,
        children: <Widget>[
          LiqBadge(label: 'New', variant: LiqBadgeVariant.primary),
          LiqBadge(label: 'Online', variant: LiqBadgeVariant.success),
          LiqBadge(label: 'Beta', variant: LiqBadgeVariant.warning),
          LiqBadge(label: 'Failed', variant: LiqBadgeVariant.destructive),
          LiqBadge(label: 'Draft'),
        ],
      ),
      // {@endhighlight}
    ),
  );
}
