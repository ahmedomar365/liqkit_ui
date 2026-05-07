// Color utility extensions: hex parsing, lighten/darken, luminance helpers.
//
// Lifted from common color-manipulation patterns; kept dependency-free
// so the extension activates on any `Color` without further imports.

import 'package:flutter/painting.dart' show Color, HSLColor;

/// Color manipulation extensions.
///
/// All methods are pure / non-mutating — they return new [Color] values.
extension LiqColorUtils on Color {
  /// Parses a hex string (e.g. `#FF0088FF`, `0088FF`, `0xFF0088FF`) into
  /// a [Color]. Adds full alpha if a 6-digit color is supplied.
  static Color fromHex(String hexString) {
    var s = hexString.trim();
    if (s.startsWith('#')) s = s.substring(1);
    if (s.startsWith('0x') || s.startsWith('0X')) s = s.substring(2);
    if (s.length == 6) s = 'FF$s';
    return Color(int.parse(s, radix: 16));
  }

  /// `#aarrggbb` (or `aarrggbb` if [leadingHashSign] is false).
  String toHex({bool leadingHashSign = true}) {
    String byte(double v) =>
        ((v * 255.0).round() & 0xFF).toRadixString(16).padLeft(2, '0');
    return '${leadingHashSign ? '#' : ''}'
        '${byte(a)}${byte(r)}${byte(g)}${byte(b)}';
  }

  /// Lighten this color in HSL space by [amount] (0..1).
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be 0..1');
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken this color in HSL space by [amount] (0..1).
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be 0..1');
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// True if luminance < 0.5.
  bool get isDark => computeLuminance() < 0.5;

  /// True if luminance >= 0.5.
  bool get isLight => !isDark;

  /// White if [isDark], black otherwise.
  Color get contrastingColor =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  /// Linearly interpolate toward [other] by [amount] (0..1).
  Color mix(Color other, [double amount = 0.5]) {
    assert(amount >= 0 && amount <= 1, 'amount must be 0..1');
    return Color.lerp(this, other, amount)!;
  }

  /// Returns a copy with [opacity] (0..1) on the alpha channel.
  Color opacity(double opacity) {
    assert(opacity >= 0 && opacity <= 1, 'opacity must be 0..1');
    return withValues(alpha: opacity);
  }
}
