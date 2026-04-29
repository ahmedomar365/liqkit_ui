// ignore_for_file: file_names // hyphenated name required by snippet manifest convention

import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dividerWithLabelBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: SizedBox(width: 320, child: LiqLabeledDivider(label: 'OR')),
      // {@endhighlight}
    ),
  );
}
