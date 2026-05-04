// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textareaWithCounterBuilder(BuildContext context) {
  return SnippetFrame(maxWidth: 480, child: _Demo());
}

class _Demo extends StatefulWidget {
  @override
  State<_Demo> createState() => _DemoState();
}

class _DemoState extends State<_Demo> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // {@highlight}
    return LiqTextarea(
      controller: _controller,
      placeholder: "What's happening?",
      maxLength: 280,
      showCounter: true,
    );
    // {@endhighlight}
  }
}
