import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// A single bar in a [LiqBarChart].
@immutable
final class LiqBar with Diagnosticable {
  /// Creates a bar with the given [value] and optional [label] / [color].
  const LiqBar({required this.value, this.label, this.color});

  /// The bar's height value, projected onto the chart's y-axis.
  final double value;

  /// Optional category label rendered beneath the bar.
  final String? label;

  /// Override the chart's default color for this bar.
  final Color? color;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(StringProperty('label', label, defaultValue: null))
      ..add(ColorProperty('color', color, defaultValue: null));
  }
}

/// iOS 26 minimal bar chart.
///
/// Renders a single series of vertical bars across the full width of the
/// surrounding box, auto-scaling the y-axis to `[min, max]` (where `max`
/// defaults to the tallest bar value with a small headroom). Optional
/// 11pt category labels render in a 24pt strip beneath each bar.
///
/// Scope is deliberately narrow: a single series, no axes labels, no
/// legends, no grid lines. Wrap it in your own labels or annotations
/// when you need more — the goal is a clean primitive that drops into
/// dashboard tiles, list-cell summaries, and weekly summary widgets.
final class LiqBarChart extends StatelessWidget {
  /// Creates a bar chart that paints [bars] across its width.
  const LiqBarChart({
    required this.bars,
    this.color = barColor,
    this.barRadius = defaultBarRadius,
    this.barSpacing = defaultBarSpacing,
    this.min = 0,
    this.max,
    this.showLabels = true,
    super.key,
  }) : assert(bars.length > 0, 'bar chart needs at least 1 bar');

  /// The bars to render, drawn left-to-right at evenly-spaced x positions.
  final List<LiqBar> bars;

  /// Default fill color used for any [LiqBar] that does not override
  /// it via [LiqBar.color].
  final Color color;

  /// Top-corner radius of each bar in logical px. Bottom corners are
  /// always flush with the axis.
  final double barRadius;

  /// Horizontal gap between adjacent bars in logical px.
  final double barSpacing;

  /// Lower bound of the y-axis. Defaults to `0`.
  final double min;

  /// Upper bound of the y-axis. When null defaults to the maximum bar
  /// value times [defaultMaxHeadroom] to give a little breathing room
  /// above the tallest bar.
  final double? max;

  /// When true the chart reserves [labelAreaHeight] at the bottom for
  /// category labels; bars take the remaining height.
  final bool showLabels;

  /// iOS-blue default bar color (`#007AFF`).
  static const Color barColor = Color(0xFF007AFF);

  /// Default top-corner radius for each bar.
  static const double defaultBarRadius = 4;

  /// Default horizontal gap between bars.
  static const double defaultBarSpacing = 8;

  /// Reserved vertical strip below the bars for category labels.
  static const double labelAreaHeight = 24;

  /// Multiplier applied to the tallest bar value when [max] is null.
  static const double defaultMaxHeadroom = 1.05;

  /// Label font size (SF 11pt).
  static const double labelFontSize = 11;

  /// Label color (SF iOS secondary label `#8E8E93`).
  static const Color labelColor = Color(0xFF8E8E93);

  /// Default label text style used beneath bars when [showLabels] is true.
  static const TextStyle labelTextStyle = TextStyle(
    fontSize: labelFontSize,
    color: labelColor,
    height: 1.2,
  );

