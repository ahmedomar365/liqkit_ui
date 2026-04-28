import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popoverTopBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqPopover(
      child: Text(
        'Tip on top',
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
