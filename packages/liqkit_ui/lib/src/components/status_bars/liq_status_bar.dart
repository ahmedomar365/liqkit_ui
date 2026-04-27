import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 phone status bar — clock + signal/wifi/battery glyphs.
///
/// Sourced from `native/components/status-bars.css` (`.ios26-statusbars-phone`):
/// 402×62 (or full width), padding 11/24/17/24, SF Pro Text 590 17/22 time on
/// the left, signal/wifi/battery glyphs on the right.
final class LiqStatusBar extends StatelessWidget {
  /// Creates a status bar.
  const LiqStatusBar({
    this.time = '9:41',
    this.brightness = Brightness.light,
    this.batteryLevel = 0.78,
    this.cellularBars = 4,
    super.key,
  });

  /// Clock label.
  final String time;

  /// Surface brightness — controls glyph + label color.
  final Brightness brightness;

  /// Battery level in [0..1].
  final double batteryLevel;

  /// Cellular bars in [0..4].
  final int cellularBars;

  static const Color _fgLight = Color(0xFF000000);
  static const Color _fgDark = Color(0xFFF3F5F9);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final fg = isDark ? _fgDark : _fgLight;
    return SizedBox(
      height: 62,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 11, 24, 17),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                time,
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                  fontSize: 17,
                  height: 22 / 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.43,
                  color: fg,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            _CellularBars(bars: cellularBars, color: fg),
            const SizedBox(width: 6),
            _WifiGlyph(color: fg),
            const SizedBox(width: 6),
            _BatteryGlyph(level: batteryLevel, color: fg),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('time', time))
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(DoubleProperty('batteryLevel', batteryLevel))
      ..add(IntProperty('cellularBars', cellularBars));
  }
}

class _CellularBars extends StatelessWidget {
  const _CellularBars({required this.bars, required this.color});
  final int bars;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 12,
      child: CustomPaint(painter: _CellularPainter(bars, color)),
    );
  }
}

class _CellularPainter extends CustomPainter {
  _CellularPainter(this.bars, this.color);
  final int bars;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const count = 4;
    const gap = 1.5;
    final w = (size.width - gap * (count - 1)) / count;
    for (var i = 0; i < count; i++) {
      final filled = i < bars;
      final paint =
          Paint()
            ..color = filled ? color : color.withValues(alpha: color.a * 0.3);
      final h = (i + 1) * (size.height / count);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * (w + gap), size.height - h, w, h),
        const Radius.circular(0.8),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CellularPainter oldDelegate) =>
      oldDelegate.bars != bars || oldDelegate.color != color;
}

class _WifiGlyph extends StatelessWidget {
  const _WifiGlyph({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 12,
      child: CustomPaint(painter: _WifiPainter(color)),
    );
  }
}

class _WifiPainter extends CustomPainter {
  _WifiPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    final cy = size.height * 0.95;
    for (var i = 0; i < 3; i++) {
      final r = 2.4 + i * 2.6;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        3.6,
        2,
        false,
        paint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), 0.9, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _WifiPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _BatteryGlyph extends StatelessWidget {
  const _BatteryGlyph({required this.level, required this.color});
  final double level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 12,
      child: CustomPaint(painter: _BatteryPainter(level, color)),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  _BatteryPainter(this.level, this.color);
  final double level;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke =
        Paint()
          ..color = color.withValues(alpha: color.a * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
    final fill = Paint()..color = color;
    final body = Rect.fromLTWH(0, 0, size.width - 2, size.height);
    final rrect = RRect.fromRectAndRadius(body, const Radius.circular(2.5));
    canvas.drawRRect(rrect, stroke);
    final innerW = (body.width - 4) * level.clamp(0.0, 1.0);
    final inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, innerW, body.height - 4),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(inner, fill);
    final cap = Rect.fromLTWH(
      size.width - 1.6,
      size.height * 0.32,
      1.6,
      size.height * 0.36,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(cap, const Radius.circular(0.8)),
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter oldDelegate) =>
      oldDelegate.level != level || oldDelegate.color != color;
}
