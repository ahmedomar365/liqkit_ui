import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() => runApp(const _BootstrapApp());

class _BootstrapApp extends StatelessWidget {
  const _BootstrapApp();

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'liqkit_ui example',
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
