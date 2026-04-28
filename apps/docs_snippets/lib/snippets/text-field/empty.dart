import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textFieldEmptyBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: _TextFieldEmptyExample(),
  );
  // {@endhighlight}
}

class _TextFieldEmptyExample extends StatefulWidget {
  @override
  State<_TextFieldEmptyExample> createState() => _TextFieldEmptyExampleState();
}

class _TextFieldEmptyExampleState extends State<_TextFieldEmptyExample> {
  final TextEditingController _controller = TextEditingController();

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
