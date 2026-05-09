/// Canonical stepper variants — single source of truth for the showcase
/// app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/steppers/liq_stepper_wizards.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

const List<LiqStep> _kBasicSteps = <LiqStep>[
  LiqStep(
    title: 'Select Plan',
    subtitle: 'Choose your subscription',
    icon: LiqMaterialIcons.cardMembership,
    content: Text(
        'Choose from our available subscription plans that best fit your needs.'),
  ),
  LiqStep(
    title: 'Account Details',
    subtitle: 'Enter your information',
    icon: LiqMaterialIcons.person,
    content: Text(
        'Please provide your personal information to create your account.'),
  ),
  LiqStep(
    title: 'Payment',
    subtitle: 'Add payment method',
    icon: LiqMaterialIcons.payment,
    content: Text(
        'Add your preferred payment method to complete the subscription.'),
  ),
  LiqStep(
    title: 'Confirmation',
    subtitle: 'Review and confirm',
    icon: LiqMaterialIcons.checkCircle,
    content: Text('Review your order details and confirm your subscription.'),
  ),
];

List<LiqStep> _stepsWithStates(int currentStep) {
  return List<LiqStep>.generate(_kBasicSteps.length, (index) {
    final base = _kBasicSteps[index];
    LiqStepState state;
    var isActive = false;
    if (index < currentStep) {
      state = LiqStepState.complete;
    } else if (index == currentStep) {
      state = LiqStepState.editing;
      isActive = true;
    } else {
      state = LiqStepState.idle;
    }
    return LiqStep(
      title: base.title,
      subtitle: base.subtitle,
      icon: base.icon,
      content: base.content,
      state: state,
      isActive: isActive,
    );
  });
}

/// Step-by-step vertical navigation for forms and wizards.
final class StepperVerticalExample extends StatefulWidget {
  const StepperVerticalExample({super.key});

  @override
  State<StepperVerticalExample> createState() => _StepperVerticalExampleState();
}

class _StepperVerticalExampleState extends State<StepperVerticalExample> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return LiqVerticalStepper(
      currentStep: _currentStep,
      steps: _stepsWithStates(_currentStep),
      showStepContent: true,
      onStepTapped: (step) => setState(() => _currentStep = step),
      onStepContinue: _currentStep < _kBasicSteps.length - 1
          ? () => setState(() => _currentStep++)
          : null,
      onStepCancel: _currentStep > 0
          ? () => setState(() => _currentStep--)
          : null,
    );
  }
}

/// Compact horizontal step indicators with prev/next controls.
final class StepperHorizontalExample extends StatefulWidget {
  const StepperHorizontalExample({super.key});

  @override
  State<StepperHorizontalExample> createState() =>
      _StepperHorizontalExampleState();
}

class _StepperHorizontalExampleState extends State<StepperHorizontalExample> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LiqHorizontalStepper(
          currentStep: _currentStep,
          steps: _stepsWithStates(_currentStep),
          onStepTapped: (step) => setState(() => _currentStep = step),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LiqButton(
              label: 'Previous',
              size: LiqButtonSize.small,
              style: LiqButtonStyle.borderedSecondary,
              onPressed: _currentStep > 0
                  ? () => setState(() => _currentStep--)
                  : null,
            ),
            const SizedBox(width: 16),
            LiqButton(
              label: 'Next',
              size: LiqButtonSize.small,
              onPressed: _currentStep < _kBasicSteps.length - 1
                  ? () => setState(() => _currentStep++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// Increment / decrement numeric values with configurable steps.
final class StepperNumericExample extends StatefulWidget {
  const StepperNumericExample({super.key});

  @override
  State<StepperNumericExample> createState() => _StepperNumericExampleState();
}

class _StepperNumericExampleState extends State<StepperNumericExample> {
  int _v1 = 5;
  int _v2 = 50;
  int _v3 = 1;

  @override
  Widget build(BuildContext context) {
    final label = context.textStyles.footnote.copyWith(
      fontWeight: LiqAppleTypography.semibold,
      color: context.appleColors.gray,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Basic', style: label),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            LiqNumericStepper(
              value: _v1,
              min: 0,
              max: 10,
              onChanged: (v) => setState(() => _v1 = v),
            ),
            const SizedBox(width: 16),
            Text('Value: $_v1', style: context.textStyles.body.secondary),
          ],
        ),
        const SizedBox(height: 24),
        Text('Step of 10', style: label),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            LiqNumericStepper(
              value: _v2,
              min: 0,
              max: 100,
              step: 10,
              onChanged: (v) => setState(() => _v2 = v),
            ),
            const SizedBox(width: 16),
            Text(
              'Value: $_v2 (step: 10)',
              style: context.textStyles.body.secondary,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Disabled', style: label),
        const SizedBox(height: 8),
        const LiqNumericStepper(
          value: 5,
          min: 0,
          max: 10,
          enabled: false,
          onChanged: null,
        ),
        const SizedBox(height: 24),
        Text('Full Width', style: label),
        const SizedBox(height: 8),
        LiqNumericStepper(
          value: _v3,
          min: 1,
          max: 5,
          fullWidth: true,
          onChanged: (v) => setState(() => _v3 = v),
        ),
      ],
    );
  }
}

