import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() => runApp(const DemoApp());

/// Demo app placeholder. Real screens land alongside the per-batch
/// component plans.
class DemoApp extends StatelessWidget {
  /// Creates the demo app.
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'liqkit_ui demo',
      color: const Color(0xFF000000),
      builder: (context, child) => const Center(
        child: Text(
          'liqkit_ui demo - bootstrap (marker: $liqkitUiBootstrapMarker)',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
