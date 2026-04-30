// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget richEditorDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(width: 480, child: _RichEditorDefaultDemo()),
    ),
  );
}

class _RichEditorDefaultDemo extends StatefulWidget {
  @override
  State<_RichEditorDefaultDemo> createState() => _RichEditorDefaultDemoState();
}

class _RichEditorDefaultDemoState extends State<_RichEditorDefaultDemo> {
  late final LiqRichEditorController _controller = LiqRichEditorController(
    value: const LiqRichValue(
      text: 'liqkit_ui ships rich text out of the box.',
      ranges: <LiqRichRange>[
        LiqRichRange(start: 0, end: 9, format: LiqRichFormat.bold),
        LiqRichRange(start: 16, end: 25, format: LiqRichFormat.italic),
      ],
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // {@highlight}
    return LiqRichEditor(controller: _controller);
    // {@endhighlight}
  }
}