/// Animated dot indicators for short tutorial / welcome flows.
final class StepperOnboardingExample extends StatefulWidget {
  const StepperOnboardingExample({super.key});

  @override
  State<StepperOnboardingExample> createState() =>
      _StepperOnboardingExampleState();
}

class _StepperOnboardingExampleState extends State<StepperOnboardingExample> {
  int _step = 0;

  IconData get _icon => switch (_step) {
        0 => LiqMaterialIcons.wavingHand,
        1 => LiqIcons.palette,
        2 => LiqMaterialIcons.security,
        3 => LiqMaterialIcons.rocketLaunch,
        _ => LiqIcons.star,
      };

  String get _title => switch (_step) {
        0 => 'Welcome to Liquid UI',
        1 => 'Beautiful Design',
        2 => 'Secure & Private',
        3 => 'Ready to Start',
        _ => '',
      };

  String get _description => switch (_step) {
        0 => 'Experience the future of mobile interfaces',
        1 => 'Stunning liquid glass effects and animations',
        2 => 'Your data is encrypted and protected',
        3 => "Let's begin your journey",
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                context.appleColors.blue.withValues(alpha: 0.1),
                context.appleColors.purple.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(_icon, size: 64, color: context.appleColors.blue),
                const SizedBox(height: 16),
                Text(
                  _title,
                  style: context.textStyles.title3.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _description,
                  style: context.textStyles.body.secondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        LiqOnboardingStepper(stepCount: 4, currentStep: _step),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_step > 0)
              LiqButton(
                label: 'Back',
                style: LiqButtonStyle.borderless,
                size: LiqButtonSize.small,
                onPressed: () => setState(() => _step--),
              ),
            const SizedBox(width: 16),
            LiqButton(
              label: _step < 3 ? 'Next' : 'Get Started',
              size: LiqButtonSize.small,
              onPressed: () {
                if (_step < 3) setState(() => _step++);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Track progress through a multi-step process.
final class StepperProgressExample extends StatelessWidget {
  const StepperProgressExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqProgressStepper(
      currentStep: 2,
      steps: const <LiqStep>[
        LiqStep(
          title: 'Cart',
          subtitle: 'Review items',
          icon: LiqMaterialIcons.shoppingCart,
          state: LiqStepState.complete,
        ),
        LiqStep(
          title: 'Shipping',
          subtitle: 'Enter address',
          icon: LiqMaterialIcons.localShipping,
          state: LiqStepState.complete,
        ),
        LiqStep(
          title: 'Payment',
          subtitle: 'Add card details',
          icon: LiqMaterialIcons.payment,
          state: LiqStepState.editing,
          isActive: true,
        ),
        LiqStep(
          title: 'Review',
          subtitle: 'Confirm order',
          icon: LiqMaterialIcons.rateReview,
        ),
        LiqStep(
          title: 'Complete',
          subtitle: 'Order placed',
          icon: LiqMaterialIcons.doneAll,
        ),
      ],
      activeColor: context.appleColors.blue,
      completeColor: context.appleColors.green,
      onStepTapped: (_) {},
    );
  }
}

/// Vertical stepper with custom active / complete / error colors.
final class StepperCustomColorsExample extends StatelessWidget {
  const StepperCustomColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqVerticalStepper(
      currentStep: 2,
      steps: const <LiqStep>[
        LiqStep(
          title: 'Design',
          subtitle: 'Create mockups',
          icon: LiqIcons.palette,
          state: LiqStepState.complete,
        ),
        LiqStep(
          title: 'Develop',
          subtitle: 'Write code',
          icon: LiqMaterialIcons.code,
          state: LiqStepState.complete,
        ),
        LiqStep(
          title: 'Test',
          subtitle: 'Quality assurance',
          icon: LiqMaterialIcons.bugReport,
          state: LiqStepState.editing,
          isActive: true,
        ),
        LiqStep(
          title: 'Deploy',
          subtitle: 'Go live',
          icon: LiqMaterialIcons.rocketLaunch,
        ),
      ],
      showStepContent: false,
      activeColor: context.appleColors.purple,
      completeColor: context.appleColors.green,
      errorColor: context.appleColors.red,
      onStepTapped: (_) {},
    );
  }
}

/// Horizontal stepper with one step in error state.
final class StepperErrorStateExample extends StatelessWidget {
  const StepperErrorStateExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqHorizontalStepper(
      currentStep: 1,
      steps: const <LiqStep>[
        LiqStep(
          title: 'Valid',
          icon: LiqIcons.check,
          state: LiqStepState.complete,
        ),
        LiqStep(
          title: 'Error',
          icon: LiqIcons.error,
          state: LiqStepState.error,
          isActive: true,
        ),
        LiqStep(
          title: 'Pending',
          icon: LiqMaterialIcons.hourglassEmpty,
        ),
      ],
      activeColor: context.appleColors.orange,
      completeColor: context.appleColors.green,
      errorColor: context.appleColors.red,
      onStepTapped: (_) {},
    );
  }
}
