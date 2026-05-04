// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget toggleGroupTextStyleBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 240,
    child: LiqDemo<Set<String>>(
      initial: const <String>{'bold'},
      builder: (sel, set) {
        // {@highlight}
        return LiqToggleGroup<String>(
          selected: sel,
          onChanged: set,
          items: const <LiqToggleGroupItem<String>>[
            LiqToggleGroupItem(value: 'bold', icon: Icons.format_bold),
            LiqToggleGroupItem(value: 'italic', icon: Icons.format_italic),
            LiqToggleGroupItem(
              value: 'underline',
              icon: Icons.format_underlined,
            ),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
