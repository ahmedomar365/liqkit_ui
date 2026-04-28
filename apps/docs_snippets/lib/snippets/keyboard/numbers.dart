// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget keyboardNumbersBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqKeyboard(
      width: 360,
      minHeight: 320,
      suggestions: <String>['1', '2', '3'],
      keyRows: <List<String>>[
        <String>['1', '2', '3'],
        <String>['4', '5', '6'],
        <String>['7', '8', '9'],
        <String>['0'],
      ],
    ),
  );
  // {@endhighlight}
}
