// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget scrollAreaVerticalBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 320,
        height: 200,
        // {@highlight}
        child: LiqScrollArea(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List<Widget>.generate(
              24,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Row ${i + 1}',
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ),
        // {@endhighlight}
      ),
    ),
  );
}
