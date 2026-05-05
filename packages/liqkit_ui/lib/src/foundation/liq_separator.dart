import 'package:flutter/widgets.dart';

/// Shared iOS separator and hairline colors.
///
/// Keep separator colors centralized so dark-mode previews, cards, lists,
/// pickers, and documentation examples do not drift into near-invisible
/// per-component values.
abstract final class LiqSeparator {
  /// Standard iOS hairline on light surfaces.
  static const Color light = Color(0x29000000);

  /// Standard iOS hairline on dark surfaces.
  static const Color dark = Color(0x3DFFFFFF);

  /// Softer border on light grouped surfaces.
  static const Color lightBorder = Color(0x1F000000);

  /// Softer border on dark grouped surfaces.
  static const Color darkBorder = dark;
}
