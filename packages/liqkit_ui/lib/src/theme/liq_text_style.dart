import 'dart:ui' show FontWeight;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show TextStyle;

/// Liqkit text-style spec. Resolves to a Flutter [TextStyle] via
/// [toTextStyle].
@immutable
final class LiqTextStyle with Diagnosticable {
  /// Creates a text-style spec.
  const LiqTextStyle({
    required this.family,
    required this.fontSize,
    required this.fontWeight,
    required this.letterSpacing,
    required this.heightMultiplier,
  });

  /// Font family name.
  final String family;

  /// Font size in logical pixels.
  final double fontSize;

  /// Font weight.
  final FontWeight fontWeight;

  /// Tracking in logical pixels.
  final double letterSpacing;

  /// Line-height multiplier.
  final double heightMultiplier;

  /// Returns a copy with selected fields replaced.
  LiqTextStyle copyWith({
    String? family,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? heightMultiplier,
  }) => LiqTextStyle(
    family: family ?? this.family,
    fontSize: fontSize ?? this.fontSize,
    fontWeight: fontWeight ?? this.fontWeight,
    letterSpacing: letterSpacing ?? this.letterSpacing,
    heightMultiplier: heightMultiplier ?? this.heightMultiplier,
  );

  /// Resolves to a Flutter [TextStyle].
  TextStyle toTextStyle() => TextStyle(
    fontFamily: family,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: heightMultiplier,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiqTextStyle &&
          other.family == family &&
          other.fontSize == fontSize &&
          other.fontWeight == fontWeight &&
          other.letterSpacing == letterSpacing &&
          other.heightMultiplier == heightMultiplier;

  @override
  int get hashCode => Object.hash(
    family,
    fontSize,
    fontWeight,
    letterSpacing,
    heightMultiplier,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('family', family))
      ..add(DoubleProperty('fontSize', fontSize))
      ..add(DiagnosticsProperty<FontWeight>('fontWeight', fontWeight))
      ..add(DoubleProperty('letterSpacing', letterSpacing))
      ..add(DoubleProperty('heightMultiplier', heightMultiplier));
  }
}
