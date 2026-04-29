// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget cardWithHeaderBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 360,
        // {@highlight}
        child: LiqCard(
          header: Text(
            'Title',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          child: Text('Body content under a header divider.'),
        ),
        // {@endhighlight}
      ),
    ),
  );
}
