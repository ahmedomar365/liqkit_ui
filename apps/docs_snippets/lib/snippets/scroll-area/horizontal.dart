// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget scrollAreaHorizontalBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 320,
        height: 80,
        // {@highlight}
        child: LiqScrollArea(
          axis: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: List<Widget>.generate(
              24,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Item ${i + 1}',
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
