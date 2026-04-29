import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Shape of a [LiqSkeleton] placeholder.
enum LiqSkeletonShape {
  /// Rounded rectangle. Defaults to a 6pt corner radius.
  rect,

  /// Circle. Sized by [LiqSkeleton.width] for both axes.
  circle,

  /// Text bar. Defaults to a 14pt height and 4pt corner radius and
  /// stretches to fill its parent's width.
  text,
}

/// iOS 26 shimmer placeholder used while async content loads.
///
/// Animates a soft highlight sliding left-to-right across a tinted
/// base. The shape is selected by [shape]: a rounded rectangle, a
/// circle, or a text bar. The default colors and timings match the
/// iOS 26 system shimmer.
final class LiqSkeleton extends StatefulWidget {
  /// Creates a shimmer placeholder.
  const LiqSkeleton({
    this.width,
    this.height,
    this.shape = LiqSkeletonShape.rect,
    this.borderRadius,
    super.key,
  });

  /// Width of the placeholder.
  ///
  /// Required for [LiqSkeletonShape.rect] and [LiqSkeletonShape.circle].
  /// For [LiqSkeletonShape.text] this defaults to `double.infinity`
  /// so the bar fills its parent.
  final double? width;

  /// Height of the placeholder.
  ///
  /// Required for [LiqSkeletonShape.rect]. Ignored for
  /// [LiqSkeletonShape.circle] which uses [width] for both axes. For
  /// [LiqSkeletonShape.text] this defaults to 14.
  final double? height;

  /// Which shape to render.
  final LiqSkeletonShape shape;

  /// Override the per-shape default border radius.
  ///
  /// Defaults: [LiqSkeletonShape.rect] uses 6pt, [LiqSkeletonShape.text]
  /// uses 4pt, [LiqSkeletonShape.circle] ignores this.
  final BorderRadius? borderRadius;

  /// Base color: iOS 26 light surface fill.
  static const Color baseColor = Color(0xFFE5E5EA);

  /// Highlight color: iOS 26 brighter shimmer band.
  static const Color highlightColor = Color(0xFFF5F5F7);

  /// Duration of one full shimmer sweep.
  static const Duration period = Duration(milliseconds: 1400);

  @override
  State<LiqSkeleton> createState() => _LiqSkeletonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqSkeletonShape>('shape', shape))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height));
  }
}

class _LiqSkeletonState extends State<LiqSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: LiqSkeleton.period)
      ..repeat();
  }

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
        final gradient = LinearGradient(
          begin: Alignment(-1 + 2 * t, 0),
          end: Alignment(1 + 2 * t, 0),
          colors: const [
            LiqSkeleton.baseColor,
            LiqSkeleton.highlightColor,
            LiqSkeleton.baseColor,
          ],
          stops: const [0, 0.5, 1],
        );

        switch (widget.shape) {
          case LiqSkeletonShape.rect:
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(6),
              ),
            );
          case LiqSkeletonShape.circle:
            return Container(
              width: widget.width,
              height: widget.width,
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
              ),
            );
          case LiqSkeletonShape.text:
            return Container(
              width: widget.width ?? double.infinity,
              height: widget.height ?? 14,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
              ),
            );
        }
      },
    );
  }
}

/// Helper for skeletoning multi-line text.
///
/// Renders [lines] rows of skeleton bars stacked vertically with
/// [lineSpacing] between them. The final bar is shrunk to
/// [lastLineWidthFraction] of full width to read like real wrapped
/// text.
final class LiqSkeletonText extends StatelessWidget {
  /// Creates a multi-line skeleton block.
  const LiqSkeletonText({
    this.lines = 3,
    this.lineHeight = 14,
    this.lineSpacing = 8,
    this.lastLineWidthFraction = 0.6,
    super.key,
  });

  /// Number of skeleton lines.
  final int lines;

  /// Height of each skeleton line in logical pixels.
  final double lineHeight;

  /// Vertical gap between consecutive lines in logical pixels.
  final double lineSpacing;

  /// Width of the final line as a fraction of the parent's width.
  final double lastLineWidthFraction;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < lines; i++) {
      final isLast = i == lines - 1;
      if (isLast && lines > 1) {
        children.add(
          FractionallySizedBox(
            widthFactor: lastLineWidthFraction,
            alignment: Alignment.centerLeft,
            child: LiqSkeleton(
              shape: LiqSkeletonShape.text,
              height: lineHeight,
            ),
          ),
        );
      } else {
        children.add(
          LiqSkeleton(shape: LiqSkeletonShape.text, height: lineHeight),
        );
      }
      if (!isLast) {
        children.add(SizedBox(height: lineSpacing));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
