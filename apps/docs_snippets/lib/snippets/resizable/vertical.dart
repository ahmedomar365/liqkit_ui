import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget resizableVerticalBuilder(BuildContext context) {
  return const SnippetFrame(
    surface: SnippetFrameSurface.themed,
    maxWidth: 480,
    height: 320,
    surfacePadding: EdgeInsets.all(12),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      // {@highlight}
      child: LiqResizable(
        direction: LiqResizableDirection.vertical,
        first: _ResizablePane(label: 'Top', emphasized: true),
        second: _ResizablePane(label: 'Bottom'),
      ),
      // {@endhighlight}
    ),
  );
}

class _ResizablePane extends StatelessWidget {
  const _ResizablePane({required this.label, this.emphasized = false});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final brightness =
        LiqTheme.maybeOf(context)?.brightness ?? Brightness.light;
    final isDark = brightness == Brightness.dark;
    return ColoredBox(
      color:
          isDark
              ? emphasized
                  ? const Color(0xFF242428)
                  : const Color(0xFF1C1C1E)
              : emphasized
              ? const Color(0xFFFAFAFA)
              : const Color(0xFFFFFFFF),
      child: Center(child: SnippetLabel(label, fontWeight: FontWeight.w500)),
    );
  }
}
