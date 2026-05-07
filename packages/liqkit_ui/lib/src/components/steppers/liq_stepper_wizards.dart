import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/steppers/liq_stepper.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Lifecycle state of a single [LiqStep] inside a wizard stepper.
enum LiqStepState {
  /// Hasn't been visited yet.
  idle,

  /// Currently active / being filled out.
  editing,

  /// Successfully completed.
  complete,

  /// Encountered a validation error.
  error,

  /// Cannot be entered (e.g. blocked by an earlier step).
  disabled,
}

/// Single step entry for [LiqVerticalStepper], [LiqHorizontalStepper]
/// and [LiqProgressStepper].
@immutable
class LiqStep {
  /// Creates a step.
  const LiqStep({
    required this.title,
    this.subtitle,
    this.icon,
    this.content,
    this.state = LiqStepState.idle,
    this.isActive = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? content;
  final LiqStepState state;
  final bool isActive;

  LiqStep _withState(LiqStepState newState, {bool? isActive}) {
    return LiqStep(
      title: title,
      subtitle: subtitle,
      icon: icon,
      content: content,
      state: newState,
      isActive: isActive ?? this.isActive,
    );
  }
}

class _StepPalette {
  const _StepPalette._({
    required this.active,
    required this.complete,
    required this.error,
    required this.idle,
    required this.label,
    required this.subtitle,
    required this.connector,
  });

  factory _StepPalette.resolve({
    required Brightness brightness,
    Color? activeOverride,
    Color? completeOverride,
    Color? errorOverride,
  }) {
    final isDark = brightness == Brightness.dark;
    return _StepPalette._(
      active: activeOverride ?? LiqAppleColors.systemBlue,
      complete: completeOverride ?? LiqAppleColors.systemGreen,
      error: errorOverride ?? LiqAppleColors.systemRed,
      idle: isDark
          ? const Color(0x33EBEBF5)
          : const Color(0x1A3C3C43),
      label: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
      subtitle: isDark
          ? const Color(0x99EBEBF5)
          : const Color(0x993C3C43),
      connector: isDark
          ? const Color(0x33EBEBF5)
          : const Color(0x1A3C3C43),
    );
  }

  final Color active;
  final Color complete;
  final Color error;
  final Color idle;
  final Color label;
  final Color subtitle;
  final Color connector;

  Color colorFor(LiqStepState state, bool isActive) {
    if (state == LiqStepState.complete) return complete;
    if (state == LiqStepState.error) return error;
    if (state == LiqStepState.editing || isActive) return active;
    if (state == LiqStepState.disabled) return idle;
    return idle;
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({
    required this.index,
    required this.step,
    required this.palette,
  });

  final int index;
  final LiqStep step;
  final _StepPalette palette;

  @override
  Widget build(BuildContext context) {
    final color = palette.colorFor(step.state, step.isActive);
    final isComplete = step.state == LiqStepState.complete;
    final isError = step.state == LiqStepState.error;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isComplete
          ? const Icon(_StepGlyphs.check, color: Color(0xFFFFFFFF), size: 18)
          : isError
              ? const Icon(_StepGlyphs.close,
                  color: Color(0xFFFFFFFF), size: 16)
              : step.icon != null
                  ? Icon(step.icon, color: const Color(0xFFFFFFFF), size: 16)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
    );
  }
}

class _StepGlyphs {
  static const IconData check = IconData(0xf383,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');
  static const IconData close = IconData(0xf36b,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');
}

/// Vertical wizard stepper — column of step badges connected by a
/// vertical line, with the active step's [LiqStep.content] expanded
/// inline. Optional Continue / Cancel buttons under the active step.
final class LiqVerticalStepper extends StatelessWidget with Diagnosticable {
  /// Creates a vertical stepper.
  const LiqVerticalStepper({
    required this.steps,
    required this.currentStep,
    this.showStepContent = true,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.activeColor,
    this.completeColor,
    this.errorColor,
    super.key,
  });

  final List<LiqStep> steps;
  final int currentStep;
  final bool showStepContent;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final Color? activeColor;
  final Color? completeColor;
  final Color? errorColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final palette = _StepPalette.resolve(
      brightness: brightness,
      activeOverride: activeColor,
      completeOverride: completeColor,
      errorOverride: errorColor,
    );
    final titleStyle = LiqAppleTypography.body(brightness).copyWith(
      color: palette.label,
      fontWeight: LiqAppleTypography.semibold,
    );
    final subtitleStyle = LiqAppleTypography.footnote(brightness)
        .copyWith(color: palette.subtitle);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < steps.length; i++)
          _verticalRow(i, palette, titleStyle, subtitleStyle),
      ],
    );
  }

