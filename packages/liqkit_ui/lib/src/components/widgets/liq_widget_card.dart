import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 home-screen widget size — sets the aspect ratio of a card.
///
/// Sourced from `native/components/widgets.css` (`.ios26-widgets-size-card`).
enum LiqWidgetSize {
  /// Square (1:1).
  small,

  /// Wide (2:1).
  medium,

  /// Tall (1:1.045) — almost square, slightly taller.
  large,

  /// Extra-wide (2.1:1) — iPad-only.
  extraLarge,
}

/// iOS 26 home-screen widget card — radial-highlighted gradient surface.
///
/// Renders a 14pt-radius rounded rect with a default blue radial+linear
/// gradient (sky-blue highlight upper-left, system blue base), drop
/// shadow, and an optional bottom-left caption. The size is governed by
/// [size] (controls aspect ratio) and the parent's width.
final class LiqWidgetCard extends StatelessWidget {
  /// Creates a widget card.
  const LiqWidgetCard({
    this.size = LiqWidgetSize.medium,
    this.gradient,
    this.caption,
    this.child,
    this.onPressed,
    super.key,
  });

  /// Visual size — sets aspect ratio.
  final LiqWidgetSize size;

  /// Background gradient. Defaults to the system-blue iOS 26 widget
  /// gradient.
  final Gradient? gradient;

  /// Optional bottom-left caption.
  final String? caption;

  /// Body content (rendered above the gradient).
  final Widget? child;

  /// Tap callback.
  final VoidCallback? onPressed;

  static const Color _shadow = Color(0x33000000);

  static const Gradient _defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF5EC6F5), Color(0xFF007AFF)],
  );

  double _aspect() {
    switch (size) {
      case LiqWidgetSize.small:
        return 1;
      case LiqWidgetSize.medium:
        return 2;
      case LiqWidgetSize.large:
        return 1 / 1.045;
      case LiqWidgetSize.extraLarge:
        return 2.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      label: caption,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: AspectRatio(
          aspectRatio: _aspect(),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: gradient ?? _defaultGradient,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: _shadow,
                    offset: Offset(0, 8),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(painter: _HighlightPainter()),
                  ),
                  if (child != null) Positioned.fill(child: child!),
                  if (caption != null)
                    Positioned(
                      left: 8,
                      bottom: 6,
                      child: Text(
                        caption!,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                          fontSize: 11,
                          height: 14 / 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                          shadows: <Shadow>[
                            Shadow(
                              color: Color(0x73000000),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqWidgetSize>('size', size))
      ..add(StringProperty('caption', caption));
  }
}

class _HighlightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.22, size.height * 0.20);
    final radius = size.width * 0.6;
    final paint =
        Paint()
          ..shader = const RadialGradient(
            colors: <Color>[
              Color(0xE0FFFFFF),
              Color(0x1FFFFFFF),
              Color(0x00FFFFFF),
            ],
            stops: <double>[0, 0.5, 0.6],
          ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
