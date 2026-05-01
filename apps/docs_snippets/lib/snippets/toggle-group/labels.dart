// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleGroupLabelsBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<Set<String>>(
        initial: const <String>{'mon', 'wed', 'fri'},
        builder: (sel, set) {
          return SizedBox(
            width: 360,
            // {@highlight}
            child: LiqToggleGroup<String>(
              selected: sel,
              onChanged: set,
              items: const <LiqToggleGroupItem<String>>[
                LiqToggleGroupItem(value: 'mon', label: 'Mon'),
                LiqToggleGroupItem(value: 'tue', label: 'Tue'),
                LiqToggleGroupItem(value: 'wed', label: 'Wed'),
                LiqToggleGroupItem(value: 'thu', label: 'Thu'),
                LiqToggleGroupItem(value: 'fri', label: 'Fri'),
              ],
            ),
            // {@endhighlight}
          );
        },
      ),
    ),
  );
}
