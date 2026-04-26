import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';
import 'package:liqkit_ui/src/theme/liq_theme_data.dart';

/// How [LiqApp] selects between its [LiqApp.light] and [LiqApp.dark]
/// themes. Defined locally so liqkit_ui doesn't drag in
/// `package:flutter/material.dart` (where Material's `ThemeMode` lives).
enum LiqThemeMode {
  /// Always use the [LiqApp.light] theme.
  light,

  /// Always use the [LiqApp.dark] theme.
  dark,

  /// Follow `MediaQuery.platformBrightnessOf(context)`.
  system,
}

/// Convenience root widget that installs [LiqTheme] selecting between
/// [light] and [dark] based on [themeMode] and platform brightness.
class LiqApp extends StatelessWidget {
  /// Creates a liqkit_ui app root.
  const LiqApp({
    required this.light,
    required this.dark,
    required this.home,
    this.themeMode = LiqThemeMode.system,
    this.title = '',
    super.key,
  });

  /// Theme used in light mode.
  final LiqThemeData light;

  /// Theme used in dark mode.
  final LiqThemeData dark;

  /// How the active theme is selected.
  final LiqThemeMode themeMode;

  /// Root widget rendered inside the resolved theme.
  final Widget home;

  /// App title.
  final String title;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: title,
      color: const Color(0xFF000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (c, _, _) => builder(c),
      ),
      builder: (context, child) {
        final brightness = _resolveBrightness(context);
        final data = brightness == Brightness.dark ? dark : light;
        return LiqTheme(
          data: data,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: home,
    );
  }

  Brightness _resolveBrightness(BuildContext context) {
    switch (themeMode) {
      case LiqThemeMode.light:
        return Brightness.light;
      case LiqThemeMode.dark:
        return Brightness.dark;
      case LiqThemeMode.system:
        return MediaQuery.platformBrightnessOf(context);
    }
  }
}
