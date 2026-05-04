import 'package:flutter/widgets.dart';

/// Applies the platform click cursor to custom interactive regions.
///
/// Flutter's built-in buttons already do this, but liqkit_ui intentionally
/// implements many iOS-shaped controls with custom render trees. Keep cursor
/// behavior centralized so web, desktop, and iPad pointer users get consistent
/// affordances without every component hand-rolling [MouseRegion].
final class LiqPointerCursor extends StatelessWidget {
  /// Creates an interactive cursor wrapper.
  const LiqPointerCursor({
    required this.child,
    this.enabled = true,
    this.cursor = SystemMouseCursors.click,
    super.key,
  });

  /// Whether the wrapped region is interactive.
  final bool enabled;

  /// Cursor to show while enabled.
  final MouseCursor cursor;

  /// Wrapped visual/control.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: enabled ? cursor : SystemMouseCursors.basic,
      child: child,
    );
  }
}
