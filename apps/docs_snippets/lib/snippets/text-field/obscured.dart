import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget textFieldObscuredBuilder(BuildContext context) {
  // {@highlight}
  return Center(child: _TextFieldObscuredExample());
  // {@endhighlight}
}

class _TextFieldObscuredExample extends StatefulWidget {
  @override
  State<_TextFieldObscuredExample> createState() =>
      _TextFieldObscuredExampleState();
}

class _TextFieldObscuredExampleState extends State<_TextFieldObscuredExample> {
  final TextEditingController _controller = TextEditingController(
    text: 'password123',
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
      placeholder: 'Password',
      obscureText: true,
    );
  }
}
