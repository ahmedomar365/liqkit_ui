// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget richEditorEmptyBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(width: 480, child: _RichEditorEmptyDemo()),
    ),
  );
}

class _RichEditorEmptyDemo extends StatefulWidget {
  @override
  State<_RichEditorEmptyDemo> createState() => _RichEditorEmptyDemoState();
}

class _RichEditorEmptyDemoState extends State<_RichEditorEmptyDemo> {
  final LiqRichEditorController _controller = LiqRichEditorController();

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
