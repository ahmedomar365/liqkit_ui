import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget chipSingleBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: Wrap(
        spacing: 6,
        runSpacing: 8,
        children: <Widget>[
          LiqChip(label: 'flutter'),
          LiqChip(label: 'dart', selected: true),
          LiqChip(label: 'ios'),
        ],
      ),
      // {@endhighlight}
    ),
  );
}
