import 'package:flutter/foundation.dart';

/// Bezel spec - corner radius and edge-highlight intensities.
@immutable
final class LiqBezel with Diagnosticable {
  /// Creates a bezel spec.
  const LiqBezel({
    required this.cornerRadius,
    required this.innerHighlight,
    required this.outerShadowOpacity,
  });

  /// Outer corner radius in logical pixels.
  final double cornerRadius;

  /// Inner highlight opacity (0..1).
  final double innerHighlight;

  /// Outer drop-shadow opacity (0..1).
  final double outerShadowOpacity;

  /// Returns a copy with selected fields replaced.
  LiqBezel copyWith({
    double? cornerRadius,
    double? innerHighlight,
    double? outerShadowOpacity,
  }) => LiqBezel(
    cornerRadius: cornerRadius ?? this.cornerRadius,
    innerHighlight: innerHighlight ?? this.innerHighlight,
    outerShadowOpacity: outerShadowOpacity ?? this.outerShadowOpacity,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiqBezel &&
          other.cornerRadius == cornerRadius &&
          other.innerHighlight == innerHighlight &&
          other.outerShadowOpacity == outerShadowOpacity;

  @override
  int get hashCode =>
      Object.hash(cornerRadius, innerHighlight, outerShadowOpacity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('cornerRadius', cornerRadius))
      ..add(DoubleProperty('innerHighlight', innerHighlight))
      ..add(DoubleProperty('outerShadowOpacity', outerShadowOpacity));
  }
}
