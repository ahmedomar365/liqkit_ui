import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/theme/liq_theme_data.dart';

/// The `InheritedTheme` that distributes [LiqThemeData] to descendants.
class LiqTheme extends InheritedTheme {
  /// Installs [data] in the inherited tree for [child].
  const LiqTheme({required this.data, required super.child, super.key});

  /// The theme data carried by this ancestor.
  final LiqThemeData data;

  /// Returns the nearest [LiqThemeData] above [context]. Throws an
  /// assertion error if none is found.
  static LiqThemeData of(BuildContext context) {
    final theme = maybeOf(context);
    assert(
      theme != null,
      'No LiqTheme ancestor found. Wrap your app with LiqApp or '
      'place a LiqTheme above any liqkit_ui widget.',
    );
    return theme!;
  }

  /// Returns the nearest [LiqThemeData] above [context], or null.
  static LiqThemeData? maybeOf(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<LiqTheme>();
    return inherited?.data;
  }

  @override
  bool updateShouldNotify(LiqTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      LiqTheme(data: data, child: child);
}
