import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() => runApp(const PlaygroundApp());

/// Playground app. Edit freely - this is the sandbox.
class PlaygroundApp extends StatelessWidget {
  /// Creates the playground app.
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'liqkit_ui playground',
      color: const Color(0xFF000000),
      builder: (context, child) => const Center(
        child: Text(
          liqkitUiBootstrapMarker,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
