import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget colorPickerSmallBuilder(BuildContext context) {
  return const _ColorPickerSmallDemo();
}

class _ColorPickerSmallDemo extends StatefulWidget {
  const _ColorPickerSmallDemo();

  @override
  State<_ColorPickerSmallDemo> createState() => _ColorPickerSmallDemoState();
}

class _ColorPickerSmallDemoState extends State<_ColorPickerSmallDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 430,
      height: _open ? 820 : 64,
      child: Align(
        alignment: Alignment.topCenter,
        child: Transform.scale(
          scale: _open ? 0.82 : 1,
          alignment: Alignment.topCenter,
          child: LiqDemo<Color>(
            initial: const Color(0xFF34C759),
            builder:
                (color, set) =>
                // {@highlight}
                LiqColorPicker(
                  color: color,
                  buttonSize: LiqColorPickerButtonSize.small,
                  onChanged: set,
                  onOpenChanged: (open) => setState(() => _open = open),
                ),
            // {@endhighlight}
          ),
        ),
      ),
    );
  }
}
