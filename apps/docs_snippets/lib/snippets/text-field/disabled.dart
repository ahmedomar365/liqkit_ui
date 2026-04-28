import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textFieldDisabledBuilder(BuildContext context) {
  // {@highlight}
  return Align(heightFactor: 1, child: _TextFieldDisabledExample());
  // {@endhighlight}
}

class _TextFieldDisabledExample extends StatefulWidget {
  @override
  State<_TextFieldDisabledExample> createState() =>
      _TextFieldDisabledExampleState();
}

class _TextFieldDisabledExampleState extends State<_TextFieldDisabledExample> {
  final TextEditingController _controller = TextEditingController(
    text: 'Read only',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiqTextField(
      controller: _controller,
      placeholder: 'Placeholder',
      enabled: false,
    );
  }
}
