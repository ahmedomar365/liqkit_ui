/// Canonical slider variants — single source of truth for the showcase
/// app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/sliders/liq_slider.dart';
import 'package:liqkit_ui/src/components/sliders/liq_slider_variants.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

/// Standard horizontal slider for single value selection with min/center/max controls.
final class SliderBasicExample extends StatefulWidget {
  const SliderBasicExample({super.key});

  @override
  State<SliderBasicExample> createState() => _SliderBasicExampleState();
}

class _SliderBasicExampleState extends State<SliderBasicExample> {
  double _v = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Value: ${(_v * 100).round()}%',
          style: context.textStyles.body.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 16),
        LiqSlider(
          value: _v,
          divisions: 10,
          onChanged: (v) => setState(() => _v = v),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LiqButton(
              label: 'Min',
              size: LiqButtonSize.small,
              style: LiqButtonStyle.borderedSecondary,
              onPressed: () => setState(() => _v = 0),
            ),
            const SizedBox(width: 12),
            LiqButton(
              label: 'Center',
              size: LiqButtonSize.small,
              style: LiqButtonStyle.borderedSecondary,
              onPressed: () => setState(() => _v = 0.5),
            ),
            const SizedBox(width: 12),
            LiqButton(
              label: 'Max',
              size: LiqButtonSize.small,
              style: LiqButtonStyle.borderedSecondary,
              onPressed: () => setState(() => _v = 1.0),
            ),
          ],
        ),
      ],
    );
  }
}

/// Select a range with two thumbs (start / end).
final class SliderRangeExample extends StatefulWidget {
  const SliderRangeExample({super.key});

  @override
  State<SliderRangeExample> createState() => _SliderRangeExampleState();
}

class _SliderRangeExampleState extends State<SliderRangeExample> {
  LiqRangeValues _v = const LiqRangeValues(0.2, 0.8);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Range: ${(_v.start * 100).round()}% - ${(_v.end * 100).round()}%',
          style: context.textStyles.body.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 16),
        LiqRangeSlider(
          values: _v,
          divisions: 10,
          startLabel: 'Start',
          endLabel: 'End',
          onChanged: (v) => setState(() => _v = v),
        ),
      ],
    );
  }
}

/// Stepped values mapped to descriptive labels.
final class SliderDiscreteExample extends StatefulWidget {
  const SliderDiscreteExample({super.key});

  @override
  State<SliderDiscreteExample> createState() => _SliderDiscreteExampleState();
}

class _SliderDiscreteExampleState extends State<SliderDiscreteExample> {
  int _fontSize = 16;
  int _rating = 3;

  static const List<String> _fontSizeLabels = <String>[
    'XS', 'S', 'M', 'L', 'XL'
  ];
  static const List<String> _ratingLabels = <String>[
    'Poor', 'Fair', 'Good', 'Great', 'Excellent'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Font Size',
          style: context.textStyles.footnote.copyWith(
            fontWeight: LiqAppleTypography.semibold,
            color: context.appleColors.gray,
          ),
        ),
        const SizedBox(height: 8),
        LiqDiscreteSlider(
          value: _fontSize,
          min: 12,
          max: 20,
          labels: _fontSizeLabels,
          onChanged: (v) => setState(() => _fontSize = v),
        ),
        const SizedBox(height: 16),
        Text(
          'Sample Text',
          style: TextStyle(fontSize: _fontSize.toDouble()),
        ),
        const SizedBox(height: 24),
        Text(
          'Rating',
          style: context.textStyles.footnote.copyWith(
            fontWeight: LiqAppleTypography.semibold,
            color: context.appleColors.gray,
          ),
        ),
        const SizedBox(height: 8),
        LiqDiscreteSlider(
          value: _rating,
          min: 1,
          max: 5,
          labels: _ratingLabels,
          activeColor: context.appleColors.yellow,
          onChanged: (v) => setState(() => _rating = v),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(5, (i) {
            return Icon(
              i < _rating ? LiqIcons.star : LiqMaterialIcons.starBorder,
              color: context.appleColors.yellow,
            );
          }),
        ),
      ],
    );
  }
}

/// Sliders with leading icon, label, and a trailing value formatter.
final class SliderLabeledExample extends StatefulWidget {
  const SliderLabeledExample({super.key});

