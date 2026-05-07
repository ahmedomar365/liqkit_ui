import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Side of the popover bubble that the tip points from.
enum LiqPopoverSide {
  /// Tip on the top edge, pointing up.
  top,

  /// Tip on the bottom edge, pointing down.
  bottom,

  /// Tip on the leading edge, pointing left (LTR).
  leading,

  /// Tip on the trailing edge, pointing right (LTR).
  trailing,
}

/// Position of the tip along the chosen edge.
enum LiqPopoverAlignment {
  /// Aligned to the leading end of the edge (8pt inset).
  leading,

  /// Centered along the edge.
  center,

  /// Aligned to the trailing end of the edge (8pt inset).
  trailing,
}

/// iOS 26 popover bubble.
///
/// Sourced from `native/components/popovers.css`:
/// translucent rounded surface (13pt radius) with a 56×13pt triangular tip
/// on a chosen [side] and [alignment].
final class LiqPopover extends StatelessWidget {
  /// Creates a popover.
  const LiqPopover({
    required this.child,
    this.side = LiqPopoverSide.top,
    this.alignment = LiqPopoverAlignment.center,
    this.brightness,
    this.width = 220,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  /// Show this popover as a modal overlay anchored at [anchor]. The
  /// bubble's tip points toward [anchor], offset by [side]. Returns
  /// whatever value is popped (or `null` if dismissed).
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    required Offset anchor,
    LiqPopoverSide side = LiqPopoverSide.bottom,
    LiqPopoverAlignment alignment = LiqPopoverAlignment.center,
    double width = 220,
    EdgeInsets padding = const EdgeInsets.all(14),
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<T>(
      _LiqPopoverRoute<T>(
        child: child,
        anchor: anchor,
        side: side,
        alignment: alignment,
        width: width,
        padding: padding,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Body content.
  final Widget child;

  /// Edge from which the tip protrudes.
  final LiqPopoverSide side;

  /// Position of the tip along the edge.
  final LiqPopoverAlignment alignment;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  /// Bubble width. Defaults to 220pt.
  final double width;

  /// Padding around [child].
  final EdgeInsets padding;

  static const Color _tipLight = LiqGlassSurface.lightTintBase;
  static const Color _tipDark = LiqGlassSurface.darkTintBase;
  static const Color _tipOpaqueLight = LiqGlassSurface.opaqueLightTintBase;
  static const Color _tipOpaqueDark = LiqGlassSurface.opaqueDarkTintBase;

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final useOpaque = context.liqUseOpaqueMaterials;
    final fill =
        useOpaque
            ? (isDark ? _tipOpaqueDark : _tipOpaqueLight)
            : (isDark ? _tipDark : _tipLight);
    final tipPainter = _PopoverTipPainter(color: fill, side: side);

    final bubble = SizedBox(
      width: width,
      child: LiqGlassSurface(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        padding: padding,
        tint: isDark ? LiqGlassTint.dark : LiqGlassTint.light,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: isDark ? const Color(0xFFFFFFFF) : null),
          child: child,
        ),
      ),
    );

    final tip = SizedBox(
      width:
          side == LiqPopoverSide.top || side == LiqPopoverSide.bottom ? 56 : 13,
      height:
          side == LiqPopoverSide.top || side == LiqPopoverSide.bottom ? 13 : 56,
      child: CustomPaint(painter: tipPainter),
    );

    return _PopoverLayout(
      side: side,
      alignment: alignment,
      bubble: bubble,
      tip: tip,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqPopoverSide>('side', side))
      ..add(EnumProperty<LiqPopoverAlignment>('alignment', alignment))
      ..add(EnumProperty<Brightness?>('brightness', brightness))
      ..add(DoubleProperty('width', width));
  }
}

class _PopoverLayout extends StatelessWidget {
  const _PopoverLayout({
    required this.side,
    required this.alignment,
    required this.bubble,
    required this.tip,
  });

  final LiqPopoverSide side;
  final LiqPopoverAlignment alignment;
  final Widget bubble;
  final Widget tip;

  @override
  Widget build(BuildContext context) {
    switch (side) {
      case LiqPopoverSide.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _crossAxis(),
          children: <Widget>[
            Padding(padding: _horizontalAlignmentInset(), child: tip),
            bubble,
          ],
        );
      case LiqPopoverSide.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _crossAxis(),
          children: <Widget>[
            bubble,
            Padding(padding: _horizontalAlignmentInset(), child: tip),
          ],
        );
      case LiqPopoverSide.leading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _verticalCrossAxis(),
          children: <Widget>[
            Padding(padding: _verticalAlignmentInset(), child: tip),
            bubble,
          ],
        );
      case LiqPopoverSide.trailing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _verticalCrossAxis(),
          children: <Widget>[
            bubble,
            Padding(padding: _verticalAlignmentInset(), child: tip),
          ],
        );
    }
  }

  CrossAxisAlignment _crossAxis() {
    switch (alignment) {
      case LiqPopoverAlignment.leading:
        return CrossAxisAlignment.start;
      case LiqPopoverAlignment.center:
        return CrossAxisAlignment.center;
      case LiqPopoverAlignment.trailing:
        return CrossAxisAlignment.end;
    }
  }

  CrossAxisAlignment _verticalCrossAxis() {
    switch (alignment) {
      case LiqPopoverAlignment.leading:
        return CrossAxisAlignment.start;
      case LiqPopoverAlignment.center:
        return CrossAxisAlignment.center;
      case LiqPopoverAlignment.trailing:
        return CrossAxisAlignment.end;
    }
  }

  EdgeInsets _horizontalAlignmentInset() {
    switch (alignment) {
      case LiqPopoverAlignment.leading:
        return const EdgeInsets.only(left: 8);
      case LiqPopoverAlignment.center:
        return EdgeInsets.zero;
      case LiqPopoverAlignment.trailing:
        return const EdgeInsets.only(right: 8);
    }
  }

  EdgeInsets _verticalAlignmentInset() {
    switch (alignment) {
      case LiqPopoverAlignment.leading:
        return const EdgeInsets.only(top: 8);
      case LiqPopoverAlignment.center:
        return EdgeInsets.zero;
      case LiqPopoverAlignment.trailing:
        return const EdgeInsets.only(bottom: 8);
    }
  }
}

