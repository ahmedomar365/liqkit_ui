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
    return const LiqApp(
      title: 'liqkit_ui demo',
      light: LiqThemeData.light,
      dark: LiqThemeData.dark,
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    final theme = LiqTheme.of(context);
    return ColoredBox(
      color: theme.surfaceColor.resolve(theme.brightness),
      child: Center(
        child: Text(
          'liqkit_ui demo',
          style: theme.titleText.toTextStyle().copyWith(
                color: theme.labelColor.resolve(theme.brightness),
              ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
