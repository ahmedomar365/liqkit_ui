import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 stepper.
///
/// Sourced from liqkit `native/components/steppers.css`:
///   - control: 92×32 pill, bg #76768014, radius 100px
///   - button:  46×32, label "−" / "+", color #000, font 590 17/22 SF Pro
///   - divider: 1px wide, 4pt inset top/bottom, color #3C3C434D
final class LiqStepper extends StatelessWidget {
  /// Creates a stepper.
  const LiqStepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999999,
    this.step = 1,
    super.key,
  });

  /// Current integer value.
  final int value;

  /// Callback for value updates. Disabled when null OR when both -/+
  /// would push beyond [min]/[max].
  final ValueChanged<int>? onChanged;

  /// Minimum allowed value.
  final int min;

  /// Maximum allowed value.
  final int max;

  /// Increment per tap.
  final int step;

  static const double _controlWidth = 92;
  static const double _controlHeight = 32;
  static const Color _bg = Color(0x14767680);
  static const Color _label = Color(0xFF000000);
  static const Color _labelDisabled = Color(0x4D3C3C43);
  static const Color _divider = Color(0x4D3C3C43);

  bool get _canDecrement => onChanged != null && value - step >= min;
  bool get _canIncrement => onChanged != null && value + step <= max;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'stepper',
      value: '$value',
      child: SizedBox(
        width: _controlWidth,
        height: _controlHeight,
        child: Stack(
          children: <Widget>[
            const DecoratedBox(
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _StepperButton(
                    label: '−',
                    enabled: _canDecrement,
                    onTap:
                        _canDecrement ? () => onChanged!(value - step) : null,
                  ),
                ),
                Expanded(
                  child: _StepperButton(
                    label: '+',
                    enabled: _canIncrement,
                    onTap:
                        _canIncrement ? () => onChanged!(value + step) : null,
                  ),
                ),
              ],
            ),
            const Positioned(
              left: _controlWidth / 2 - 0.5,
              top: 4,
              bottom: 4,
              width: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _divider,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
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
      ..add(IntProperty('value', value))
      ..add(IntProperty('min', min))
      ..add(IntProperty('max', max))
      ..add(IntProperty('step', step))
      ..add(
        FlagProperty(
          'enabled',
          value: onChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 32,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
              fontSize: 17,
              height: 22 / 17,
              letterSpacing: -0.43,
              fontWeight: FontWeight.w600,
              color: enabled ? LiqStepper._label : LiqStepper._labelDisabled,
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
