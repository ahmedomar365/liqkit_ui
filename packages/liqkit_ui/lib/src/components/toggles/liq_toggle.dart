import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 toggle switch.
///
/// All values sourced from liqkit's `native/components/toggles.css`:
///   - track: 64x28, radius 100px, 2px padding
///   - knob:  39x24 white pill, radius 100px
///   - on  : background #34C759, label "|" on left
///   - off : background rgba(60,60,67,0.3), label "○" on right
/// The visible track remains 64x28 while the overall tap target is
/// expanded to 64x44 for comfortable iOS hit testing.
final class LiqToggle extends StatelessWidget {
  /// Creates a toggle.
  const LiqToggle({
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.scale = 1,
    this.enableHaptics = true,
    super.key,
  }) : assert(scale > 0, 'scale must be > 0');

  /// Current on/off state.
  final bool value;

  /// Tap callback. When `null` the toggle is disabled.
  final ValueChanged<bool>? onChanged;

  /// Optional override for the on-state track color (default
  /// `#34C759`).
  final Color? activeColor;

  /// Optional override for the off-state track color.
  final Color? inactiveColor;

  /// Optional override for the knob color (default white).
  final Color? thumbColor;

  /// Linear scale factor for the entire toggle. Defaults to 1.0.
  final double scale;

  /// Whether to fire `HapticFeedback.lightImpact()` on toggle. Default
  /// `true`.
  final bool enableHaptics;

  static const double _trackWidth = 64;
  static const double _trackHeight = 28;
  static const double _tapTargetHeight = 44;
  static const double _trackPadding = 2;
  static const double _knobWidth = 39;
  static const double _knobHeight = 24;
  static const Color _onBg = Color(0xFF34C759);
  static const Color _offBg = Color(0x4D3C3C43);
  static const Color _offBgDark = Color(0x33FFFFFF);
  static const Color _knob = Color(0xFFFFFFFF);
  static const Color _offRing = Color(0xFF8F9097);
  static const Color _offRingDark = Color(0xFFE5E5EA);
  static const Duration _animDuration = LiqMotion.fast;
  static const Curve _animCurve = LiqMotion.snappy;

  /// Total track width (test helper).
  static double get trackWidth => _trackWidth;

  /// Total track height (test helper).
  static double get trackHeight => _trackHeight;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    final effectiveValue = value;
    final isDark = context.liqIsDark;
    final offBg = inactiveColor ?? (isDark ? _offBgDark : _offBg);
    final offRing = isDark ? _offRingDark : _offRing;
    final onBg = activeColor ?? _onBg;
    final knobColor = thumbColor ?? _knob;

    void handleTap() {
      if (enableHaptics) HapticFeedback.lightImpact();
      onChanged!(!value);
    }

    final core = Semantics(
      toggled: effectiveValue,
      enabled: !disabled,
      label: 'toggle',
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(
          onTap: disabled ? null : handleTap,
          child: Opacity(
            opacity: disabled ? 0.4 : 1,
            child: SizedBox(
              width: _trackWidth,
              height: _tapTargetHeight,
              child: Center(
                child: AnimatedContainer(
                  duration: _animDuration,
                  curve: _animCurve,
                  width: _trackWidth,
                  height: _trackHeight,
                  padding: const EdgeInsets.all(_trackPadding),
                  decoration: BoxDecoration(
                    color: effectiveValue ? onBg : offBg,
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
                          decoration: BoxDecoration(
                            color: knobColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
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
                                  decoration: BoxDecoration(
                                    color: knobColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                )
                                : Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: offRing,
                                      width: 1.4,
                                    ),
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
          ),
        ),
      ),
    );

    if (scale == 1.0) return core;
    return Transform.scale(scale: scale, child: core);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('value', value: value, ifTrue: 'on', ifFalse: 'off'))
      ..add(ColorProperty('activeColor', activeColor, defaultValue: null))
      ..add(ColorProperty('inactiveColor', inactiveColor, defaultValue: null))
      ..add(ColorProperty('thumbColor', thumbColor, defaultValue: null))
      ..add(DoubleProperty('scale', scale, defaultValue: 1.0))
      ..add(
        FlagProperty(
          'enableHaptics',
          value: enableHaptics,
          ifTrue: 'haptics',
        ),
      )
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
