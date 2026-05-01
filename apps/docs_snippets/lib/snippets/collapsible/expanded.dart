// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget collapsibleExpandedBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 360,
        // {@highlight}
        child: LiqCollapsible(
          initiallyExpanded: true,
          header: Text(
            'What is liqkit_ui?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'A Flutter port of the liqkit iOS 26 design system. 76 '
              'components ship with goldens, live previews, and '
              'interactive code snippets.',
              style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 14),
            ),
          ),
        ),
        // {@endhighlight}
      ),
    ),
  );
}
