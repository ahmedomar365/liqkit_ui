import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Preferred edge of [LiqHoverCard] relative to its child.
enum LiqHoverCardPlacement {
  /// Hover card above the child.
  top,

  /// Hover card below the child.
  bottom,

  /// Hover card to the left of the child.
  left,

  /// Hover card to the right of the child.
  right,
}

/// iOS 26 rich-content hover popover.
///
/// Opens after [openDelay] of hovering over [child]; closes after
/// [closeDelay] of the pointer leaving both [child] and the popover
/// surface (so the user can move into the popover without it
/// disappearing). Common pattern: hover a username to see a preview
/// of the user's profile.
///
/// The popover is rendered in the nearest [Overlay] via an
/// [OverlayPortal] so it floats above all other content. Hover-only
/// trigger — touch devices do not open the card. The popover
/// auto-flips to the opposite edge if rendering at [placement] would
/// overflow the viewport.
final class LiqHoverCard extends StatefulWidget {
  /// Creates a hover card wrapping [child].
  const LiqHoverCard({
    required this.content,
    required this.child,
    this.placement = LiqHoverCardPlacement.top,
    this.openDelay = const Duration(milliseconds: 400),
    this.closeDelay = const Duration(milliseconds: 200),
    this.maxWidth = 320,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  /// Rich content rendered inside the popover surface.
  final Widget content;

  /// The widget that the hover card is anchored to.
  final Widget child;

  /// Preferred edge — actual placement may flip if it would overflow.
  final LiqHoverCardPlacement placement;

  /// Delay between pointer-enter on [child] and the popover appearing.
  final Duration openDelay;

  /// Delay between the pointer leaving both [child] and the popover
  /// surface and the popover dismissing. Gives the user a small
  /// window to move the pointer from [child] into the popover.
  final Duration closeDelay;

  /// Maximum popover width.
  final double maxWidth;

  /// Padding around [content] inside the popover surface.
  final EdgeInsets padding;

  /// Popover surface fill — iOS 26 light glass at 95% alpha.
  static const Color backgroundColor = Color(0xF2FAFAFA);

  /// Popover hairline border color (iOS 26 0.5pt black at ~8% alpha).
  static const Color borderColor = Color(0x14000000);

  /// Popover hairline border width.
  static const double borderWidth = 0.5;

  /// Popover corner radius.
  static const double radius = 12;

  /// Gap between target and popover.
  static const double gap = 8;

  /// Drop-shadow color.
  static const Color shadowColor = Color(0x33000000);

  /// Drop-shadow offset.
  static const Offset shadowOffset = Offset(0, 8);

  /// Drop-shadow blur radius.
  static const double shadowBlurRadius = 24;

  /// Show/hide animation duration.
  static const Duration animationDuration = Duration(milliseconds: 200);

  /// Show/hide animation curve.
  static const Curve animationCurve = Curves.easeOutCubic;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqHoverCardPlacement>('placement', placement))
      ..add(DiagnosticsProperty<Duration>('openDelay', openDelay))
      ..add(DiagnosticsProperty<Duration>('closeDelay', closeDelay))
      ..add(DoubleProperty('maxWidth', maxWidth));
  }

  @override
  State<LiqHoverCard> createState() => _LiqHoverCardState();
}

