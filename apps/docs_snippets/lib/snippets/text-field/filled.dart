import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textFieldFilledBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: _TextFieldFilledExample(),
  );
  // {@endhighlight}
}

class _TextFieldFilledExample extends StatefulWidget {
  @override
  State<_TextFieldFilledExample> createState() =>
      _TextFieldFilledExampleState();
}

class _TextFieldFilledExampleState extends State<_TextFieldFilledExample> {
  final TextEditingController _controller =
      TextEditingController(text: 'Hello, World!');

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
    );
  }
}
