import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:liqkit_ui/src/theme/liq_color.dart';

/// A const-constructible glass material spec.
///
/// `vibrancy` MUST be a length-20 list (4x5 row-major matrix). This is
/// asserted at runtime by [debugAssertVibrancy], not at construction
/// time, because Dart does not allow `.length` access on a `List` in a
/// const constructor's assert expression. Call [debugAssertVibrancy]
/// in tests for the predefined variants.
@immutable
final class LiqMaterial with Diagnosticable {
  /// Creates a material spec.
  const LiqMaterial({
    required this.blurRadius,
    required this.tint,
    required this.vibrancy,
  }) : assert(
          blurRadius >= 0 && blurRadius <= 18,
          'LiqMaterial.blurRadius must be in [0, 18]',
        );

  /// Runtime check for the 4x5-matrix invariant.
  bool debugAssertVibrancy() {
    assert(
      vibrancy.length == 20,
      'LiqMaterial.vibrancy must be a 4x5 row-major matrix (length 20)',
    );
    return true;
  }

  /// Blur sigma in logical pixels.
  final double blurRadius;

  /// Tint overlay color (light/dark pair).
  final LiqColor tint;

  /// Color vibrancy matrix (length 20, 4x5 row-major).
  final List<double> vibrancy;

  /// Identity vibrancy matrix (no shift).
  static const List<double> identityVibrancy = <double>[
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  /// Standard regular-thickness glass.
  static const LiqMaterial regular = LiqMaterial(
    blurRadius: 12,
    tint: LiqColor(light: Color(0x33FFFFFF), dark: Color(0x33000000)),
    vibrancy: identityVibrancy,
  );

  /// Ultra-thin glass.
  static const LiqMaterial ultraThin = LiqMaterial(
    blurRadius: 6,
    tint: LiqColor(light: Color(0x14FFFFFF), dark: Color(0x14000000)),
    vibrancy: identityVibrancy,
  );

  /// Thin glass.
  static const LiqMaterial thin = LiqMaterial(
    blurRadius: 8,
    tint: LiqColor(light: Color(0x22FFFFFF), dark: Color(0x22000000)),
    vibrancy: identityVibrancy,
  );

  /// Thick glass.
  static const LiqMaterial thick = LiqMaterial(
    blurRadius: 16,
    tint: LiqColor(light: Color(0x55FFFFFF), dark: Color(0x55000000)),
    vibrancy: identityVibrancy,
  );

  /// Chrome / toolbar glass.
  static const LiqMaterial chrome = LiqMaterial(
    blurRadius: 14,
    tint: LiqColor(light: Color(0x44FFFFFF), dark: Color(0x44000000)),
    vibrancy: identityVibrancy,
  );

  /// Opaque fallback for `LiqQuality.minimal` paths.
  static const LiqMaterial solid = LiqMaterial(
    blurRadius: 0,
    tint: LiqColor(light: Color(0xFFFFFFFF), dark: Color(0xFF1C1C1E)),
    vibrancy: identityVibrancy,
  );

  /// Returns a copy with selected fields replaced.
  LiqMaterial copyWith({
    double? blurRadius,
    LiqColor? tint,
    List<double>? vibrancy,
  }) =>
      LiqMaterial(
        blurRadius: blurRadius ?? this.blurRadius,
        tint: tint ?? this.tint,
        vibrancy: vibrancy ?? this.vibrancy,
      );

  /// Linear interpolation; vibrancy interpolates element-wise.
  // ignore: prefer_constructors_over_static_methods
  static LiqMaterial lerp(LiqMaterial a, LiqMaterial b, double t) {
    final lerpedVibrancy = <double>[
      for (var i = 0; i < 20; i++)
        a.vibrancy[i] + (b.vibrancy[i] - a.vibrancy[i]) * t,
    ];
    return LiqMaterial(
      blurRadius: a.blurRadius + (b.blurRadius - a.blurRadius) * t,
      tint: LiqColor.lerp(a.tint, b.tint, t),
      vibrancy: lerpedVibrancy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiqMaterial &&
          other.blurRadius == blurRadius &&
          other.tint == tint &&
          listEquals(other.vibrancy, vibrancy);

  @override
  int get hashCode => Object.hash(blurRadius, tint, Object.hashAll(vibrancy));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('blurRadius', blurRadius))
      ..add(DiagnosticsProperty<LiqColor>('tint', tint))
      ..add(IterableProperty<double>('vibrancy', vibrancy));
  }
}
