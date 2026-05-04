import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget labelRequiredBuilder(BuildContext context) {
  return SnippetFrame(
    // {@highlight}
    child: _LabelRequiredExample(),
    // {@endhighlight}
  );
}

class _LabelRequiredExample extends StatefulWidget {
  @override
  State<_LabelRequiredExample> createState() => _LabelRequiredExampleState();
}

class _LabelRequiredExampleState extends State<_LabelRequiredExample> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiqFormField(
      label: 'Email',
      required: true,
      helperText: 'We never share your email.',
      child: LiqTextField(
        controller: _controller,
        placeholder: 'you@example.com',
      ),
    );
  }
}
