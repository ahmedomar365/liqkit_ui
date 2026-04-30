import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 minimal sparkline / line chart.
///
/// Renders [values] across the full width of the surrounding box,
/// auto-scaling the y-axis to `[min, max]` (defaults to data extents).
/// Optional dot markers and a gradient area fill below the line.
///
/// Scope is deliberately narrow: a single series, no axes labels, no
/// legends, no zoom. Wrap it in your own labels if needed.
final class LiqLineChart extends StatelessWidget {
  /// Creates a line chart that paints [values] across its width.
  const LiqLineChart({
    required this.values,
    this.color = lineColor,
    this.strokeWidth = defaultStrokeWidth,
    this.showDots = false,
    this.fillArea = true,
    this.min,
    this.max,
    this.smooth = true,
    super.key,
  }) : assert(values.length >= 2, 'line chart needs at least 2 values');

  /// The y-values, plotted left-to-right at evenly-spaced x positions.
  final List<double> values;

  /// Stroke colour for the line, the dot fill, and the area gradient.
  final Color color;

  /// Line stroke width in logical px.
  final double strokeWidth;

  /// Whether to draw a filled dot at each data point.
  final bool showDots;

  /// When true the area between the line and the bottom axis is
  /// filled with a vertical gradient from `color.withOpacity(0.2)`
  /// at the line down to `color.withOpacity(0)` at the bottom.
  final bool fillArea;

  /// Lower bound of the y-axis. Defaults to the minimum of [values]
  /// when null.
  final double? min;

  /// Upper bound of the y-axis. Defaults to the maximum of [values]
  /// when null.
  final double? max;

  /// When true the line is drawn with Catmull-Rom-to-Bezier smoothing
  /// between adjacent points; otherwise straight line segments.
  final bool smooth;

  /// iOS-blue line colour (`#007AFF`).
  static const Color lineColor = Color(0xFF007AFF);

  /// Default line stroke width.
  static const double defaultStrokeWidth = 2;

  /// Filled-dot radius when [showDots] is true.
  static const double dotRadius = 3;

  /// White inner-ring stroke width on each dot.
  static const double dotInnerRingWidth = 1;

  /// Inner-ring colour on each dot (white).
  static const Color dotInnerRingColor = Color(0xFFFFFFFF);

  /// Area-fill top opacity (line → bottom gradient start).
  static const double areaFillTopOpacity = 0.2;

  /// Catmull-Rom tension for the smooth interpolation (0..1).
  static const double smoothTension = 0.5;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: CustomPaint(
        painter: _LineChartPainter(
          values: values,
          color: color,
          strokeWidth: strokeWidth,
          showDots: showDots,
          fillArea: fillArea,
          min: min,
          max: max,
          smooth: smooth,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', values.length))
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('strokeWidth', strokeWidth))
      ..add(FlagProperty('showDots', value: showDots, ifTrue: 'showDots'))
      ..add(FlagProperty('fillArea', value: fillArea, ifTrue: 'fillArea'))
      ..add(FlagProperty('smooth', value: smooth, ifTrue: 'smooth'));
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.values,
    required this.color,
    required this.strokeWidth,
    required this.showDots,
    required this.fillArea,
    required this.min,
    required this.max,
    required this.smooth,
  });

  final List<double> values;
  final Color color;
  final double strokeWidth;
  final bool showDots;
  final bool fillArea;
  final double? min;
  final double? max;
  final bool smooth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    if (values.length < 2) return;

    final dataMin = _dataMin();
    final dataMax = _dataMax();
    final lo = min ?? dataMin;
    final hi = max ?? dataMax;
    final degenerate = hi <= lo;
    final span = degenerate ? 1.0 : hi - lo;

    final points = <Offset>[];
    final lastIndex = values.length - 1;
    for (var i = 0; i < values.length; i++) {
      final x = lastIndex == 0 ? 0.0 : (i / lastIndex) * size.width;
      final double y;
      if (degenerate) {
        y = size.height / 2;
      } else {
        final norm = (values[i] - lo) / span;
        y = size.height - norm * size.height;
      }
      points.add(Offset(x, y));
    }

    final linePath = _buildLinePath(points);

    if (fillArea) {
      final areaPath =
          Path.from(linePath)
            ..lineTo(points.last.dx, size.height)
            ..lineTo(points.first.dx, size.height)
            ..close();
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color.withValues(alpha: LiqLineChart.areaFillTopOpacity),
          color.withValues(alpha: 0),
        ],
      );
      final areaPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..shader = gradient.createShader(Offset.zero & size);
      canvas.drawPath(areaPath, areaPaint);
    }

    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = color;
    canvas.drawPath(linePath, linePaint);

    if (showDots) {
      final dotFill =
          Paint()
            ..style = PaintingStyle.fill
            ..color = color;
      final dotRing =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = LiqLineChart.dotInnerRingWidth
            ..color = LiqLineChart.dotInnerRingColor;
      for (final p in points) {
        canvas
          ..drawCircle(p, LiqLineChart.dotRadius, dotFill)
          ..drawCircle(p, LiqLineChart.dotRadius, dotRing);
      }
    }
  }

  Path _buildLinePath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    if (!smooth) {
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      return path;
    }
    // Catmull-Rom to Bezier conversion. For each segment p1 -> p2,
    // control points are derived from neighbours p0 and p3.
    const tension = LiqLineChart.smoothTension;
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = i == 0 ? points[i] : points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : p2;

      final c1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension / 6,
        p1.dy + (p2.dy - p0.dy) * tension / 6,
      );
      final c2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension / 6,
        p2.dy - (p3.dy - p1.dy) * tension / 6,
      );
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  double _dataMin() {
    var m = values.first;
    for (final v in values) {
      if (v < m) m = v;
    }
    return m;
  }

  double _dataMax() {
    var m = values.first;
    for (final v in values) {
      if (v > m) m = v;
    }
    return m;
  }

  @override
  bool shouldRepaint(_LineChartPainter old) {
    return !listEquals(old.values, values) ||
        old.color != color ||
        old.strokeWidth != strokeWidth ||
        old.showDots != showDots ||
        old.fillArea != fillArea ||
        old.min != min ||
        old.max != max ||
        old.smooth != smooth;
  }
}
