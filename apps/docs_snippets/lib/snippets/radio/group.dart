import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget radioGroupBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: LiqDemo<String>(
      initial: 'auto',
      builder: (v, set) {
        // {@highlight}
        return SizedBox(
          width: 320,
          child: LiqRadioGroup<String>(
            value: v,
            onChanged: set,
            options: const <({String value, String label})>[
              (value: 'auto', label: 'Auto'),
              (value: 'light', label: 'Light'),
              (value: 'dark', label: 'Dark'),
            ],
          ),
        );
        // {@endhighlight}
      },
    ),
  );
}
