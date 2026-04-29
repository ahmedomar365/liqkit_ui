import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Preferred edge of [LiqTooltip] relative to its child.
enum LiqTooltipPlacement {
  /// Tooltip above the child.
  top,

  /// Tooltip below the child.
  bottom,

  /// Tooltip to the left of the child.
  left,

  /// Tooltip to the right of the child.
  right,
}

/// iOS 26 contextual tooltip.
///
/// Appears on long-press (touch) or hover (mouse) over [child] and
/// automatically dismisses on release / pointer leave. The tooltip is
/// rendered in the nearest [Overlay] via an [OverlayPortal] so it
/// floats above all other content.
///
/// Smaller and lighter than `LiqPopover`: meant for short hints, not
/// full content panels. The tooltip auto-flips to the opposite edge
/// if rendering at [placement] would overflow the screen.
final class LiqTooltip extends StatefulWidget {
  /// Creates a tooltip wrapping [child].
  const LiqTooltip({
    required this.message,
    required this.child,
    this.placement = LiqTooltipPlacement.top,
    this.showArrow = true,
    super.key,
  });

  /// Tooltip body text.
  final String message;

  /// The widget the tooltip describes.
  final Widget child;

  /// Preferred edge — actual placement may flip if it would overflow.
  final LiqTooltipPlacement placement;

  /// Whether to draw the small triangle pointing toward the target.
  final bool showArrow;

  /// Tooltip background color (iOS 26 dark glass at 90% alpha).
  static const Color backgroundColor = Color(0xE61C1C1E);

  /// Tooltip text color.
  static const Color textColor = Color(0xFFFFFFFF);

  /// Horizontal padding inside the tooltip body.
  static const double paddingHorizontal = 10;

  /// Vertical padding inside the tooltip body.
  static const double paddingVertical = 6;

  /// Tooltip corner radius.
  static const double radius = 8;

  /// Width of the arrow (long axis).
  static const double arrowWidth = 8;

  /// Height of the arrow (short axis pointing toward the target).
  static const double arrowHeight = 5;

  /// Gap between target and tooltip.
  static const double gap = 8;

  /// Tooltip text size.
  static const double fontSize = 13;

  /// Maximum tooltip width before text wraps.
  static const double maxWidth = 240;

  /// Show/hide animation duration.
  static const Duration animationDuration = Duration(milliseconds: 160);

  /// Show/hide animation curve.
  static const Curve animationCurve = Curves.easeOut;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('messageLength', message.length))
      ..add(EnumProperty<LiqTooltipPlacement>('placement', placement))
      ..add(FlagProperty('showArrow', value: showArrow, ifTrue: 'arrow'));
  }

  @override
  State<LiqTooltip> createState() => _LiqTooltipState();
}

