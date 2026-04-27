import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
    this.brightness = Brightness.light,
    this.width = 220,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  /// Body content.
  final Widget child;

  /// Edge from which the tip protrudes.
  final LiqPopoverSide side;

  /// Position of the tip along the edge.
  final LiqPopoverAlignment alignment;

  /// Surface brightness.
  final Brightness brightness;

  /// Bubble width. Defaults to 220pt.
  final double width;

  /// Padding around [child].
  final EdgeInsets padding;

  static const Color _bubbleLight = Color(0xD6FFFFFF);
  static const Color _bubbleDark = Color(0xF0272B36);
  static const Color _rimLight = Color(0xB3FFFFFF);
  static const Color _rimDark = Color(0x17FFFFFF);
  static const Color _shadowLight = Color(0x2E000000);
  static const Color _shadowDark = Color(0x57000000);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final fill = isDark ? _bubbleDark : _bubbleLight;
    final rim = isDark ? _rimDark : _rimLight;
    final shadow = isDark ? _shadowDark : _shadowLight;
    final tipPainter = _PopoverTipPainter(color: fill, side: side);

    final bubble = Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        border: Border.fromBorderSide(BorderSide(color: rim)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadow,
            offset: const Offset(0, 10),
            blurRadius: isDark ? 30 : 28,
          ),
        ],
      ),
      child: child,
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
      ..add(EnumProperty<Brightness>('brightness', brightness))
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
