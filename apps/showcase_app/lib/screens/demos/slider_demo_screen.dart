import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class SliderDemoScreen extends ConsumerStatefulWidget {
  const SliderDemoScreen({super.key});

  @override
  ConsumerState<SliderDemoScreen> createState() => _SliderDemoScreenState();
}

class _SliderDemoScreenState extends ConsumerState<SliderDemoScreen> {
  double _basicValue = 0.5;
  LiqRangeValues _rangeValues = const LiqRangeValues(0.2, 0.8);
  double _verticalValue = 0.7;
  double _volume = 0.6;
  double _brightness = 0.8;
  double _speed = 50;
  int _fontSize = 16;
  int _rating = 3;

  static const List<String> _fontSizeLabels = <String>[
    'XS', 'S', 'M', 'L', 'XL',
  ];
  static const List<String> _ratingLabels = <String>[
    'Poor', 'Fair', 'Good', 'Great', 'Excellent',
  ];

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Sliders')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Basic',
              description:
                  'Standard horizontal slider for single value selection.',
              child: Column(
                children: <Widget>[
                  Text(
                    'Value: ${(_basicValue * 100).round()}%',
                    style: context.textStyles.body.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LiqSlider(
                    value: _basicValue,
                    divisions: 10,
                    onChanged: (v) => setState(() => _basicValue = v),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LiqButton(
                        label: 'Min',
                        size: LiqButtonSize.small,
                        style: LiqButtonStyle.borderedSecondary,
                        onPressed: () => setState(() => _basicValue = 0),
                      ),
                      const SizedBox(width: 12),
                      LiqButton(
                        label: 'Center',
                        size: LiqButtonSize.small,
                        style: LiqButtonStyle.borderedSecondary,
                        onPressed: () => setState(() => _basicValue = 0.5),
                      ),
                      const SizedBox(width: 12),
                      LiqButton(
                        label: 'Max',
                        size: LiqButtonSize.small,
                        style: LiqButtonStyle.borderedSecondary,
                        onPressed: () => setState(() => _basicValue = 1.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Range',
              description: 'Select a range with two thumbs (start / end).',
              child: Column(
                children: <Widget>[
                  Text(
                    'Range: ${(_rangeValues.start * 100).round()}% - ${(_rangeValues.end * 100).round()}%',
                    style: context.textStyles.body.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LiqRangeSlider(
                    values: _rangeValues,
                    divisions: 10,
                    startLabel: 'Start',
                    endLabel: 'End',
                    onChanged: (v) => setState(() => _rangeValues = v),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Discrete (Steps with Labels)',
              description: 'Stepped values mapped to descriptive labels.',
              child: Column(
                children: <Widget>[
                  Text('Font Size', style: context.textStyles.footnote.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                    color: context.appleColors.gray,
                  )),
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
                  Text('Rating', style: context.textStyles.footnote.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                    color: context.appleColors.gray,
                  )),
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
                    children: List<Widget>.generate(5, (index) {
                      return Icon(
                        index < _rating
                            ? LiqIcons.star
                            : LiqMaterialIcons.starBorder,
                        color: context.appleColors.yellow,
                      );
                    }),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Labeled Sliders',
              description: 'Sliders with leading icon, label, and a trailing value formatter.',
              child: Column(
                children: <Widget>[
                  LiqLabeledSlider(
                    value: _volume,
                    label: 'Volume',
                    leading: Icon(LiqMaterialIcons.volumeUp,
                        color: context.appleColors.gray),
                    valueFormatter: (v) => '${(v * 100).round()}%',
                    onChanged: (v) => setState(() => _volume = v),
                  ),
                  const SizedBox(height: 16),
                  LiqLabeledSlider(
                    value: _brightness,
                    label: 'Brightness',
                    leading: Icon(LiqMaterialIcons.brightness6,
                        color: context.appleColors.gray),
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
                    leading: Icon(LiqMaterialIcons.speed,
                        color: context.appleColors.gray),
                    activeColor: context.appleColors.green,
                    valueFormatter: (v) => '${v.round()} km/h',
                    onChanged: (v) => setState(() => _speed = v),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Vertical',
              description: 'Vertically oriented sliders (e.g. EQ-style controls).',
              child: SizedBox(
                height: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _verticalCol(
                      'Volume',
                      _verticalValue,
                      (v) => setState(() => _verticalValue = v),
                      color: context.appleColors.blue,
                    ),
                    _verticalCol(
                      'Bass',
                      0.3,
                      (_) {},
                      color: context.appleColors.purple,
                    ),
                    _verticalCol(
                      'Treble',
                      0.7,
                      (_) {},
                      color: context.appleColors.cyan,
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Custom Colors',
              description: 'Same slider component with different active colors.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final entry in <({String name, Color color, double value})>[
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
                          Text(entry.name,
                              style: context.textStyles.footnote.copyWith(
                                fontWeight: LiqAppleTypography.semibold,
                                color: context.appleColors.gray,
                              )),
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
              ),
            ),
            _Section(
              title: 'Size Variations',
              description: 'Different track heights and thumb sizes.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final entry in <({String label, double trackHeight, double? thumbWidth, double thumbHeight})>[
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
                          Text(entry.label,
                              style: context.textStyles.footnote.copyWith(
                                fontWeight: LiqAppleTypography.semibold,
                                color: context.appleColors.gray,
                              )),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalCol(
    String title,
    double value,
    ValueChanged<double> onChanged, {
    Color? color,
  }) {
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
        Text(
          '${(value * 100).round()}%',
          style: context.textStyles.body,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
