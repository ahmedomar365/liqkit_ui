import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Linear iOS 26 progress bar (4pt track, accent fill).
///
/// Sourced from `native/components/progress-indicators.css`:
///   - track  4pt tall, radius 999, bg rgba(120,120,120,0.2) = #33787878
///   - fill   #08F, radius 999, width = value*100%
final class LiqProgressBar extends StatelessWidget {
  /// Creates a progress bar.
  ///
  /// [value] in `[0, 1]`. When null the bar renders as fully empty —
  /// indeterminate animation is reserved for [LiqSpinner].
  const LiqProgressBar({this.value, super.key});

  /// Determinate progress in `[0, 1]`. Pass null for empty.
  final double? value;

  static const double _trackHeight = 4;
  static const Color _trackColor = Color(0x33787878);
  static const Color _fillColor = Color(0xFF0088FF);

  @override
  Widget build(BuildContext context) {
    final v = (value ?? 0).clamp(0.0, 1.0);
    return Semantics(
      label: 'progress',
      value: '${(v * 100).round()}%',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : 240.0;
          return SizedBox(
            width: width,
            height: _trackHeight,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: _trackColor,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: v,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: _fillColor,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
  }
}

/// Size axis for [LiqSpinner].
enum LiqSpinnerSize {
  /// 22pt diameter, 2pt border.
  small,

  /// 30pt diameter, 2.5pt border.
  regular,
}

/// iOS 26 indeterminate spinner.
///
/// Sourced from `native/components/progress-indicators.css`:
///   - regular 30x30 with 2.5pt border (right side at 20% opacity)
///   - small   22x22 with 2pt border
///   - color rgba(60,60,67,0.6); right edge rgba(60,60,67,0.2)
///   - 0.9s linear infinite rotation
final class LiqSpinner extends StatefulWidget {
  /// Creates a spinner.
  const LiqSpinner({this.size = LiqSpinnerSize.regular, super.key});

  /// Size axis.
  final LiqSpinnerSize size;

  static const Color _strokeColor = Color(0x993C3C43);
  static const Color _strokeFaint = Color(0x333C3C43);
  static const Duration _period = Duration(milliseconds: 900);

  /// Diameter in logical px.
  double get diameter =>
      size == LiqSpinnerSize.regular ? 30.0 : 22.0;

  /// Border width.
  double get borderWidth =>
      size == LiqSpinnerSize.regular ? 2.5 : 2.0;

  @override
  State<LiqSpinner> createState() => _LiqSpinnerState();
}

class _LiqSpinnerState extends State<LiqSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LiqSpinner._period,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'loading',
      child: SizedBox(
        width: widget.diameter,
        height: widget.diameter,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: CustomPaint(
                painter: _SpinnerPainter(
                  color: LiqSpinner._strokeColor,
                  faint: LiqSpinner._strokeFaint,
                  borderWidth: widget.borderWidth,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.color,
    required this.faint,
    required this.borderWidth,
  });

  final Color color;
  final Color faint;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = borderWidth / 2;
    final ringRect = Rect.fromLTWH(
      rect.left + inset,
      rect.top + inset,
      rect.width - borderWidth,
      rect.height - borderWidth,
    );
    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.butt
      ..color = color;
    final faintPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.butt
      ..color = faint;

    canvas
      // Main: ~270deg sweep starting from -135deg.
      ..drawArc(
        ringRect,
        -math.pi * 0.75,
        math.pi * 1.5,
        false,
        mainPaint,
      )
      // Faint: the remaining arc (right side).
      ..drawArc(
        ringRect,
        math.pi * 0.75,
        math.pi * 0.5,
        false,
        faintPaint,
      );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.faint != faint ||
      oldDelegate.borderWidth != borderWidth;
}