  Widget _verticalRow(
    int index,
    _StepPalette palette,
    TextStyle titleStyle,
    TextStyle subtitleStyle,
  ) {
    final step = steps[index];
    final isLast = index == steps.length - 1;
    final isActiveStep = index == currentStep;
    final disabled = step.state == LiqStepState.disabled;
    return GestureDetector(
      onTap: disabled || onStepTapped == null
          ? null
          : () => onStepTapped!(index),
      behavior: HitTestBehavior.opaque,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _StepBadge(index: index, step: step, palette: palette),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: palette.connector,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(step.title, style: titleStyle),
                    if (step.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(step.subtitle!, style: subtitleStyle),
                      ),
                    if (showStepContent && isActiveStep && step.content != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: step.content,
                      ),
                    if (showStepContent &&
                        isActiveStep &&
                        (onStepContinue != null || onStepCancel != null))
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: <Widget>[
                            if (onStepContinue != null)
                              LiqButton(
                                label: 'Continue',
                                size: LiqButtonSize.small,
                                onPressed: onStepContinue,
                              ),
                            if (onStepContinue != null && onStepCancel != null)
                              const SizedBox(width: 8),
                            if (onStepCancel != null)
                              LiqButton(
                                label: 'Back',
                                size: LiqButtonSize.small,
                                style: LiqButtonStyle.borderless,
                                onPressed: onStepCancel,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentStep', currentStep))
      ..add(IntProperty('stepCount', steps.length));
  }
}

/// Horizontal wizard stepper — row of step badges connected by a
/// horizontal line, with optional title/subtitle below each badge.
final class LiqHorizontalStepper extends StatelessWidget with Diagnosticable {
  /// Creates a horizontal stepper.
  const LiqHorizontalStepper({
    required this.steps,
    required this.currentStep,
    this.showLabels = true,
    this.onStepTapped,
    this.activeColor,
    this.completeColor,
    this.errorColor,
    super.key,
  });

  final List<LiqStep> steps;
  final int currentStep;
  final bool showLabels;
  final ValueChanged<int>? onStepTapped;
  final Color? activeColor;
  final Color? completeColor;
  final Color? errorColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final palette = _StepPalette.resolve(
      brightness: brightness,
      activeOverride: activeColor,
      completeOverride: completeColor,
      errorOverride: errorColor,
    );
    final titleStyle = LiqAppleTypography.caption1(brightness).copyWith(
      color: palette.label,
      fontWeight: LiqAppleTypography.semibold,
    );
    final subtitleStyle = LiqAppleTypography.caption2(brightness)
        .copyWith(color: palette.subtitle);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var i = 0; i < steps.length; i++) ...<Widget>[
          if (i > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(height: 2, color: palette.connector),
              ),
            ),
          GestureDetector(
            onTap: steps[i].state == LiqStepState.disabled ||
                    onStepTapped == null
                ? null
                : () => onStepTapped!(i),
            child: Column(
              children: <Widget>[
                _StepBadge(index: i, step: steps[i], palette: palette),
                if (showLabels) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(steps[i].title, style: titleStyle),
                  if (steps[i].subtitle != null)
                    Text(steps[i].subtitle!, style: subtitleStyle),
                ],
              ],
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
      ..add(IntProperty('currentStep', currentStep))
      ..add(IntProperty('stepCount', steps.length));
  }
}

/// Onboarding-style step indicator — row of dots that grow when
/// active. Use for full-screen tutorial flows.
final class LiqOnboardingStepper extends StatelessWidget with Diagnosticable {
  /// Creates an onboarding stepper.
  const LiqOnboardingStepper({
    required this.stepCount,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.activeDotWidth = 24,
    this.spacing = 8,
    super.key,
  });

  final int stepCount;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double activeDotWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final accent = activeColor ?? LiqAppleColors.systemBlue;
    final inactive = inactiveColor ??
        (isDark ? const Color(0x4DEBEBF5) : const Color(0x4D3C3C43));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < stepCount; i++) ...<Widget>[
          if (i > 0) SizedBox(width: spacing),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: i == currentStep ? activeDotWidth : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: i == currentStep ? accent : inactive,
              borderRadius: BorderRadius.circular(dotSize),
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
      ..add(IntProperty('stepCount', stepCount))
      ..add(IntProperty('currentStep', currentStep));
  }
}

/// Form-progress stepper — wraps [LiqHorizontalStepper] with a wider
/// default and always-visible labels. Use for checkout / multi-page
/// forms.
final class LiqProgressStepper extends StatelessWidget with Diagnosticable {
  /// Creates a progress stepper.
  const LiqProgressStepper({
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
    this.activeColor,
    this.completeColor,
    this.errorColor,
    super.key,
  });

  final List<LiqStep> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final Color? activeColor;
  final Color? completeColor;
  final Color? errorColor;

  @override
  Widget build(BuildContext context) {
    return LiqHorizontalStepper(
      steps: steps,
      currentStep: currentStep,
      onStepTapped: onStepTapped,
      activeColor: activeColor,
      completeColor: completeColor,
      errorColor: errorColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentStep', currentStep))
      ..add(IntProperty('stepCount', steps.length));
  }
}

/// Numeric stepper that wraps [LiqStepper] with disabled-state and
/// full-width support (legacy LiquidNumericStepper API).
final class LiqNumericStepper extends StatelessWidget with Diagnosticable {
  /// Creates a numeric stepper.
  const LiqNumericStepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999999,
    this.step = 1,
    this.enabled = true,
    this.fullWidth = false,
    super.key,
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final int step;
  final bool enabled;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final stepper = LiqStepper(
      value: value,
      min: min,
      max: max,
      step: step,
      onChanged: enabled ? onChanged : null,
    );
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: stepper);
    }
    return stepper;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('value', value))
      ..add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'))
      ..add(FlagProperty('fullWidth', value: fullWidth, ifTrue: 'fullWidth'));
  }
}
