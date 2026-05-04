import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget labelOptionalBuilder(BuildContext context) {
  return SnippetFrame(
    // {@highlight}
    child: _LabelOptionalExample(),
    // {@endhighlight}
  );
}

class _LabelOptionalExample extends StatefulWidget {
  @override
  State<_LabelOptionalExample> createState() => _LabelOptionalExampleState();
}

class _LabelOptionalExampleState extends State<_LabelOptionalExample> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiqFormField(
      label: 'Phone',
      optional: true,
      helperText: 'Used only for delivery updates',
      child: LiqTextField(
        controller: _controller,
        placeholder: '(555) 123-4567',
      ),
    );
  }
}
