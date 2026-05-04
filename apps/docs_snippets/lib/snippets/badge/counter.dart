import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget badgeCounterBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        LiqBadge(count: 3, variant: LiqBadgeVariant.primary),
        LiqBadge(count: 12),
        LiqBadge(count: 250, variant: LiqBadgeVariant.destructive),
      ],
    ),
    // {@endhighlight}
  );
}
