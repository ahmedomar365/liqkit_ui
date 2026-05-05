import 'package:flutter/animation.dart';

/// iOS 26 motion presets — curves and durations used by every
/// liqkit_ui component for transitions, gestures, and feedback.
///
/// The curves below are the current Flutter implementation of the motion
/// model. The namespace keeps component call sites centralized so the exact
/// spring tuning can be improved in one file as the platform APIs evolve.
///
/// Spring targets for the future upgrade:
/// * [standard] — `UISpringTimingParameters(stiffness: 180, damping: 22)`
/// * [snappy]   — `UISpringTimingParameters(stiffness: 280, damping: 26)`
/// * [smooth]   — `UISpringTimingParameters(stiffness: 120, damping: 18)`
final class LiqMotion {
  // No instances; this is a namespace for static constants.
  LiqMotion._();

  /// iOS 26 standard interpolating spring (medium response, medium
  /// damping). Used for sheet presentation, dialog scale-in, and most
  /// other surface transitions.
  static const Curve standard = Curves.easeOutCubic;

  /// Snappier spring for taps and transient feedback (toast, tooltip).
  static const Curve snappy = Curves.easeOutQuint;

  /// Slower / more bouncy curve for playful affordances (avatar tap,
  /// reorder lift, etc.).
  static const Curve smooth = Curves.easeInOutCubic;

  /// Fast transition duration — micro-interactions (dim on press,
  /// hover state changes).
  static const Duration fast = Duration(milliseconds: 200);

  /// Standard transition duration — most surface transitions.
  static const Duration normal = Duration(milliseconds: 280);

  /// Slow transition duration — sheets, drawers, large modal moves.
  static const Duration slow = Duration(milliseconds: 380);
}
