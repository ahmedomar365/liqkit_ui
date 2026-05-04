import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget chipGroupBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<Set<String>>(
      initial: const <String>{'flutter'},
      builder:
          (selected, set) =>
          // {@highlight}
          LiqChipGroup(
            chips:
                const <String>['flutter', 'dart', 'ios', 'swift', 'rust']
                    .map(
                      (tag) => LiqChip(
                        label: tag,
                        selected: selected.contains(tag),
                        onPressed: () {
                          final next = Set<String>.from(selected);
                          if (next.contains(tag)) {
                            next.remove(tag);
                          } else {
                            next.add(tag);
                          }
                          set(next);
                        },
                      ),
                    )
                    .toList(),
          ),
      // {@endhighlight}
    ),
  );
}
