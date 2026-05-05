import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 stepper.
///
/// Sourced from liqkit `native/components/steppers.css`:
///   - control: 92×32 pill, bg #76768014, radius 100px
///   - button:  46×32, label "−" / "+", color #000, font 590 17/22 SF Pro
///   - divider: 1px wide, 4pt inset top/bottom, color #3C3C434D
/// The visible control remains 92×32 while the widget expands vertically
/// to a 44pt tap target.
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
  static const double _tapTargetHeight = 44;
  static const Color _bg = Color(0x14767680);
  static const Color _label = Color(0xFF000000);
  static const Color _labelDisabled = Color(0x4D3C3C43);
  static const Color _divider = Color(0x4D3C3C43);
  static const Color _bgDark = Color(0x33767680);
  static const Color _labelDark = Color(0xFFFFFFFF);
  static const Color _labelDisabledDark = Color(0x99EBEBF5);
  static const Color _dividerDark = Color(0x4DEBEBF5);

  bool get _canDecrement => onChanged != null && value - step >= min;
  bool get _canIncrement => onChanged != null && value + step <= max;

  @override
  Widget build(BuildContext context) {
    final palette = _StepperPalette.resolve(context);
    return Semantics(
      label: 'stepper',
      value: '$value',
      child: SizedBox(
        width: _controlWidth,
        height: _tapTargetHeight,
        child: Center(
          child: SizedBox(
            width: _controlWidth,
            height: _controlHeight,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _StepperButton(
                        label: '−',
                        enabled: _canDecrement,
                        palette: palette,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(100),
                        ),
                        onTap:
                            _canDecrement
                                ? () => onChanged!(value - step)
                                : null,
                      ),
                    ),
                    Expanded(
                      child: _StepperButton(
                        label: '+',
                        enabled: _canIncrement,
                        palette: palette,
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(100),
                        ),
                        onTap:
                            _canIncrement
                                ? () => onChanged!(value + step)
                                : null,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: _controlWidth / 2 - 0.5,
                  top: 4,
                  bottom: 4,
                  width: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.divider,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

final class _StepperPalette {
  const _StepperPalette({
    required this.background,
    required this.pressedBackground,
    required this.label,
    required this.disabledLabel,
    required this.divider,
  });

  factory _StepperPalette.resolve(BuildContext context) {
    if (context.liqIsDark) {
      return const _StepperPalette(
        background: LiqStepper._bgDark,
        pressedBackground: Color(0x33FFFFFF),
        label: LiqStepper._labelDark,
        disabledLabel: LiqStepper._labelDisabledDark,
        divider: LiqStepper._dividerDark,
      );
    }

    return const _StepperPalette(
      background: LiqStepper._bg,
      pressedBackground: Color(0x14000000),
      label: LiqStepper._label,
      disabledLabel: LiqStepper._labelDisabled,
      divider: LiqStepper._divider,
    );
  }

  final Color background;
  final Color pressedBackground;
  final Color label;
  final Color disabledLabel;
  final Color divider;
}

class _StepperButton extends StatefulWidget {
  const _StepperButton({
    required this.label,
    required this.enabled,
    required this.palette,
    required this.borderRadius,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final _StepperPalette palette;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  State<_StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<_StepperButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.enabled && widget.onTap != null;
    return LiqPointerCursor(
      enabled: interactive,
      child: Listener(
        onPointerDown: interactive ? (_) => _setPressed(true) : null,
        onPointerUp: interactive ? (_) => _setPressed(false) : null,
        onPointerCancel: interactive ? (_) => _setPressed(false) : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: context.liqMotionDuration(LiqMotion.fast),
            curve: LiqMotion.snappy,
            height: 32,
            decoration: BoxDecoration(
              color:
                  _pressed
                      ? widget.palette.pressedBackground
                      : const Color(0x00000000),
              borderRadius: widget.borderRadius,
            ),
            child: Center(
              child: AnimatedScale(
                scale: _pressed ? 0.92 : 1,
                duration: context.liqMotionDuration(LiqMotion.fast),
                curve: LiqMotion.snappy,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                    fontSize: 17,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    fontWeight: FontWeight.w600,
                    color:
                        widget.enabled
                            ? widget.palette.label
                            : widget.palette.disabledLabel,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
