import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Page header for a kit demo: bold 56pt title + 28pt description.
///
/// Sourced from `native/components/kit-helpers.css`:
/// SF Pro Display 700 56/60 -0.28 title, SF Pro Text 400 28/34
/// description.
final class LiqKitHelpersHeader extends StatelessWidget {
  /// Creates a header.
  const LiqKitHelpersHeader({
    required this.title,
    required this.description,
    super.key,
  });

  /// Header title rendered at SF Pro Display 700 56/60.
  final String title;

  /// Description rendered at SF Pro Text 400 28/34.
  final String description;

  static const Color _ink = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontFamily: 'SF Pro Display',
            fontFamilyFallback: <String>['SF Pro Text', '-apple-system'],
            fontSize: 56,
            height: 60 / 56,
            letterSpacing: -0.28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          description,
          style: const TextStyle(
            color: _ink,
            fontFamily: 'SF Pro Text',
            fontSize: 28,
            height: 34 / 28,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description));
  }
}

/// Brightness for [LiqKitHelpersModePill].
enum LiqKitHelpersBrightness {
  /// Light pill — black text + dark grey hairline border.
  light,

  /// Dark pill — white text + light grey hairline border.
  dark,
}

/// 54×19 rounded pill labelling a mode preview.
///
/// Renders a small ring-with-dot glyph and a 590-weight 11/13 label.
/// Light/dark variants per the brightness flag.
final class LiqKitHelpersModePill extends StatelessWidget {
  /// Creates a mode pill.
  const LiqKitHelpersModePill({
    required this.label,
    this.brightness = LiqKitHelpersBrightness.light,
    super.key,
  });

  /// Visible label text.
  final String label;

  /// Light or dark variant.
  final LiqKitHelpersBrightness brightness;

  static const Color _lightBorder = Color(0x993C3C43);
  static const Color _darkBorder = Color(0xB3EBEBF5);
  static const Color _lightBg = Color(0x29787880);
  static const Color _darkBg = Color(0x52787880);
  static const Color _lightText = Color(0xFF000000);
  static const Color _darkText = Color(0xFFFFFFFF);
  static const Color _lightDot = Color(0xFF3C3C43);
  static const Color _darkDot = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == LiqKitHelpersBrightness.dark;
    final borderColor = isDark ? _darkBorder : _lightBorder;
    final bg = isDark ? _darkBg : _lightBg;
    final textColor = isDark ? _darkText : _lightText;
    final dotColor = isDark ? _darkDot : _lightDot;
    return Container(
      width: 54,
      height: 19,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _ModeDot(color: dotColor),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'SF Pro Text',
                  fontSize: 11,
                  height: 13 / 11,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(EnumProperty<LiqKitHelpersBrightness>('brightness', brightness));
  }
}

class _ModeDot extends StatelessWidget {
  const _ModeDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: Center(
          child: Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

/// 88×92 dashed-bordered card holding a stack of mode pills.
final class LiqKitHelpersModeLabels extends StatelessWidget {
  /// Creates a mode-labels card.
  const LiqKitHelpersModeLabels({required this.children, super.key});

  /// Stacked [LiqKitHelpersModePill] children.
  final List<Widget> children;

  static const Color _bg = Color(0xFFAAAAAA);
  static const Color _dash = Color(0xFF6155F5);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const _DashedBorderPainter(_dash),
      child: Container(
        width: 88,
        constraints: const BoxConstraints(minHeight: 92),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
        decoration: const BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(height: 11),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      const Radius.circular(6),
    );
    final stroke =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    const dash = 4.0;
    const gap = 3.0;
    for (final m in metrics) {
      var d = 0.0;
      while (d < m.length) {
        final next = (d + dash).clamp(0.0, m.length);
        canvas.drawPath(m.extractPath(d, next), stroke);
        d = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
