import 'package:flutter/widgets.dart' show Brightness;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod state holder for the showcase's app-wide brightness.
///
/// All actual theming (glass material, color tokens, typography) is
/// supplied by `LiqTheme(data: …)` at the app root. This provider
/// only exists so demo screens can flip light/dark from anywhere via
/// `ref.read(liquidThemeProvider.notifier).toggleTheme()`.
final liquidThemeProvider =
    StateNotifierProvider<LiquidThemeNotifier, LiquidThemeData>(
  (ref) => LiquidThemeNotifier(),
);

/// Notifier exposing [toggleTheme] for the brightness toggle UI.
class LiquidThemeNotifier extends StateNotifier<LiquidThemeData> {
  LiquidThemeNotifier() : super(const LiquidThemeData(Brightness.light));

  void toggleTheme() {
    state = LiquidThemeData(
      state.brightness == Brightness.light ? Brightness.dark : Brightness.light,
    );
  }
}

/// State held by [liquidThemeProvider] — currently just the active
/// [Brightness]. Kept as a class (rather than exposing `Brightness`
/// directly) so future per-app preferences (haptics, blur intensity,
/// etc.) can be added without churning every consumer.
class LiquidThemeData {
  const LiquidThemeData(this.brightness);

  final Brightness brightness;
}