  @override
  State<SliderLabeledExample> createState() => _SliderLabeledExampleState();
}

class _SliderLabeledExampleState extends State<SliderLabeledExample> {
  double _volume = 0.6;
  double _brightness = 0.8;
  double _speed = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LiqLabeledSlider(
          value: _volume,
          label: 'Volume',
          leading: Icon(
            LiqMaterialIcons.volumeUp,
            color: context.appleColors.gray,
          ),
          valueFormatter: (v) => '${(v * 100).round()}%',
          onChanged: (v) => setState(() => _volume = v),
        ),
        const SizedBox(height: 16),
        LiqLabeledSlider(
          value: _brightness,
          label: 'Brightness',
          leading: Icon(
            LiqMaterialIcons.brightness6,
            color: context.appleColors.gray,
          ),
          activeColor: context.appleColors.orange,
          valueFormatter: (v) => '${(v * 100).round()}%',
          onChanged: (v) => setState(() => _brightness = v),
        ),
        const SizedBox(height: 16),
        LiqLabeledSlider(
          value: _speed,
          label: 'Speed',
          min: 0,
          max: 100,
          divisions: 10,
          leading: Icon(
            LiqMaterialIcons.speed,
            color: context.appleColors.gray,
          ),
          activeColor: context.appleColors.green,
          valueFormatter: (v) => '${v.round()} km/h',
          onChanged: (v) => setState(() => _speed = v),
        ),
      ],
    );
  }
}

class _VerticalCol extends StatelessWidget {
  const _VerticalCol({
    required this.title,
    required this.value,
    required this.onChanged,
    this.color,
  });

  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: context.textStyles.body.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LiqVerticalSlider(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ),
        const SizedBox(height: 12),
        Text('${(value * 100).round()}%', style: context.textStyles.body),
      ],
    );
  }
}

/// Vertically oriented sliders (e.g. EQ-style controls).
final class SliderVerticalExample extends StatefulWidget {
  const SliderVerticalExample({super.key});

  @override
  State<SliderVerticalExample> createState() => _SliderVerticalExampleState();
}

class _SliderVerticalExampleState extends State<SliderVerticalExample> {
  double _v = 0.7;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _VerticalCol(
            title: 'Volume',
            value: _v,
            onChanged: (v) => setState(() => _v = v),
            color: context.appleColors.blue,
          ),
          _VerticalCol(
            title: 'Bass',
            value: 0.3,
            onChanged: (_) {},
            color: context.appleColors.purple,
          ),
          _VerticalCol(
            title: 'Treble',
            value: 0.7,
            onChanged: (_) {},
            color: context.appleColors.cyan,
          ),
        ],
      ),
    );
  }
}

/// Same slider component with different active colors.
final class SliderCustomColorsExample extends StatelessWidget {
  const SliderCustomColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final entry
            in <({String name, Color color, double value})>[
          (name: 'Blue', color: context.appleColors.blue, value: 0.6),
          (name: 'Green', color: context.appleColors.green, value: 0.7),
          (name: 'Orange', color: context.appleColors.orange, value: 0.4),
          (name: 'Purple', color: context.appleColors.purple, value: 0.8),
          (name: 'Red', color: context.appleColors.red, value: 0.3),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.name,
                  style: context.textStyles.footnote.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                    color: context.appleColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                LiqSlider(
                  value: entry.value,
                  activeColor: entry.color,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Different track heights and thumb sizes.
final class SliderSizeVariationsExample extends StatelessWidget {
  const SliderSizeVariationsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final entry in <({
          String label,
          double trackHeight,
          double? thumbWidth,
          double thumbHeight
        })>[
          (label: 'Thin Track', trackHeight: 2, thumbWidth: null, thumbHeight: 20),
          (label: 'Standard', trackHeight: 4, thumbWidth: null, thumbHeight: 28),
          (label: 'Thick Track', trackHeight: 10, thumbWidth: null, thumbHeight: 32),
          (label: 'Large Thumb', trackHeight: 8, thumbWidth: 48, thumbHeight: 40),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.label,
                  style: context.textStyles.footnote.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                    color: context.appleColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                LiqSlider(
                  value: 0.5,
                  trackHeight: entry.trackHeight,
                  thumbWidth: entry.thumbWidth,
                  thumbHeight: entry.thumbHeight,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
      ],
    );
  }
}
