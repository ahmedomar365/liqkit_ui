import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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
  const LiqProgressBar({this.value, super.key});

  /// Determinate progress in `[0, 1]`. Pass null for empty.
  final double? value;

  static const double _trackHeight = 4;
  static const Color _trackColor = Color(0x33787878);
  static const Color _fillColor = Color(0xFF0088FF);

  @override
  Widget build(BuildContext context) {
    final palette = _ProgressPalette.resolve(context);
    final v = (value ?? 0).clamp(0.0, 1.0);
    return Semantics(
      label: 'progress',
      value: '${(v * 100).round()}%',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width =
              constraints.hasBoundedWidth ? constraints.maxWidth : 240.0;
          return SizedBox(
            width: width,
            height: _trackHeight,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: palette.track,
                    borderRadius: const BorderRadius.all(Radius.circular(999)),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: v,
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.fill,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
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
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ProgressPalette.resolve(context);
    return Semantics(
      label: 'loading',
      child: SizedBox.square(
        dimension: widget.diameter,
        child: CupertinoActivityIndicator(
          animating: _controller.isAnimating,
          radius: widget.diameter / 2,
          color: palette.spinnerStroke,
        ),
      ),
    );
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
