import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Slow flowing background that animates a multi-color gradient
/// across [child] in a continuous loop. Useful as an iOS 26 lock-
/// screen-style backdrop or hero card.
final class LiqFlowAnimation extends StatefulWidget with Diagnosticable {
  /// Creates a flow animation.
  const LiqFlowAnimation({
    required this.child,
    required this.gradientColors,
    this.duration = const Duration(seconds: 8),
    this.flowIntensity = 0.7,
    super.key,
  });

  final Widget child;
  final List<Color> gradientColors;
  final Duration duration;
  final double flowIntensity;

  @override
  State<LiqFlowAnimation> createState() => _LiqFlowAnimationState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('colorCount', gradientColors.length))
      ..add(DoubleProperty('flowIntensity', flowIntensity));
  }
}

class _LiqFlowAnimationState extends State<LiqFlowAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final intensity = widget.flowIntensity;
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      -1 + 2 * t * intensity,
                      -1,
                    ),
                    end: Alignment(
                      1,
                      1 - 2 * t * intensity,
                    ),
                    colors: widget.gradientColors,
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}

/// Cross-fades + scale-morphs between two widgets. Use to switch
/// between an icon, an avatar, etc. on a state change.
final class LiqMorphTransition extends StatelessWidget with Diagnosticable {
  /// Creates a morph transition.
  const LiqMorphTransition({
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    this.duration = const Duration(milliseconds: 320),
    super.key,
  });

  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final scale = Tween<double>(begin: 0.85, end: 1).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<bool>(showFirst),
        child: showFirst ? firstChild : secondChild,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('showFirst', value: showFirst, ifTrue: 'first'));
  }
}

/// Tappable wrapper that paints an expanding ripple from the tap
/// point on top of [child]. Pure Flutter (no Material).
final class LiqRipple extends StatefulWidget with Diagnosticable {
  /// Creates a ripple.
  const LiqRipple({
    required this.child,
    this.rippleColor,
    this.duration = const Duration(milliseconds: 600),
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? rippleColor;
  final Duration duration;
  final VoidCallback? onTap;

  @override
  State<LiqRipple> createState() => _LiqRippleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('rippleColor', rippleColor));
  }
}

class _LiqRippleState extends State<LiqRipple>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  Offset? _origin;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _origin = details.localPosition);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: _RipplePainter(
              origin: _origin,
              progress: _controller.value,
              color: (widget.rippleColor ?? const Color(0xFF007AFF))
                  .withValues(alpha: 0.25 * (1 - _controller.value)),
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.origin,
    required this.progress,
    required this.color,
  });

  final Offset? origin;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (origin == null || progress == 0) return;
    final maxRadius = size.longestSide;
    final r = maxRadius * progress;
    canvas.drawCircle(origin!, r, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) =>
      old.progress != progress ||
      old.origin != origin ||
      old.color != color;
}

/// Translates [child] up-and-down a few times then settles.
final class LiqBounce extends StatefulWidget with Diagnosticable {
  /// Creates a bounce.
  const LiqBounce({
    required this.child,
    this.bounceHeight = 24,
    this.repeatCount = 1,
    this.duration = const Duration(milliseconds: 600),
    super.key,
  });

  final Widget child;
  final double bounceHeight;
  final int repeatCount;
  final Duration duration;

  @override
  State<LiqBounce> createState() => _LiqBounceState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('bounceHeight', bounceHeight))
      ..add(IntProperty('repeatCount', repeatCount));
  }
}

class _LiqBounceState extends State<LiqBounce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true, period: widget.duration);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, -widget.bounceHeight * t),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Loops a scale-pulse on [child] between [minScale] and [maxScale].
final class LiqPulse extends StatefulWidget with Diagnosticable {
  /// Creates a pulse.
  const LiqPulse({
    required this.child,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.duration = const Duration(milliseconds: 800),
    super.key,
  });

  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  @override
  State<LiqPulse> createState() => _LiqPulseState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('minScale', minScale))
      ..add(DoubleProperty('maxScale', maxScale));
  }
}

class _LiqPulseState extends State<LiqPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        final scale =
            widget.minScale + (widget.maxScale - widget.minScale) * t;
        return Transform.scale(scale: scale, child: child);
      },
      child: widget.child,
    );
  }
}

/// Diagonal-sweep shimmer overlay. Toggle [enabled] to start/stop.
final class LiqShimmer extends StatefulWidget with Diagnosticable {
  /// Creates a shimmer overlay.
  const LiqShimmer({
    required this.child,
    this.enabled = true,
    this.baseColor = const Color(0x1A000000),
    this.highlightColor = const Color(0x66FFFFFF),
    this.duration = const Duration(milliseconds: 1400),
    super.key,
  });

  final Widget child;
  final bool enabled;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<LiqShimmer> createState() => _LiqShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifTrue: 'on'));
  }
}

class _LiqShimmerState extends State<LiqShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(LiqShimmer old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            final t = _controller.value;
            final dx = rect.width * (2 * t - 1);
            return LinearGradient(
              begin: Alignment(-1 + 2 * t, -0.4),
              end: Alignment(1 + 2 * t, 0.4),
              colors: <Color>[
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const <double>[0.35, 0.5, 0.65],
              tileMode: TileMode.clamp,
            ).createShader(Rect.fromLTWH(dx, 0, rect.width, rect.height));
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Detects 4-direction swipes on [child] and dispatches the
/// matching callback once the gesture velocity exceeds the threshold.
final class LiqSwipeDetector extends StatelessWidget with Diagnosticable {
  /// Creates a swipe detector.
  const LiqSwipeDetector({
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.velocityThreshold = 300,
    super.key,
  });

  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double velocityThreshold;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v > velocityThreshold) onSwipeRight?.call();
        if (v < -velocityThreshold) onSwipeLeft?.call();
      },
      onVerticalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v > velocityThreshold) onSwipeDown?.call();
        if (v < -velocityThreshold) onSwipeUp?.call();
      },
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('threshold', velocityThreshold));
  }
}

/// Wraps [child] with a pinch-to-zoom recognizer. Reports the
/// running scale factor via [onScaleUpdate]. Caller decides how to
/// apply it.
final class LiqPinchDetector extends StatelessWidget with Diagnosticable {
  /// Creates a pinch detector.
  const LiqPinchDetector({
    required this.child,
    required this.onScaleUpdate,
    super.key,
  });

  final Widget child;
  final ValueChanged<double> onScaleUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleUpdate: (details) => onScaleUpdate(details.scale),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'onScaleUpdate', onScaleUpdate));
  }
}

/// Long-press wrapper with optional ripple on activation.
final class LiqLongPress extends StatefulWidget with Diagnosticable {
  /// Creates a long-press detector.
  const LiqLongPress({
    required this.child,
    required this.onLongPress,
    this.rippleColor,
    super.key,
  });

  final Widget child;
  final VoidCallback onLongPress;
  final Color? rippleColor;

  @override
  State<LiqLongPress> createState() => _LiqLongPressState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('rippleColor', rippleColor));
  }
}

class _LiqLongPressState extends State<LiqLongPress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  Offset? _pressOrigin;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onPressStart(LongPressStartDetails details) {
    setState(() => _pressOrigin = details.localPosition);
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: _onPressStart,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: _RipplePainter(
              origin: _pressOrigin,
              progress: _ctrl.value,
              color: (widget.rippleColor ?? const Color(0xFF007AFF))
                  .withValues(alpha: 0.25 * (1 - _ctrl.value)),
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
