// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget glassSurfaceFloatingBuilder(BuildContext context) {
  return const SizedBox(
    width: 400,
    height: 200,
    child: ColoredBox(
      // Simulated background content sitting behind the glass.
      color: Color(0xFFEFEFF4),
      child: Center(
        // {@highlight}
        child: LiqGlassSurface(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 240,
            child: Text(
              'Liquid Glass — translucent surface with backdrop blur, '
              'hairline rim, and a subtle vibrancy highlight at the top.',
              style: TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
            ),
          ),
        ),
        // {@endhighlight}
      ),
    ),
  );
}
