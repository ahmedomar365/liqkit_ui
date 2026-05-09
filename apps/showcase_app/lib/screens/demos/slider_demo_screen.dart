import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class SliderDemoScreen extends ConsumerStatefulWidget {
  const SliderDemoScreen({super.key});

  @override
  ConsumerState<SliderDemoScreen> createState() => _SliderDemoScreenState();
}

class _SliderDemoScreenState extends ConsumerState<SliderDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Sliders')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Basic',
              description:
                  'Standard horizontal slider for single value selection.',
              child: SliderBasicExample(),
            ),
            _Section(
              title: 'Range',
              description: 'Select a range with two thumbs (start / end).',
              child: SliderRangeExample(),
            ),
            _Section(
              title: 'Discrete (Steps with Labels)',
              description: 'Stepped values mapped to descriptive labels.',
              child: SliderDiscreteExample(),
            ),
            _Section(
              title: 'Labeled Sliders',
              description:
                  'Sliders with leading icon, label, and a trailing value formatter.',
              child: SliderLabeledExample(),
            ),
            _Section(
              title: 'Vertical',
              description:
                  'Vertically oriented sliders (e.g. EQ-style controls).',
              child: SliderVerticalExample(),
            ),
            _Section(
              title: 'Custom Colors',
              description: 'Same slider component with different active colors.',
              child: SliderCustomColorsExample(),
            ),
            _Section(
              title: 'Size Variations',
              description: 'Different track heights and thumb sizes.',
              child: SliderSizeVariationsExample(),
            ),
          ],
        ),
      ),
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
