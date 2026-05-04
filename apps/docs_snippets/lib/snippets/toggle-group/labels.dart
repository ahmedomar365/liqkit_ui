// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleGroupLabelsBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    child: LiqDemo<Set<String>>(
      initial: const <String>{'mon', 'wed', 'fri'},
      builder: (sel, set) {
        // {@highlight}
        return LiqToggleGroup<String>(
          selected: sel,
          onChanged: set,
          items: const <LiqToggleGroupItem<String>>[
            LiqToggleGroupItem(value: 'mon', label: 'Mon'),
            LiqToggleGroupItem(value: 'tue', label: 'Tue'),
            LiqToggleGroupItem(value: 'wed', label: 'Wed'),
            LiqToggleGroupItem(value: 'thu', label: 'Thu'),
            LiqToggleGroupItem(value: 'fri', label: 'Fri'),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
