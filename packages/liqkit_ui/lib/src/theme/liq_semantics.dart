import 'package:flutter/foundation.dart';

/// Tunable semantic flags carried on the theme.
@immutable
final class LiqSemantics with Diagnosticable {
  /// Creates a semantics spec.
  const LiqSemantics({
    this.respectReduceMotion = true,
    this.respectAccessibleNavigation = true,
  });

  /// When true, animation duration scales by `MediaQuery.disableAnimations`.
  final bool respectReduceMotion;

  /// When true, focus rings and tap targets follow accessible-navigation hints.
  final bool respectAccessibleNavigation;

  /// Returns a copy with selected fields replaced.
  LiqSemantics copyWith({
    bool? respectReduceMotion,
    bool? respectAccessibleNavigation,
  }) =>
      LiqSemantics(
        respectReduceMotion: respectReduceMotion ?? this.respectReduceMotion,
        respectAccessibleNavigation:
            respectAccessibleNavigation ?? this.respectAccessibleNavigation,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiqSemantics &&
          other.respectReduceMotion == respectReduceMotion &&
          other.respectAccessibleNavigation == respectAccessibleNavigation;

  @override
  int get hashCode => Object.hash(
        respectReduceMotion,
        respectAccessibleNavigation,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        FlagProperty(
          'respectReduceMotion',
          value: respectReduceMotion,
          ifTrue: 'respects reduce-motion',
        ),
      )
      ..add(
        FlagProperty(
          'respectAccessibleNavigation',
          value: respectAccessibleNavigation,
          ifTrue: 'respects accessible-nav',
        ),
      );
  }
}
