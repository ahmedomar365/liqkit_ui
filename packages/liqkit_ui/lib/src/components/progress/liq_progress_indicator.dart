import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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
  const LiqProgressBar({
    this.value,
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.label,
    this.showLabel = false,
    super.key,
  });

  /// Determinate progress in `[0, 1]`. Pass null for empty.
  final double? value;

  /// Optional override for the bar height (default 4pt).
  final double? height;

  /// Optional override for the unfilled track color.
  final Color? backgroundColor;

  /// Optional override for the filled portion color.
  final Color? progressColor;

  /// Optional label text rendered above the bar when [showLabel] is
  /// true. The current percentage is also shown to the right.
  final String? label;

  /// Whether to render the label / percentage row above the bar.
  final bool showLabel;

  static const double _trackHeight = 4;
  static const Color _trackColor = Color(0x33787878);
  static const Color _fillColor = Color(0xFF0088FF);

  @override
  Widget build(BuildContext context) {
    final palette = _ProgressPalette.resolve(context);
    final v = (value ?? 0).clamp(0.0, 1.0);
    final h = height ?? _trackHeight;
    final track = backgroundColor ?? palette.track;
    final fill = progressColor ?? palette.fill;

    final bar = Semantics(
      label: 'progress',
      value: '${(v * 100).round()}%',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width =
              constraints.hasBoundedWidth ? constraints.maxWidth : 240.0;
          return SizedBox(
            width: width,
            height: h,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: track,
                    borderRadius: BorderRadius.all(Radius.circular(h)),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: v,
                  child: Container(
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.all(Radius.circular(h)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (!showLabel) return bar;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'SF Pro Text',
                  color: fill.withValues(alpha: 0.9),
                ),
              )
            else
              const SizedBox.shrink(),
            Text(
              '${(v * 100).round()}%',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'SF Pro Text',
                color: fill.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        bar,
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(ColorProperty('progressColor', progressColor, defaultValue: null))
      ..add(StringProperty('label', label, defaultValue: null))
      ..add(FlagProperty('showLabel', value: showLabel, ifTrue: 'showLabel'));
  }
}

/// Size axis for [LiqSpinner].
enum LiqSpinnerSize {
  /// 22pt diameter, 2pt border.
  small,

  /// 30pt diameter, 2.5pt border.
  regular,
}

/// iOS 26 indeterminate activity indicator.
///
/// Renders as a fixed-diameter 12-tick radial spinner so parent preview
/// constraints cannot stretch it into an oval.
final class LiqSpinner extends StatefulWidget {
  /// Creates a spinner.
  const LiqSpinner({this.size = LiqSpinnerSize.regular, super.key});

  /// Size axis.
  final LiqSpinnerSize size;

  static const Color _strokeColor = Color(0x993C3C43);
  static const Color _strokeFaint = Color(0x333C3C43);
  static const Duration _period = Duration(milliseconds: 900);
  static const int _tickCount = 12;

  /// Diameter in logical px.
  double get diameter => size == LiqSpinnerSize.regular ? 30.0 : 22.0;

  /// Border width.
  double get borderWidth => size == LiqSpinnerSize.regular ? 2.5 : 2.0;

  @override
  State<LiqSpinner> createState() => _LiqSpinnerState();
}

class _LiqSpinnerState extends State<LiqSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LiqSpinner._period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.liqDisableAnimations) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ProgressPalette.resolve(context);
    final diameter = widget.diameter;
    final spinner = RepaintBoundary(
      child: SizedBox.square(
        dimension: diameter,
        child: CustomPaint(
          painter: _LiqSpinnerPainter(
            color: palette.spinnerStroke,
            tickCount: LiqSpinner._tickCount,
            strokeWidth: widget.borderWidth,
          ),
        ),
      ),
    );

    return UnconstrainedBox(
      child: SizedBox.square(
        dimension: diameter,
        child: Semantics(
          label: 'loading',
          child:
              context.liqDisableAnimations
                  ? spinner
                  : RotationTransition(turns: _controller, child: spinner),
        ),
      ),
    );
  }
}

final class _LiqSpinnerPainter extends CustomPainter {
  const _LiqSpinnerPainter({
    required this.color,
    required this.tickCount,
    required this.strokeWidth,
  });

  final Color color;
  final int tickCount;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = size.shortestSide;
    if (shortestSide <= 0 || tickCount <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = (shortestSide / 2) - (strokeWidth / 2);
    final innerRadius = outerRadius * 0.58;
    final angleStep = (math.pi * 2) / tickCount;

    canvas
      ..save()
      ..translate(center.dx, center.dy);

    for (var index = 0; index < tickCount; index += 1) {
      final opacity = 0.18 + (index / (tickCount - 1)) * 0.72;
      final paint =
          Paint()
            ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;

      canvas
        ..drawLine(Offset(0, -innerRadius), Offset(0, -outerRadius), paint)
        ..rotate(angleStep);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LiqSpinnerPainter oldDelegate) {
    return color != oldDelegate.color ||
        tickCount != oldDelegate.tickCount ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

final class _ProgressPalette {
  const _ProgressPalette({
    required this.track,
    required this.fill,
    required this.spinnerStroke,
    required this.spinnerFaint,
  });

  factory _ProgressPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _ProgressPalette(
        track: LiqProgressBar._trackColor,
        fill: LiqProgressBar._fillColor,
        spinnerStroke: LiqSpinner._strokeColor,
        spinnerFaint: LiqSpinner._strokeFaint,
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _ProgressPalette(
      track: secondary.withValues(alpha: 0.24),
      fill: context.liqPrimaryColor,
      spinnerStroke: secondary.withValues(alpha: 0.75),
      spinnerFaint: secondary.withValues(alpha: 0.25),
    );
  }

  final Color track;
  final Color fill;
  final Color spinnerStroke;
  final Color spinnerFaint;
}
