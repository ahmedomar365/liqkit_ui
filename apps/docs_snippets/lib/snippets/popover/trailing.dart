import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popoverTrailingBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqPopover(
      side: LiqPopoverSide.trailing,
      child: Text(
        'Tip on trailing',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 15,
          color: Color(0xFF1A1A1A),
        ),
      ),
    ),
  );
  // {@endhighlight}
}
