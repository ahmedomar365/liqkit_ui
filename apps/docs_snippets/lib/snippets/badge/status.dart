import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget badgeStatusBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        LiqBadge(label: 'New', variant: LiqBadgeVariant.primary),
        LiqBadge(label: 'Online', variant: LiqBadgeVariant.success),
        LiqBadge(label: 'Beta', variant: LiqBadgeVariant.warning),
        LiqBadge(label: 'Failed', variant: LiqBadgeVariant.destructive),
        LiqBadge(label: 'Draft'),
      ],
    ),
    // {@endhighlight}
  );
}
