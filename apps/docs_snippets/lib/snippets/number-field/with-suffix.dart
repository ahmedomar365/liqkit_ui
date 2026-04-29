// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget numberFieldWithSuffixBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<num>(
        initial: 1,
        builder:
            (n, set) => SizedBox(
              width: 320,
              // {@highlight}
              child: LiqNumberField(
                value: n,
                onChanged: set,
                max: 99,
                step: 0.5,
                suffix: ' kg',
              ),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
