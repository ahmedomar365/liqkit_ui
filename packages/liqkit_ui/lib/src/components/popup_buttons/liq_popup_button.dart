import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 popup button — large inline label with a trailing chevron tip.
///
/// Sourced from `native/components/popup-buttons.css`:
/// SF Pro Text 32/38 -0.43, enabled = #0088FF (system blue),
/// disabled = rgba(60,60,67,0.3). 14×14 chevron-down icon, 3pt gap.
final class LiqPopupButton extends StatefulWidget {
  /// Creates a popup button.
  const LiqPopupButton({required this.label, this.onPressed, super.key});

  /// Label.
  final String label;

  /// Tap callback. When null, the button is rendered disabled.
  final VoidCallback? onPressed;

  static const Color _enabled = Color(0xFF0088FF);
  static const Color _disabled = Color(0x4D3C3C43);
  static const Color _disabledDark = Color(0x52EBEBF5);
  static const double _visualHeight = 38;
  static const double _tapTargetHeight = 44;

  @override
  State<LiqPopupButton> createState() => _LiqPopupButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(
        FlagProperty(
          'enabled',
          value: onPressed != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _LiqPopupButtonState extends State<LiqPopupButton> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final color =
        disabled
            ? (context.liqIsDark
                ? LiqPopupButton._disabledDark
                : LiqPopupButton._disabled)
            : LiqPopupButton._enabled;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.label,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: Listener(
          onPointerDown: disabled ? null : (_) => _setPressed(true),
          onPointerUp: disabled ? null : (_) => _setPressed(false),
          onPointerCancel: disabled ? null : (_) => _setPressed(false),
          child: SizedBox(
            height: LiqPopupButton._tapTargetHeight,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onPressed,
                child: AnimatedScale(
                  scale: _pressed ? 0.96 : 1,
                  duration: context.liqMotionDuration(LiqMotion.fast),
                  curve: LiqMotion.snappy,
                  child: AnimatedOpacity(
                    opacity: _pressed ? 0.72 : 1,
                    duration: context.liqMotionDuration(LiqMotion.fast),
                    curve: LiqMotion.snappy,
                    child: SizedBox(
                      height: LiqPopupButton._visualHeight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            widget.label,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontFamilyFallback: const <String>[
                                'SF Pro',
                                'sans-serif',
                              ],
                              fontSize: 32,
                              height: LiqPopupButton._visualHeight / 32,
                              letterSpacing: -0.43,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 3),
                          SizedBox(
                            width: 18,
                            height: LiqPopupButton._visualHeight,
                            child: Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CustomPaint(
                                  painter: _ChevronDownPainter(color),
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
        ),
      ),
    );
  }
}

class _ChevronDownPainter extends CustomPainter {
  _ChevronDownPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 1.7;
    final path =
        Path()
          ..moveTo(size.width * 0.2, size.height * 0.4)
          ..lineTo(size.width * 0.5, size.height * 0.7)
          ..lineTo(size.width * 0.8, size.height * 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronDownPainter oldDelegate) =>
      oldDelegate.color != color;
}