class _LiqHoverCardState extends State<LiqHoverCard>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _link = LayerLink();
  late final AnimationController _animation;

  Timer? _openTimer;
  Timer? _closeTimer;

  bool _targetHovered = false;
  bool _popoverHovered = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: LiqHoverCard.animationDuration,
    );
  }

  @override
  void dispose() {
    _openTimer?.cancel();
    _closeTimer?.cancel();
    if (_portalController.isShowing) {
      _portalController.hide();
    }
    _animation.dispose();
    super.dispose();
  }

  void _cancelOpen() {
    _openTimer?.cancel();
    _openTimer = null;
  }

  void _cancelClose() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  void _scheduleOpen() {
    _cancelClose();
    if (_portalController.isShowing) {
      // Already visible — just keep it open.
      _animation.forward();
      return;
    }
    _cancelOpen();
    _openTimer = Timer(widget.openDelay, _open);
  }

  void _scheduleClose() {
    _cancelOpen();
    if (!_portalController.isShowing) return;
    _cancelClose();
    _closeTimer = Timer(widget.closeDelay, _close);
  }

  void _open() {
    if (!mounted) return;
    if (!_portalController.isShowing) {
      _portalController.show();
    }
    _animation.forward();
  }

  void _close() {
    if (!mounted) return;
    if (_targetHovered || _popoverHovered) return;
    _animation.reverse().then((_) {
      if (!mounted) return;
      if (_animation.value == 0 && _portalController.isShowing) {
        _portalController.hide();
      }
    });
  }

  void _onTargetEnter(PointerEnterEvent _) {
    _targetHovered = true;
    _scheduleOpen();
  }

  void _onTargetExit(PointerExitEvent _) {
    _targetHovered = false;
    if (_openTimer != null && !_portalController.isShowing) {
      _cancelOpen();
      return;
    }
    if (!_popoverHovered) {
      _scheduleClose();
    }
  }

  void _onPopoverEnter(PointerEnterEvent _) {
    _popoverHovered = true;
    _cancelClose();
  }

  void _onPopoverExit(PointerExitEvent _) {
    _popoverHovered = false;
    if (!_targetHovered) {
      _scheduleClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: MouseRegion(
        onEnter: _onTargetEnter,
        onExit: _onTargetExit,
        child: OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (BuildContext overlayContext) {
            return _LiqHoverCardOverlay(
              link: _link,
              animation: _animation,
              content: widget.content,
              placement: widget.placement,
              maxWidth: widget.maxWidth,
              padding: widget.padding,
              targetContext: context,
              onPopoverEnter: _onPopoverEnter,
              onPopoverExit: _onPopoverExit,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class _LiqHoverCardOverlay extends StatelessWidget {
  const _LiqHoverCardOverlay({
    required this.link,
    required this.animation,
    required this.content,
    required this.placement,
    required this.maxWidth,
    required this.padding,
    required this.targetContext,
    required this.onPopoverEnter,
    required this.onPopoverExit,
  });

  final LayerLink link;
  final Animation<double> animation;
  final Widget content;
  final LiqHoverCardPlacement placement;
  final double maxWidth;
  final EdgeInsets padding;
  final BuildContext targetContext;
  final void Function(PointerEnterEvent) onPopoverEnter;
  final void Function(PointerExitEvent) onPopoverExit;

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
      curve: LiqHoverCard.animationCurve,
      reverseCurve: LiqHoverCard.animationCurve,
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
            child: MouseRegion(
              onEnter: onPopoverEnter,
              onExit: onPopoverExit,
              child: _LiqHoverCardSurface(
                maxWidth: maxWidth,
                padding: padding,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Pick a placement that fits within [mediaSize]; flip to the
  /// opposite edge if the preferred one would overflow.
  LiqHoverCardPlacement _resolvePlacement(RenderBox? box, Size mediaSize) {
    if (box == null || !box.hasSize || mediaSize.isEmpty) return placement;
    final topLeft = box.localToGlobal(Offset.zero);
    final size = box.size;
    // Conservative popover extent — width is capped at maxWidth and we
    // assume a single row of content height for the auto-flip check.
    final cardW = maxWidth;
    const cardH = 96.0;
    switch (placement) {
      case LiqHoverCardPlacement.top:
        if (topLeft.dy - LiqHoverCard.gap - cardH < 0) {
          return LiqHoverCardPlacement.bottom;
        }
        return placement;
      case LiqHoverCardPlacement.bottom:
        if (topLeft.dy + size.height + LiqHoverCard.gap + cardH >
            mediaSize.height) {
          return LiqHoverCardPlacement.top;
        }
        return placement;
      case LiqHoverCardPlacement.left:
        if (topLeft.dx - LiqHoverCard.gap - cardW < 0) {
          return LiqHoverCardPlacement.right;
        }
        return placement;
      case LiqHoverCardPlacement.right:
        if (topLeft.dx + size.width + LiqHoverCard.gap + cardW >
            mediaSize.width) {
          return LiqHoverCardPlacement.left;
        }
        return placement;
    }
  }

  Offset _offsetForPlacement(LiqHoverCardPlacement p) {
    const extra = LiqHoverCard.gap;
    switch (p) {
      case LiqHoverCardPlacement.top:
        return const Offset(0, -extra);
      case LiqHoverCardPlacement.bottom:
        return const Offset(0, extra);
      case LiqHoverCardPlacement.left:
        return const Offset(-extra, 0);
      case LiqHoverCardPlacement.right:
        return const Offset(extra, 0);
    }
  }

  Alignment _followerAnchorForPlacement(LiqHoverCardPlacement p) {
    switch (p) {
      case LiqHoverCardPlacement.top:
        return Alignment.bottomCenter;
      case LiqHoverCardPlacement.bottom:
        return Alignment.topCenter;
      case LiqHoverCardPlacement.left:
        return Alignment.centerRight;
      case LiqHoverCardPlacement.right:
        return Alignment.centerLeft;
    }
  }

  Alignment _targetAnchorForPlacement(LiqHoverCardPlacement p) {
    switch (p) {
      case LiqHoverCardPlacement.top:
        return Alignment.topCenter;
      case LiqHoverCardPlacement.bottom:
        return Alignment.bottomCenter;
      case LiqHoverCardPlacement.left:
        return Alignment.centerLeft;
      case LiqHoverCardPlacement.right:
        return Alignment.centerRight;
    }
  }

  Alignment _scaleAlignmentForPlacement(LiqHoverCardPlacement p) {
    switch (p) {
      case LiqHoverCardPlacement.top:
        return Alignment.bottomCenter;
      case LiqHoverCardPlacement.bottom:
        return Alignment.topCenter;
      case LiqHoverCardPlacement.left:
        return Alignment.centerRight;
      case LiqHoverCardPlacement.right:
        return Alignment.centerLeft;
    }
  }
}

class _LiqHoverCardSurface extends StatelessWidget {
  const _LiqHoverCardSurface({
    required this.maxWidth,
    required this.padding,
    required this.child,
  });

  final double maxWidth;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: padding,
      decoration: const BoxDecoration(
        color: LiqHoverCard.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(LiqHoverCard.radius)),
        border: Border.fromBorderSide(
          BorderSide(
            color: LiqHoverCard.borderColor,
            width: LiqHoverCard.borderWidth,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LiqHoverCard.shadowColor,
            offset: LiqHoverCard.shadowOffset,
            blurRadius: LiqHoverCard.shadowBlurRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}
