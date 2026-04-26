import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() => runApp(const PlaygroundApp());

/// Playground app. Edit freely - this is the sandbox.
class PlaygroundApp extends StatelessWidget {
  /// Creates the playground app.
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LiqApp(
      title: 'liqkit_ui playground',
      light: LiqThemeData.light,
      dark: LiqThemeData.dark,
      home: SizedBox(),
    );
  }
}
