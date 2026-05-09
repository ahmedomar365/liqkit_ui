import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class StepperDemoScreen extends ConsumerStatefulWidget {
  const StepperDemoScreen({super.key});

  @override
  ConsumerState<StepperDemoScreen> createState() => _StepperDemoScreenState();
}

class _StepperDemoScreenState extends ConsumerState<StepperDemoScreen> {
  int _currentStep = 0;
  int _numericValue = 5;
  int _numericValue2 = 50;
  int _numericValue3 = 1;
  int _onboardingStep = 0;

  static const List<LiqStep> _basicSteps = <LiqStep>[
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

  List<LiqStep> get _stepsWithStates {
    return List<LiqStep>.generate(_basicSteps.length, (index) {
      final base = _basicSteps[index];
      LiqStepState state;
      var isActive = false;
      if (index < _currentStep) {
        state = LiqStepState.complete;
      } else if (index == _currentStep) {
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

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Steppers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Vertical Stepper',
              description:
                  'Step-by-step vertical navigation for forms and wizards.',
              child: LiqVerticalStepper(
                currentStep: _currentStep,
                steps: _stepsWithStates,
                showStepContent: true,
                onStepTapped: (step) => setState(() => _currentStep = step),
                onStepContinue: _currentStep < _basicSteps.length - 1
                    ? () => setState(() => _currentStep++)
                    : null,
                onStepCancel: _currentStep > 0
                    ? () => setState(() => _currentStep--)
                    : null,
              ),
            ),
            _Section(
              title: 'Horizontal Stepper',
              description: 'Compact horizontal step indicators.',
              child: Column(
                children: <Widget>[
                  LiqHorizontalStepper(
                    currentStep: _currentStep,
                    steps: _stepsWithStates,
                    onStepTapped: (step) =>
                        setState(() => _currentStep = step),
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
                        onPressed: _currentStep < _basicSteps.length - 1
                            ? () => setState(() => _currentStep++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Numeric Steppers',
              description:
                  'Increment / decrement numeric values with configurable steps.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Basic',
                      style: context.textStyles.footnote.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                        color: context.appleColors.gray,
                      )),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      LiqNumericStepper(
                        value: _numericValue,
                        min: 0,
                        max: 10,
                        onChanged: (v) => setState(() => _numericValue = v),
                      ),
                      const SizedBox(width: 16),
                      Text('Value: $_numericValue',
                          style: context.textStyles.body.secondary),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Step of 10',
                      style: context.textStyles.footnote.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                        color: context.appleColors.gray,
                      )),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      LiqNumericStepper(
                        value: _numericValue2,
                        min: 0,
                        max: 100,
                        step: 10,
                        onChanged: (v) =>
                            setState(() => _numericValue2 = v),
                      ),
                      const SizedBox(width: 16),
                      Text('Value: $_numericValue2 (step: 10)',
                          style: context.textStyles.body.secondary),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Disabled',
                      style: context.textStyles.footnote.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                        color: context.appleColors.gray,
                      )),
                  const SizedBox(height: 8),
                  LiqNumericStepper(
                    value: 5,
                    min: 0,
                    max: 10,
                    enabled: false,
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 24),
                  Text('Full Width',
                      style: context.textStyles.footnote.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                        color: context.appleColors.gray,
                      )),
                  const SizedBox(height: 8),
                  LiqNumericStepper(
                    value: _numericValue3,
                    min: 1,
                    max: 5,
                    fullWidth: true,
                    onChanged: (v) => setState(() => _numericValue3 = v),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Onboarding Stepper',
              description:
                  'Animated dot indicators for short tutorial / welcome flows.',
              child: Column(
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
                          Icon(
                            _onboardingIcon,
                            size: 64,
                            color: context.appleColors.blue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _onboardingTitle,
                            style: context.textStyles.title3.copyWith(
                              fontWeight: LiqAppleTypography.semibold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _onboardingDescription,
                            style: context.textStyles.body.secondary,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LiqOnboardingStepper(
                      stepCount: 4, currentStep: _onboardingStep),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_onboardingStep > 0)
                        LiqButton(
                          label: 'Back',
                          style: LiqButtonStyle.borderless,
                          size: LiqButtonSize.small,
                          onPressed: () =>
                              setState(() => _onboardingStep--),
                        ),
                      const SizedBox(width: 16),
                      LiqButton(
                        label:
                            _onboardingStep < 3 ? 'Next' : 'Get Started',
                        size: LiqButtonSize.small,
                        onPressed: () {
                          if (_onboardingStep < 3) {
                            setState(() => _onboardingStep++);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Progress Stepper',
              description:
                  'Track progress through a multi-step process (cart → shipping → payment → review → complete).',
              child: LiqProgressStepper(
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
              ),
            ),
            _Section(
              title: 'Custom Colors',
              description: 'Vertical stepper with custom active / complete / error colors.',
              child: LiqVerticalStepper(
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
              ),
            ),
            _Section(
              title: 'Error State',
              description: 'Horizontal stepper with one step in error state.',
              child: LiqHorizontalStepper(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _onboardingIcon => switch (_onboardingStep) {
        0 => LiqMaterialIcons.wavingHand,
        1 => LiqIcons.palette,
        2 => LiqMaterialIcons.security,
        3 => LiqMaterialIcons.rocketLaunch,
        _ => LiqIcons.star,
      };

  String get _onboardingTitle => switch (_onboardingStep) {
        0 => 'Welcome to Liquid UI',
        1 => 'Beautiful Design',
        2 => 'Secure & Private',
        3 => 'Ready to Start',
        _ => '',
      };

  String get _onboardingDescription => switch (_onboardingStep) {
        0 => 'Experience the future of mobile interfaces',
        1 => 'Stunning liquid glass effects and animations',
        2 => 'Your data is encrypted and protected',
        3 => "Let's begin your journey",
        _ => '',
      };
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
