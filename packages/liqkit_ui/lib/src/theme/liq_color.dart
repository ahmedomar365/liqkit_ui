import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

/// A light/dark color pair.
@immutable
final class LiqColor with Diagnosticable {
  /// Creates a const light/dark color pair.
  const LiqColor({required this.light, required this.dark});

  /// Color used in light mode.
  final Color light;

  /// Color used in dark mode.
  final Color dark;

  /// Picks the color for [brightness].
  Color resolve(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// Returns a copy with the given fields replaced.
  LiqColor copyWith({Color? light, Color? dark}) =>
      LiqColor(light: light ?? this.light, dark: dark ?? this.dark);

  /// Linearly interpolates between two pairs at [t].
  // ignore: prefer_constructors_over_static_methods
  static LiqColor lerp(LiqColor a, LiqColor b, double t) => LiqColor(
        light: Color.lerp(a.light, b.light, t) ?? a.light,
        dark: Color.lerp(a.dark, b.dark, t) ?? a.dark,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiqColor && other.light == light && other.dark == dark;

  @override
  int get hashCode => Object.hash(light, dark);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Color>('light', light))
      ..add(DiagnosticsProperty<Color>('dark', dark));
  }
}
