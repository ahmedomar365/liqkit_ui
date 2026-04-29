import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget chipGroupBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<Set<String>>(
        initial: const <String>{'flutter'},
        builder:
            (selected, set) => SizedBox(
              width: 320,
              // {@highlight}
              child: LiqChipGroup(
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
      ),
    ),
  );
}
