// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget datePickerFieldDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 560,
    height: 520,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
    child: Align(
      alignment: Alignment.topCenter,
      child: LiqDemo<DateTime?>(
        initial: null,
        builder:
            (v, set) => SizedBox(
              width: 360,
              // {@highlight}
              child: LiqDatePickerField(value: v, onChanged: set),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
