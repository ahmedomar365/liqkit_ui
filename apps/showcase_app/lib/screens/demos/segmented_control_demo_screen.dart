import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class SegmentedControlDemoScreen extends ConsumerStatefulWidget {
  const SegmentedControlDemoScreen({super.key});

  @override
  ConsumerState<SegmentedControlDemoScreen> createState() =>
      _SegmentedControlDemoScreenState();
}

class _SegmentedControlDemoScreenState
    extends ConsumerState<SegmentedControlDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Segmented Controls')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Standard',
              description:
                  'iOS-style segmented control with sliding selection indicator.',
              child: SegmentedControlStandardExample(),
            ),
            _Section(
              title: 'With Icons',
              description: 'Tab-style segments with leading icons.',
              child: SegmentedControlWithIconsExample(),
            ),
            _Section(
              title: 'Tab Style',
              description: 'Tab-based navigation with underline indicator.',
              child: SegmentedControlTabStyleExample(),
            ),
            _Section(
              title: 'Vertical',
              description: 'Vertical layout — useful for sidebar navigation.',
              child: SegmentedControlVerticalExample(),
            ),
            _Section(
              title: 'Custom Indicator Color',
              description:
                  'Tab segmented control with a custom indicator color.',
              child: SegmentedControlCustomIndicatorColorExample(),
            ),
            _Section(
              title: 'Custom Vertical Color',
              description:
                  'Vertical segmented control with a custom selected color.',
              child: SegmentedControlCustomVerticalColorExample(),
            ),
            _Section(
              title: 'Disabled',
              description:
                  'A disabled segmented control reads through but does not respond.',
              child: SegmentedControlDisabledExample(),
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
