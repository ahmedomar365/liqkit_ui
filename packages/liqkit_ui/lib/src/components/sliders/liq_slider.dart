import 'package:flutter/foundation.dart';
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
    this.brightness,
    super.key,
  });

  /// Current value, clamped to `[min, max]`.
  final double value;

  /// Tap/drag callback. When `null` the slider is rendered disabled.
  final ValueChanged<double>? onChanged;

  /// Minimum value of the range.
  final double min;

  /// Maximum value of the range.
  final double max;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

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

  void _emitFromX(double x, double width) {
    if (widget.onChanged == null) return;
    final usable = (width - 2 * LiqSlider._hInset).clamp(1.0, double.infinity);
    final t = ((x - LiqSlider._hInset) / usable).clamp(0.0, 1.0);
    widget.onChanged!(_denormalize(t));
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onChanged == null;
    final t = _normalize(widget.value);
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
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
                onTapDown:
                    disabled
                        ? null
                        : (details) =>
                            _emitFromX(details.localPosition.dx, width),
                onHorizontalDragUpdate:
                    disabled
                        ? null
                        : (details) =>
                            _emitFromX(details.localPosition.dx, width),
                onHorizontalDragEnd:
                    disabled ? null : (_) => _setPressed(false),
                onHorizontalDragCancel:
                    disabled ? null : () => _setPressed(false),
                child: Opacity(
                  opacity: disabled ? 0.5 : 1,
                  child: SizedBox(
                    width: width,
                    height: LiqSlider._rowHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        // Track background.
                        Positioned(
                          left: LiqSlider._hInset,
                          right: LiqSlider._hInset,
                          top:
                              (LiqSlider._rowHeight - LiqSlider._trackHeight) /
                              2,
                          child: Container(
                            height: LiqSlider._trackHeight,
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? LiqSlider._trackDark
                                      : LiqSlider._trackLight,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        // Filled portion left of the knob.
                        Positioned(
                          left: LiqSlider._hInset,
                          right:
                              LiqSlider._hInset +
                              (1 - t) * (width - 2 * LiqSlider._hInset),
                          top:
                              (LiqSlider._rowHeight - LiqSlider._trackHeight) /
                              2,
                          child: Container(
                            height: LiqSlider._trackHeight,
                            decoration: const BoxDecoration(
                              color: LiqSlider._fill,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        // Knob — centered on the value's pixel position.
                        Positioned(
                          left:
                              LiqSlider._hInset +
                              t * (width - 2 * LiqSlider._hInset) -
                              LiqSlider._knobWidth / 2,
                          top:
                              (LiqSlider._rowHeight - LiqSlider._knobHeight) /
                              2,
                          child: AnimatedScale(
                            scale: _pressed ? 1.08 : 1,
                            duration: LiqMotion.fast,
                            curve: LiqMotion.snappy,
                            child: AnimatedContainer(
                              duration: LiqMotion.fast,
                              curve: LiqMotion.snappy,
                              width: LiqSlider._knobWidth,
                              height: LiqSlider._knobHeight,
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? LiqSlider._knobDark
                                        : LiqSlider._knobLight,
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