  /// Resolves the effective chart color for the current theme.
  @visibleForTesting
  static Color effectiveColorFor(BuildContext context, Color color) {
    return color == barColor ? context.liqPrimaryColor : color;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = effectiveColorFor(context, color);
    return LayoutBuilder(
      builder: (context, constraints) {
        return _BarChartLayout(
          bars: bars,
          color: effectiveColor,
          barRadius: barRadius,
          barSpacing: barSpacing,
          min: min,
          max: max,
          showLabels: showLabels,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', bars.length))
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('barRadius', barRadius))
      ..add(DoubleProperty('barSpacing', barSpacing))
      ..add(
        FlagProperty('showLabels', value: showLabels, ifTrue: 'showLabels'),
      );
  }
}

class _BarChartLayout extends StatelessWidget {
  const _BarChartLayout({
    required this.bars,
    required this.color,
    required this.barRadius,
    required this.barSpacing,
    required this.min,
    required this.max,
    required this.showLabels,
  });

  final List<LiqBar> bars;
  final Color color;
  final double barRadius;
  final double barSpacing;
  final double min;
  final double? max;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final paint = ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: CustomPaint(
        painter: _BarChartPainter(
          bars: bars,
          color: color,
          barRadius: barRadius,
          barSpacing: barSpacing,
          min: min,
          max: max,
        ),
      ),
    );

    if (!showLabels) {
      return paint;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: paint),
        SizedBox(
          height: LiqBarChart.labelAreaHeight,
          child: _BarLabelsRow(bars: bars, barSpacing: barSpacing),
        ),
      ],
    );
  }
}

class _BarLabelsRow extends StatelessWidget {
  const _BarLabelsRow({required this.bars, required this.barSpacing});

  final List<LiqBar> bars;
  final double barSpacing;

  @override
  Widget build(BuildContext context) {
    final labelColor =
        context.liqHasTheme
            ? context.liqSecondaryLabelColor
            : LiqBarChart.labelColor;
    final cells = <Widget>[];
    for (var i = 0; i < bars.length; i++) {
      final label = bars[i].label;
      cells.add(
        Expanded(
          child: Center(
            child:
                label == null
                    ? const SizedBox.shrink()
                    : Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: LiqBarChart.labelTextStyle.copyWith(
                        color: labelColor,
                      ),
                    ),
          ),
        ),
      );
      if (i != bars.length - 1) {
        cells.add(SizedBox(width: barSpacing));
      }
    }
    return Row(children: cells);
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.bars,
    required this.color,
    required this.barRadius,
    required this.barSpacing,
    required this.min,
    required this.max,
  });

  final List<LiqBar> bars;
  final Color color;
  final double barRadius;
  final double barSpacing;
  final double min;
  final double? max;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    if (bars.isEmpty) return;

    final n = bars.length;
    final totalSpacing = barSpacing * (n - 1);
    final usableWidth = (size.width - totalSpacing).clamp(0.0, size.width);
    final barWidth = n == 0 ? 0.0 : usableWidth / n;
    if (barWidth <= 0) return;

    final lo = min;
    final dataMax = _dataMax();
    final hi = max ?? dataMax * LiqBarChart.defaultMaxHeadroom;
    final degenerate = hi <= lo;
    final span = degenerate ? 1.0 : hi - lo;
    final chartHeight = size.height;

    for (var i = 0; i < n; i++) {
      final bar = bars[i];
      final x = i * (barWidth + barSpacing);
      final norm = ((bar.value - lo) / span).clamp(0.0, 1.0);
      final h = degenerate ? 0.0 : norm * chartHeight;
      final top = chartHeight - h;
      final rect = Rect.fromLTWH(x, top, barWidth, h);
      final radius = Radius.circular(barRadius);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: radius,
        topRight: radius,
      );
      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = bar.color ?? color;
      canvas.drawRRect(rrect, paint);
    }
  }

  double _dataMax() {
    var m = bars.first.value;
    for (final b in bars) {
      if (b.value > m) m = b.value;
    }
    return m;
  }

  @override
  bool shouldRepaint(_BarChartPainter old) {
    if (old.bars.length != bars.length) return true;
    for (var i = 0; i < bars.length; i++) {
      final a = old.bars[i];
      final b = bars[i];
      if (a.value != b.value || a.label != b.label || a.color != b.color) {
        return true;
      }
    }
    return old.color != color ||
        old.barRadius != barRadius ||
        old.barSpacing != barSpacing ||
        old.min != min ||
        old.max != max;
  }
}