class _PopoverTipPainter extends CustomPainter {
  _PopoverTipPainter({required this.color, required this.side});
  final Color color;
  final LiqPopoverSide side;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path = Path();
    switch (side) {
      case LiqPopoverSide.top:
        path
          ..moveTo(0, size.height)
          ..quadraticBezierTo(
            size.width / 2,
            size.height,
            size.width / 2 - 6,
            size.height * 0.4,
          )
          ..quadraticBezierTo(
            size.width / 2,
            0,
            size.width / 2 + 6,
            size.height * 0.4,
          )
          ..quadraticBezierTo(
            size.width / 2,
            size.height,
            size.width,
            size.height,
          )
          ..close();
      case LiqPopoverSide.bottom:
        path
          ..moveTo(0, 0)
          ..quadraticBezierTo(
            size.width / 2,
            0,
            size.width / 2 - 6,
            size.height * 0.6,
          )
          ..quadraticBezierTo(
            size.width / 2,
            size.height,
            size.width / 2 + 6,
            size.height * 0.6,
          )
          ..quadraticBezierTo(size.width / 2, 0, size.width, 0)
          ..close();
      case LiqPopoverSide.leading:
        path
          ..moveTo(size.width, 0)
          ..quadraticBezierTo(
            size.width,
            size.height / 2,
            size.width * 0.4,
            size.height / 2 - 6,
          )
          ..quadraticBezierTo(
            0,
            size.height / 2,
            size.width * 0.4,
            size.height / 2 + 6,
          )
          ..quadraticBezierTo(
            size.width,
            size.height / 2,
            size.width,
            size.height,
          )
          ..close();
      case LiqPopoverSide.trailing:
        path
          ..moveTo(0, 0)
          ..quadraticBezierTo(
            0,
            size.height / 2,
            size.width * 0.6,
            size.height / 2 - 6,
          )
          ..quadraticBezierTo(
            size.width,
            size.height / 2,
            size.width * 0.6,
            size.height / 2 + 6,
          )
          ..quadraticBezierTo(0, size.height / 2, 0, size.height)
          ..close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PopoverTipPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.side != side;
}

/// Modal route for [LiqPopover.show]. Positions the bubble around the
/// [anchor] point with a small offset so the tip touches the anchor.
class _LiqPopoverRoute<T> extends ModalRoute<T> {
  _LiqPopoverRoute({
    required this.child,
    required this.anchor,
    required this.side,
    required this.alignment,
    required this.width,
    required this.padding,
    bool barrierDismissible = true,
  }) : _barrierDismissible = barrierDismissible;

  final Widget child;
  final Offset anchor;
  final LiqPopoverSide side;
  final LiqPopoverAlignment alignment;
  final double width;
  final EdgeInsets padding;
  final bool _barrierDismissible;

  @override
  Color? get barrierColor => null;
  @override
  bool get barrierDismissible => _barrierDismissible;
  @override
  String? get barrierLabel => 'popover';
  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 180);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const margin = 16.0;
        // Bubble approximate size — final layout is done by LiqPopover.
        const estimatedHeight = 220.0;
        var left = anchor.dx - width / 2;
        var top = anchor.dy;
        switch (side) {
          case LiqPopoverSide.top:
            top = anchor.dy - estimatedHeight - 8;
          case LiqPopoverSide.bottom:
            top = anchor.dy + 8;
          case LiqPopoverSide.leading:
            left = anchor.dx - width - 8;
            top = anchor.dy - estimatedHeight / 2;
          case LiqPopoverSide.trailing:
            left = anchor.dx + 8;
            top = anchor.dy - estimatedHeight / 2;
        }
        if (left + width > constraints.maxWidth - margin) {
          left = constraints.maxWidth - width - margin;
        }
        if (left < margin) left = margin;
        if (top + estimatedHeight > constraints.maxHeight - margin) {
          top = constraints.maxHeight - estimatedHeight - margin;
        }
        if (top < margin) top = margin;

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _barrierDismissible
                    ? () => Navigator.of(context).pop()
                    : null,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
                  alignment: Alignment.topCenter,
                  child: LiqPopover(
                    side: side,
                    alignment: alignment,
                    width: width,
                    padding: padding,
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
