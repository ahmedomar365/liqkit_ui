import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 horizontal slider.
///
/// All visual values from liqkit's `native/components/sliders.css`:
///   - track height 6px, radius 3px
///   - track bg light: rgba(120,120,120,0.2)  =  #33787878
///   - track bg dark : rgba(120,120,128,0.34) =  #57787880
///   - fill          : #08F (also liqkit's --ui-accent-primary)
///   - knob 38x24 pill, white (light) / #F8F8F8 (dark), shadow
///     `0 0.5px 4px rgba(0,0,0,0.12), 0 6px 13px rgba(0,0,0,0.12)`
///   - 16pt left/right inset on the row so the knob never overhangs
final class LiqSlider extends StatefulWidget {
  /// Creates a slider.
  const LiqSlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.brightness,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.trackHeight,
    this.thumbWidth,
    this.thumbHeight,
    this.enableHaptics = true,
    this.onChangeStart,
    this.onChangeEnd,
    super.key,
  }) : assert(divisions == null || divisions > 0,
            'divisions must be > 0 when provided');

  /// Current value, clamped to `[min, max]`.
  final double value;

  /// Tap/drag callback. When `null` the slider is rendered disabled.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts dragging.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user releases the slider.
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value of the range.
  final double min;

  /// Maximum value of the range.
  final double max;

  /// Optional discrete-step count. When set, [value] snaps to the
  /// nearest of `divisions + 1` evenly-spaced positions in `[min, max]`.
  final int? divisions;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  /// Optional override for the filled (left-of-knob) track color.
  final Color? activeColor;

  /// Optional override for the inactive (right-of-knob) track color.
  final Color? inactiveColor;

  /// Optional override for the knob color.
  final Color? thumbColor;

  /// Optional override for the track height. Defaults to 6pt.
  final double? trackHeight;

  /// Optional override for the knob width. Defaults to 38pt.
  final double? thumbWidth;

  /// Optional override for the knob height. Defaults to 24pt.
  final double? thumbHeight;

  /// Whether tap-down / change-end fire `HapticFeedback.lightImpact()`.
  final bool enableHaptics;

  static const double _trackHeight = 6;
  static const double _knobWidth = 38;
  static const double _knobHeight = 24;
  static const double _rowHeight = 24;
  static const double _hInset = 16;
  static const Color _trackLight = Color(0x33787878);
  static const Color _trackDark = Color(0x57787880);
  static const Color _fill = Color(0xFF0088FF);
  static const Color _knobLight = Color(0xFFFFFFFF);
  static const Color _knobDark = Color(0xFFF8F8F8);

  @override
  State<LiqSlider> createState() => _LiqSliderState();
}

class _LiqSliderState extends State<LiqSlider> {
  bool _pressed = false;

  double _normalize(double v) {
    final span = widget.max - widget.min;
    if (span <= 0) return 0;
    return ((v - widget.min) / span).clamp(0.0, 1.0);
  }

  double _denormalize(double t) =>
      widget.min + t.clamp(0.0, 1.0) * (widget.max - widget.min);

  double _snap(double v) {
    final divisions = widget.divisions;
    if (divisions == null) return v;
    final span = widget.max - widget.min;
    if (span <= 0) return v;
    final step = span / divisions;
    final stepped = ((v - widget.min) / step).round() * step + widget.min;
    return stepped.clamp(widget.min, widget.max);
  }

