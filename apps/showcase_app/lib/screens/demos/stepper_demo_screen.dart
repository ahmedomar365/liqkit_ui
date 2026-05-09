import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class StepperDemoScreen extends ConsumerStatefulWidget {
  const StepperDemoScreen({super.key});

  @override
  ConsumerState<StepperDemoScreen> createState() => _StepperDemoScreenState();
}

class _StepperDemoScreenState extends ConsumerState<StepperDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Steppers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Vertical Stepper',
              description:
                  'Step-by-step vertical navigation for forms and wizards.',
              child: StepperVerticalExample(),
            ),
            _Section(
              title: 'Horizontal Stepper',
              description: 'Compact horizontal step indicators.',
              child: StepperHorizontalExample(),
            ),
            _Section(
              title: 'Numeric Steppers',
              description:
                  'Increment / decrement numeric values with configurable steps.',
              child: StepperNumericExample(),
            ),
            _Section(
              title: 'Onboarding Stepper',
              description:
                  'Animated dot indicators for short tutorial / welcome flows.',
              child: StepperOnboardingExample(),
            ),
            _Section(
              title: 'Progress Stepper',
              description:
                  'Track progress through a multi-step process (cart → shipping → payment → review → complete).',
              child: StepperProgressExample(),
            ),
            _Section(
              title: 'Custom Colors',
              description:
                  'Vertical stepper with custom active / complete / error colors.',
              child: StepperCustomColorsExample(),
            ),
            _Section(
              title: 'Error State',
              description: 'Horizontal stepper with one step in error state.',
              child: StepperErrorStateExample(),
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
