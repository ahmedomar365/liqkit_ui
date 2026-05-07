import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/sliders/liq_slider.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Composition wrapper around [LiqSlider] that adds a leading widget
/// (typically an icon), a trailing label that displays the current
/// value via [valueFormatter], and an aligned title row above the
/// slider.
final class LiqLabeledSlider extends StatelessWidget with Diagnosticable {
  /// Creates a labeled slider.
  const LiqLabeledSlider({
    required this.value,
    required this.onChanged,
    this.label,
    this.leading,
    this.trailing,
    this.valueFormatter,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.activeColor,
    super.key,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final String? label;
  final Widget? leading;
  final Widget? trailing;
  final String Function(double value)? valueFormatter;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleStyle = LiqAppleTypography.body(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    final valueStyle = LiqAppleTypography.callout(brightness).copyWith(
      color: activeColor,
      fontWeight: LiqAppleTypography.semibold,
    );

    final hasHeader = label != null || leading != null ||
        valueFormatter != null || trailing != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (hasHeader)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: 8),
                ],
                if (label != null)
                  Expanded(child: Text(label!, style: titleStyle))
                else
                  const Spacer(),
                if (trailing != null)
                  trailing!
                else if (valueFormatter != null)
                  Text(valueFormatter!(value), style: valueStyle),
              ],
            ),
          ),
        LiqSlider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(StringProperty('label', label))
      ..add(IntProperty('divisions', divisions));
  }
}

/// Slider that exposes integer values with optional segment labels
/// (e.g. font-size XS/S/M/L/XL or a 1-5 rating). Backed by [LiqSlider]
/// with [LiqSlider.divisions] computed from the range.
final class LiqDiscreteSlider extends StatelessWidget with Diagnosticable {
  /// Creates a discrete-int slider.
  const LiqDiscreteSlider({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.labels,
    this.activeColor,
    super.key,
  })  : assert(max > min, 'max must be > min'),
        assert(labels == null || labels.length == max - min + 1,
            'labels length must equal (max - min + 1)');

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final List<String>? labels;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final labelStyle = LiqAppleTypography.caption2(brightness);
    final divisions = max - min;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LiqSlider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: divisions,
          activeColor: activeColor,
          onChanged: onChanged == null
              ? null
              : (v) => onChanged!(v.round()),
        ),
        if (labels != null) ...<Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels!
                  .map<Widget>(
                    (l) => Text(l, style: labelStyle),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('value', value))
      ..add(IntProperty('min', min))
      ..add(IntProperty('max', max));
  }
}

/// Two-thumb slider with a start and end value. Renders the legacy
/// "range slider" UX as two stacked [LiqSlider]s coordinated to keep
/// `start <= end`.
///
/// Note: this is a composition over the existing [LiqSlider] knob —
/// the iOS 26 native rendering with two thumbs on a single track is
/// deferred. Visually the two stacked sliders fall back to a clear
/// "from / to" pattern that matches App Store's filter sheet UX.
final class LiqRangeValues {
  const LiqRangeValues(this.start, this.end);
  final double start;
  final double end;
}

final class LiqRangeSlider extends StatelessWidget with Diagnosticable {
  /// Creates a range slider.
  const LiqRangeSlider({
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.activeColor,
    this.startLabel,
    this.endLabel,
    super.key,
  });

  final LiqRangeValues values;
  final ValueChanged<LiqRangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final String? startLabel;
  final String? endLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final captionStyle = LiqAppleTypography.caption1(brightness);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (startLabel != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(startLabel!, style: captionStyle),
          ),
        LiqSlider(
          value: values.start,
          min: min,
          max: values.end,
          divisions: divisions,
          activeColor: activeColor,
          onChanged: onChanged == null
              ? null
              : (v) => onChanged!(LiqRangeValues(v, values.end)),
        ),
        const SizedBox(height: 8),
        if (endLabel != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(endLabel!, style: captionStyle),
          ),
        LiqSlider(
          value: values.end,
          min: values.start,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
          onChanged: onChanged == null
              ? null
              : (v) => onChanged!(LiqRangeValues(values.start, v)),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('start', values.start))
      ..add(DoubleProperty('end', values.end))
      ..add(IntProperty('divisions', divisions));
  }
}

/// Vertically oriented [LiqSlider]. Renders by rotating the underlying
/// horizontal slider 90° anti-clockwise inside a SizedBox.
final class LiqVerticalSlider extends StatelessWidget with Diagnosticable {
  /// Creates a vertical slider.
  const LiqVerticalSlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.height = 200,
    this.divisions,
    this.activeColor,
    super.key,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final double height;
  final int? divisions;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: height,
      child: RotatedBox(
        quarterTurns: -1,
        child: LiqSlider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', value))
      ..add(DoubleProperty('height', height));
  }
}