  void _emitFromX(double x, double width) {
    if (widget.onChanged == null) return;
    final usable = (width - 2 * LiqSlider._hInset).clamp(1.0, double.infinity);
    final t = ((x - LiqSlider._hInset) / usable).clamp(0.0, 1.0);
    widget.onChanged!(_snap(_denormalize(t)));
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _haptic() {
    if (widget.enableHaptics) HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onChanged == null;
    final t = _normalize(widget.value);
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
    final trackHeight = widget.trackHeight ?? LiqSlider._trackHeight;
    final knobW = widget.thumbWidth ?? LiqSlider._knobWidth;
    final knobH = widget.thumbHeight ?? LiqSlider._knobHeight;
    final rowHeight = knobH > LiqSlider._rowHeight ? knobH : LiqSlider._rowHeight;
    final activeColor = widget.activeColor ?? LiqSlider._fill;
    final inactiveColor = widget.inactiveColor ??
        (isDark ? LiqSlider._trackDark : LiqSlider._trackLight);
    final thumbColor = widget.thumbColor ??
        (isDark ? LiqSlider._knobDark : LiqSlider._knobLight);
    return Semantics(
      slider: true,
      enabled: !disabled,
      value: '${(t * 100).round()}%',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width =
              constraints.hasBoundedWidth ? constraints.maxWidth : 240.0;
          return LiqPointerCursor(
            enabled: !disabled,
            child: Listener(
              onPointerDown: disabled ? null : (_) => _setPressed(true),
              onPointerUp: disabled ? null : (_) => _setPressed(false),
              onPointerCancel: disabled ? null : (_) => _setPressed(false),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: disabled
                    ? null
                    : (details) {
                        _haptic();
                        _emitFromX(details.localPosition.dx, width);
                      },
                onHorizontalDragStart: disabled
                    ? null
                    : (_) {
                        widget.onChangeStart?.call(widget.value);
                        _haptic();
                      },
                onHorizontalDragUpdate: disabled
                    ? null
                    : (details) =>
                        _emitFromX(details.localPosition.dx, width),
                onHorizontalDragEnd: disabled
                    ? null
                    : (_) {
                        _setPressed(false);
                        widget.onChangeEnd?.call(widget.value);
                        _haptic();
                      },
                onHorizontalDragCancel:
                    disabled ? null : () => _setPressed(false),
                child: Opacity(
                  opacity: disabled ? 0.5 : 1,
                  child: SizedBox(
                    width: width,
                    height: rowHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        // Track background.
                        Positioned(
                          left: LiqSlider._hInset,
                          right: LiqSlider._hInset,
                          top: (rowHeight - trackHeight) / 2,
                          child: Container(
                            height: trackHeight,
                            decoration: BoxDecoration(
                              color: inactiveColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(trackHeight / 2),
                              ),
                            ),
                          ),
                        ),
                        // Filled portion left of the knob.
                        Positioned(
                          left: LiqSlider._hInset,
                          right: LiqSlider._hInset +
                              (1 - t) * (width - 2 * LiqSlider._hInset),
                          top: (rowHeight - trackHeight) / 2,
                          child: Container(
                            height: trackHeight,
                            decoration: BoxDecoration(
                              color: activeColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(trackHeight / 2),
                              ),
                            ),
                          ),
                        ),
                        // Knob — centered on the value's pixel position.
                        Positioned(
                          left: LiqSlider._hInset +
                              t * (width - 2 * LiqSlider._hInset) -
                              knobW / 2,
                          top: (rowHeight - knobH) / 2,
                          child: AnimatedScale(
                            scale: _pressed ? 1.08 : 1,
                            duration: context.liqMotionDuration(LiqMotion.fast),
                            curve: LiqMotion.snappy,
                            child: AnimatedContainer(
                              duration: context.liqMotionDuration(
                                LiqMotion.fast,
                              ),
                              curve: LiqMotion.snappy,
                              width: knobW,
                              height: knobH,
                              decoration: BoxDecoration(
                                color: thumbColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      isDark ? 0.20 : 0.12,
                                    ),
                                    offset: Offset(0, _pressed ? 1 : 0.5),
                                    blurRadius: _pressed ? 6 : 4,
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      isDark ? 0.30 : 0.16,
                                    ),
                                    offset: Offset(0, _pressed ? 8 : 6),
                                    blurRadius: _pressed ? 18 : 13,
                                  ),
                                ],
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
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', widget.value))
      ..add(DoubleProperty('min', widget.min))
      ..add(DoubleProperty('max', widget.max))
      ..add(EnumProperty<Brightness>('brightness', widget.brightness))
      ..add(
        FlagProperty(
          'enabled',
          value: widget.onChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}
