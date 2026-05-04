import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget colorPickerLargeBuilder(BuildContext context) {
  return const _ColorPickerLargeDemo();
}

class _ColorPickerLargeDemo extends StatefulWidget {
  const _ColorPickerLargeDemo();

  @override
  State<_ColorPickerLargeDemo> createState() => _ColorPickerLargeDemoState();
}

class _ColorPickerLargeDemoState extends State<_ColorPickerLargeDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 430,
      height: _open ? 690 : 64,
      child: Align(
        alignment: Alignment.topCenter,
        child: LiqDemo<Color>(
          initial: const Color(0xFFAF52DE),
          builder:
              (color, set) =>
              // {@highlight}
              LiqColorPicker(
                color: color,
                onChanged: set,
                onOpenChanged: (open) => setState(() => _open = open),
              ),
          // {@endhighlight}
        ),
      ),
    );
  }
}