class _LiqTooltipState extends State<LiqTooltip>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _link = LayerLink();
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: LiqTooltip.animationDuration,
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _show() {
    if (!_portalController.isShowing) {
      _portalController.show();
    }
    _animation.forward();
  }

  void _hide() {
    _animation.reverse().then((_) {
      if (!mounted) return;
      if (_animation.value == 0 && _portalController.isShowing) {
        _portalController.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: MouseRegion(
        onEnter: (_) => _show(),
        onExit: (_) => _hide(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: _show,
          onLongPressEnd: (_) => _hide(),
          onLongPressCancel: _hide,
          child: OverlayPortal(
            controller: _portalController,
            overlayChildBuilder: (BuildContext overlayContext) {
              return _LiqTooltipOverlay(
                link: _link,
                animation: _animation,
                message: widget.message,
                placement: widget.placement,
                showArrow: widget.showArrow,
                targetContext: context,
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _LiqTooltipOverlay extends StatelessWidget {
  const _LiqTooltipOverlay({
    required this.link,
    required this.animation,
    required this.message,
    required this.placement,
    required this.showArrow,
    required this.targetContext,
  });

  final LayerLink link;
  final Animation<double> animation;
  final String message;
  final LiqTooltipPlacement placement;
  final bool showArrow;
  final BuildContext targetContext;

  @override
  Widget build(BuildContext context) {
    final renderBox = targetContext.findRenderObject() as RenderBox?;
    final mediaSize = MediaQuery.maybeOf(context)?.size ?? Size.zero;
    final resolved = _resolvePlacement(renderBox, mediaSize);

    final offset = _offsetForPlacement(resolved);
    final followerAnchor = _followerAnchorForPlacement(resolved);
    final targetAnchor = _targetAnchorForPlacement(resolved);

    final fade = CurvedAnimation(
      parent: animation,
      curve: LiqTooltip.animationCurve,
      reverseCurve: LiqTooltip.animationCurve,
    );
    final scale = Tween<double>(begin: 0.95, end: 1).animate(fade);

    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        offset: offset,
        followerAnchor: followerAnchor,
        targetAnchor: targetAnchor,
        child: FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            alignment: _scaleAlignmentForPlacement(resolved),
            child: _LiqTooltipBody(
              message: message,
              placement: resolved,
              showArrow: showArrow,
            ),
          ),
        ),
      ),
    );
  }

  /// Pick a placement that fits within [mediaSize]; flip to the
  /// opposite edge if the preferred one would overflow.
  LiqTooltipPlacement _resolvePlacement(RenderBox? box, Size mediaSize) {
    if (box == null || !box.hasSize || mediaSize.isEmpty) return placement;
    final topLeft = box.localToGlobal(Offset.zero);
    final size = box.size;
    // Approximate tooltip extent; text width is unknown at this point so
    // use the configured max width and a conservative single-line height.
    const tooltipW = LiqTooltip.maxWidth;
    const tooltipH = 40.0;
    final arrow = showArrow ? LiqTooltip.arrowHeight : 0.0;
    switch (placement) {
      case LiqTooltipPlacement.top:
        if (topLeft.dy - LiqTooltip.gap - arrow - tooltipH < 0) {
          return LiqTooltipPlacement.bottom;
        }
        return placement;
      case LiqTooltipPlacement.bottom:
        if (topLeft.dy + size.height + LiqTooltip.gap + arrow + tooltipH >
            mediaSize.height) {
          return LiqTooltipPlacement.top;
        }
        return placement;
      case LiqTooltipPlacement.left:
        if (topLeft.dx - LiqTooltip.gap - arrow - tooltipW < 0) {
          return LiqTooltipPlacement.right;
        }
        return placement;
      case LiqTooltipPlacement.right:
        if (topLeft.dx + size.width + LiqTooltip.gap + arrow + tooltipW >
            mediaSize.width) {
          return LiqTooltipPlacement.left;
        }
        return placement;
    }
  }

  Offset _offsetForPlacement(LiqTooltipPlacement p) {
    final arrow = showArrow ? LiqTooltip.arrowHeight : 0.0;
    final extra = LiqTooltip.gap + arrow;
    switch (p) {
      case LiqTooltipPlacement.top:
        return Offset(0, -extra);
      case LiqTooltipPlacement.bottom:
        return Offset(0, extra);
      case LiqTooltipPlacement.left:
        return Offset(-extra, 0);
      case LiqTooltipPlacement.right:
        return Offset(extra, 0);
    }
  }

  Alignment _followerAnchorForPlacement(LiqTooltipPlacement p) {
    switch (p) {
      case LiqTooltipPlacement.top:
        return Alignment.bottomCenter;
      case LiqTooltipPlacement.bottom:
        return Alignment.topCenter;
      case LiqTooltipPlacement.left:
        return Alignment.centerRight;
      case LiqTooltipPlacement.right:
        return Alignment.centerLeft;
    }
  }

  Alignment _targetAnchorForPlacement(LiqTooltipPlacement p) {
    switch (p) {
      case LiqTooltipPlacement.top:
        return Alignment.topCenter;
      case LiqTooltipPlacement.bottom:
        return Alignment.bottomCenter;
      case LiqTooltipPlacement.left:
        return Alignment.centerLeft;
      case LiqTooltipPlacement.right:
        return Alignment.centerRight;
    }
  }

  Alignment _scaleAlignmentForPlacement(LiqTooltipPlacement p) {
    switch (p) {
      case LiqTooltipPlacement.top:
        return Alignment.bottomCenter;
      case LiqTooltipPlacement.bottom:
        return Alignment.topCenter;
      case LiqTooltipPlacement.left:
        return Alignment.centerRight;
      case LiqTooltipPlacement.right:
        return Alignment.centerLeft;
    }
  }
}

class _LiqTooltipBody extends StatelessWidget {
  const _LiqTooltipBody({
    required this.message,
    required this.placement,
    required this.showArrow,
  });

  final String message;
  final LiqTooltipPlacement placement;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: LiqTooltip.maxWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: LiqTooltip.paddingHorizontal,
        vertical: LiqTooltip.paddingVertical,
      ),
      decoration: const BoxDecoration(
        color: LiqTooltip.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(LiqTooltip.radius)),
      ),
      child: Text(
        message,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontFamily: 'SF Pro Text',
          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
          fontSize: LiqTooltip.fontSize,
          fontWeight: FontWeight.w400,
          color: LiqTooltip.textColor,
          height: 1.25,
        ),
      ),
    );

    if (!showArrow) {
      return bubble;
    }

    final isVertical =
        placement == LiqTooltipPlacement.top ||
        placement == LiqTooltipPlacement.bottom;
    final arrow = SizedBox(
      width: isVertical ? LiqTooltip.arrowWidth : LiqTooltip.arrowHeight,
      height: isVertical ? LiqTooltip.arrowHeight : LiqTooltip.arrowWidth,
      child: CustomPaint(
        painter: _LiqTooltipArrowPainter(
          color: LiqTooltip.backgroundColor,
          placement: placement,
        ),
      ),
    );

    switch (placement) {
      case LiqTooltipPlacement.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[bubble, arrow],
        );
      case LiqTooltipPlacement.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[arrow, bubble],
        );
      case LiqTooltipPlacement.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[bubble, arrow],
        );
      case LiqTooltipPlacement.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[arrow, bubble],
        );
    }
  }
}

class _LiqTooltipArrowPainter extends CustomPainter {
  _LiqTooltipArrowPainter({required this.color, required this.placement});

  final Color color;
  final LiqTooltipPlacement placement;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path = Path();
    switch (placement) {
      case LiqTooltipPlacement.top:
        // Arrow sits below the bubble, points down toward target.
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case LiqTooltipPlacement.bottom:
        // Arrow sits above the bubble, points up toward target.
        path
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width / 2, 0)
          ..close();
      case LiqTooltipPlacement.left:
        // Arrow sits to the right of the bubble, points right.
        path
          ..moveTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height / 2)
          ..close();
      case LiqTooltipPlacement.right:
        // Arrow sits to the left of the bubble, points left.
        path
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height / 2)
          ..close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiqTooltipArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.placement != placement;
}
