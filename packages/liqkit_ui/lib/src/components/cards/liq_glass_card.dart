import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Interactive iOS 26 glass card.
///
/// A press-responsive surface that wraps [LiqGlassSurface] with optional
/// tap / long-press / haptic feedback. Sister to `LiqCard`, which uses a
/// solid backing instead of glass.
///
/// Use this when you want a *tappable* glass tile (a payment card, a
/// home-screen widget, a dashboard cell). For a non-tappable glass
/// surface, use [LiqGlassSurface] directly. For a solid card with
/// header/footer slots, use `LiqCard`.
final class LiqGlassCard extends StatefulWidget {
  /// Creates a glass card.
  const LiqGlassCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.tint = LiqGlassTint.light,
    this.elevation = LiqGlassElevation.flat,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.enableHaptics = true,
    this.pressedScale = 0.98,
    this.pressedOpacity = 0.92,
    super.key,
  });

  /// Content rendered inside the card.
  final Widget child;

  /// Tap callback. When `null`, the card renders inert.
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// Glass tint preset (light / dark / opaque).
  final LiqGlassTint tint;

  /// Glass elevation preset (flat / floating / sheet).
  final LiqGlassElevation elevation;

  /// Outer corner radius. Defaults to a 22pt rounded rectangle (iOS 26
  /// home-screen widget radius).
  final BorderRadius? borderRadius;

  /// Padding applied around [child].
  final EdgeInsets padding;

  /// Whether to fire `HapticFeedback.lightImpact()` on press.
  final bool enableHaptics;

  /// Scale factor while pressed. Defaults to 0.98.
  final double pressedScale;

  /// Opacity factor while pressed. Defaults to 0.92.
  final double pressedOpacity;

  @override
  State<LiqGlassCard> createState() => _LiqGlassCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqGlassTint>('tint', tint))
      ..add(EnumProperty<LiqGlassElevation>('elevation', elevation))
      ..add(
        FlagProperty(
          'enabled',
          value: onTap != null || onLongPress != null,
          ifTrue: 'enabled',
          ifFalse: 'inert',
        ),
      )
      ..add(
        FlagProperty(
          'enableHaptics',
          value: enableHaptics,
          ifTrue: 'haptics',
        ),
      );
  }
}

class _LiqGlassCardState extends State<LiqGlassCard> {
  bool _pressed = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  void _setPressed(bool v) {
    if (!_enabled || _pressed == v) return;
    setState(() => _pressed = v);
    if (v && widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius =
        widget.borderRadius ?? const BorderRadius.all(Radius.circular(22));
    final motionDuration = context.liqMotionDuration(LiqMotion.fast);

    final glass = LiqGlassSurface(
      tint: widget.tint,
      elevation: widget.elevation,
      borderRadius: radius,
      padding: widget.padding,
      child: widget.child,
    );

    if (!_enabled) return glass;

    return LiqPointerCursor(
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: AnimatedScale(
            scale: _pressed ? widget.pressedScale : 1,
            duration: motionDuration,
            curve: LiqMotion.snappy,
            child: AnimatedOpacity(
              opacity: _pressed ? widget.pressedOpacity : 1,
              duration: motionDuration,
              curve: LiqMotion.snappy,
              child: glass,
            ),
          ),
        ),
      ),
    );
  }
}
