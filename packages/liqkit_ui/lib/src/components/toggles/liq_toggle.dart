import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 toggle switch.
///
/// All values sourced from liqkit's `native/components/toggles.css`:
///   - track: 64x28, radius 100px, 2px padding
///   - knob:  39x24 white pill, radius 100px
///   - on  : background #34C759, label "|" on left
///   - off : background rgba(60,60,67,0.3), label "○" on right
final class LiqToggle extends StatelessWidget {
  /// Creates a toggle.
  const LiqToggle({required this.value, required this.onChanged, super.key});

  /// Current on/off state.
  final bool value;

  /// Tap callback. When `null` the toggle is disabled.
  final ValueChanged<bool>? onChanged;

  static const double _trackWidth = 64;
  static const double _trackHeight = 28;
  static const double _trackPadding = 2;
  static const double _knobWidth = 39;
  static const double _knobHeight = 24;
  static const Color _onBg = Color(0xFF34C759);
  static const Color _offBg = Color(0x4D3C3C43);
  static const Color _knob = Color(0xFFFFFFFF);
  static const Color _offRing = Color(0xFF8F9097);
  static const Duration _animDuration = Duration(milliseconds: 200);
  static const Curve _animCurve = Curves.easeOut;

  /// Total track width (test helper).
  static double get trackWidth => _trackWidth;

  /// Total track height (test helper).
  static double get trackHeight => _trackHeight;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    final effectiveValue = value;
    return Semantics(
      toggled: effectiveValue,
      enabled: !disabled,
      label: 'toggle',
      child: GestureDetector(
        onTap: disabled ? null : () => onChanged!(!value),
        child: Opacity(
          opacity: disabled ? 0.4 : 1,
          child: AnimatedContainer(
            duration: _animDuration,
            curve: _animCurve,
            width: _trackWidth,
            height: _trackHeight,
            padding: const EdgeInsets.all(_trackPadding),
            decoration: BoxDecoration(
              color: effectiveValue ? _onBg : _offBg,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: _animDuration,
                  curve: _animCurve,
                  alignment:
                      effectiveValue
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    width: _knobWidth,
                    height: _knobHeight,
                    decoration: const BoxDecoration(
                      color: _knob,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: _animDuration,
                  curve: _animCurve,
                  alignment:
                      effectiveValue
                          ? const Alignment(-0.78, 0)
                          : const Alignment(0.78, 0),
                  child:
                      effectiveValue
                          ? Container(
                            width: 2,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: _knob,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2),
                              ),
                            ),
                          )
                          : Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              border: Border.all(color: _offRing, width: 1.4),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
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
      ..add(FlagProperty('value', value: value, ifTrue: 'on', ifFalse: 'off'))
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
