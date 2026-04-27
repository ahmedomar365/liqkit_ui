import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Visual state of a [LiqFaceIdBezel].
enum LiqFaceIdState {
  /// Face ID glyph (squircle outline + cross-hair lines).
  scanning,

  /// Checkmark glyph (success).
  success,

  /// Slashed Face ID glyph (failure).
  fail,
}

/// iOS 26 Face ID indicator — 145pt black bezel with a 70pt green glyph.
///
/// Sourced from `native/components/face-id.css`:
/// 145×145 black bezel (40pt radius, soft drop shadow), 70×70 centered
/// glyph painted in `#87FA89`. Switch between states with [state].
final class LiqFaceIdBezel extends StatelessWidget {
  /// Creates a Face ID bezel.
  const LiqFaceIdBezel({
    this.state = LiqFaceIdState.scanning,
    this.size = 145,
    super.key,
  });

  /// Visual state.
  final LiqFaceIdState state;

  /// Bezel size (square).
  final double size;

  static const Color _bezel = Color(0xFF000000);
  static const Color _glyph = Color(0xFF87FA89);
  static const Color _shadow = Color(0x38000000);

  @override
  Widget build(BuildContext context) {
    final radius = size * (40 / 145);
    final glyphSize = size * (70 / 145);
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _bezel,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: _shadow, offset: Offset(0, 12), blurRadius: 74),
          ],
        ),
        child: Center(
          child: SizedBox(
            width: glyphSize,
            height: glyphSize,
            child: CustomPaint(
              painter: _FaceIdGlyphPainter(state: state, color: _glyph),
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
      ..add(EnumProperty<LiqFaceIdState>('state', state))
      ..add(DoubleProperty('size', size));
  }
}

class _FaceIdGlyphPainter extends CustomPainter {
  _FaceIdGlyphPainter({required this.state, required this.color});
  final LiqFaceIdState state;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = size.width * 0.07;
    final s = size.width / 70;
    switch (state) {
      case LiqFaceIdState.scanning:
        _paintFaceIdGlyph(canvas, size, stroke, s);
      case LiqFaceIdState.fail:
        _paintFaceIdGlyph(canvas, size, stroke, s);
        canvas.drawLine(
          Offset(size.width * 0.15, size.height * 0.85),
          Offset(size.width * 0.85, size.height * 0.15),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = size.width * 0.08,
        );
      case LiqFaceIdState.success:
        canvas.drawPath(
          Path()
            ..moveTo(s * 18, s * 36)
            ..lineTo(s * 30, s * 48)
            ..lineTo(s * 52, s * 24),
          stroke..strokeWidth = size.width * 0.08,
        );
    }
  }

  void _paintFaceIdGlyph(Canvas canvas, Size size, Paint stroke, double s) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 8, s * 8, s * 54, s * 54),
      Radius.circular(s * 14),
    );
    canvas
      ..drawRRect(body, stroke)
      ..drawLine(Offset(s * 22, s * 24), Offset(s * 22, s * 32), stroke)
      ..drawLine(Offset(s * 48, s * 24), Offset(s * 48, s * 32), stroke)
      ..drawPath(
        Path()
          ..moveTo(s * 35, s * 28)
          ..lineTo(s * 35, s * 38)
          ..lineTo(s * 30, s * 38),
        stroke,
      )
      ..drawPath(
        Path()
          ..moveTo(s * 24, s * 46)
          ..quadraticBezierTo(s * 35, s * 54, s * 46, s * 46),
        stroke,
      );
  }

  @override
  bool shouldRepaint(covariant _FaceIdGlyphPainter oldDelegate) =>
      oldDelegate.state != state || oldDelegate.color != color;
}
