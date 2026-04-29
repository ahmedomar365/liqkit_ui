import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget chipDismissibleBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<List<String>>(
        initial: const <String>['Design', 'Code', 'Ship'],
        builder:
            (tags, set) =>
            // {@highlight}
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children:
                  tags
                      .map(
                        (t) => LiqChip(
                          label: t,
                          onDeleted: () {
                            final next = List<String>.from(tags)..remove(t);
                            set(next);
                          },
                        ),
                      )
                      .toList(),
            ),
        // {@endhighlight}
      ),
    ),
  );
}
