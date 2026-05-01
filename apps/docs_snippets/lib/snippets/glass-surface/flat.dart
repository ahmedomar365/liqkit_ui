// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget glassSurfaceFlatBuilder(BuildContext context) {
  return const SizedBox(
    width: 400,
    height: 200,
    child: ColoredBox(
      color: Color(0xFFEFEFF4),
      child: Center(
        // {@highlight}
        child: LiqGlassSurface(
          elevation: LiqGlassElevation.flat,
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 240,
            child: Text(
              'Flat elevation — sits inline on its parent with no '
              'outer drop shadow. Use for sidebars, inline panels, '
              'and grouped settings rows.',
              style: TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
            ),
          ),
        ),
        // {@endhighlight}
      ),
    ),
  );
}
