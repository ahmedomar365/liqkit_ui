import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget timePickerIntervalsBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<DateTime>(
        initial: DateTime(2026, 4, 29, 14, 30),
        builder:
            (t, set) => SizedBox(
              width: 320,
              // {@highlight}
              child: LiqTimePicker(
                value: t,
                onChanged: set,
                minuteInterval: 15,
              ),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
