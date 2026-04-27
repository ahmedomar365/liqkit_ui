import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Default QWERTY rows for [LiqKeyboard.keyRows].
const List<List<String>> liqKeyboardQwertyRows = <List<String>>[
  <String>['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  <String>['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
  <String>['z', 'x', 'c', 'v', 'b', 'n', 'm'],
];

/// iOS 26 keyboard surface — autocomplete suggestions, key flow, toolbar.
///
/// Sourced from `native/components/keyboards.css`:
/// 402×min-874 light surface, 22/14/16 padding, 44pt outer radius, soft
/// shadow + inset hairline. Three-row layout: suggestions strip
/// (3 columns), keys (flex-wrap row of 30×40 white pills), and a 44pt
/// toolbar (40-1fr-40 columns) with an emoji glyph, space bar, and mic
/// glyph.
final class LiqKeyboard extends StatelessWidget {
  /// Creates a keyboard.
  const LiqKeyboard({
    this.suggestions = const <String>['"The"', 'the', 'to'],
    this.keyRows = liqKeyboardQwertyRows,
    this.width = 402,
    this.minHeight = 874,
    super.key,
  });

  /// The three autocomplete suggestion slots.
  final List<String> suggestions;

  /// Rows of keys rendered in the keys panel.
  final List<List<String>> keyRows;

  /// Outer width of the keyboard surface.
  final double width;

  /// Minimum height of the keyboard surface.
  final double minHeight;

  static const Color _bg = Color(0xFFF3F4F7);
  static const Color _hairline = Color(0x1A161B26);
  static const Color _shadow = Color(0x290F141E);
  static const Color _suggestionDivider = Color(0x14000000);
  static const Color _suggestionText = Color(0xFF1A1A1A);
  static const Color _keyText = Color(0xFF000000);
  static const Color _keyBorder = Color(0x1F000000);
  static const Color _keyShadow = Color(0x1F000000);
  static const Color _toolbarBg = Color(0xD9F4F6FA);
  static const Color _toolbarBorder = Color(0x14000000);
  static const Color _glyph = Color(0xA1222B59);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.fromLTRB(14, 22, 14, 16),
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.all(Radius.circular(44)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: _shadow, offset: Offset(0, 12), blurRadius: 36),
        ],
        border: Border.fromBorderSide(BorderSide(color: _hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Suggestions(suggestions: suggestions),
          const SizedBox(height: 14),
          Expanded(child: _Keys(rows: keyRows)),
          const SizedBox(height: 14),
          const _Toolbar(),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>('suggestions', suggestions))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('minHeight', minHeight));
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    final cells = <Widget>[];
    for (var i = 0; i < 3; i++) {
      final label = i < suggestions.length ? suggestions[i] : '';
      cells.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 4,
              right: i == 2 ? 0 : 4,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(
                color: LiqKeyboard._suggestionText,
                fontSize: 17,
                height: 22 / 17,
                letterSpacing: -0.43,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      constraints: const BoxConstraints(minHeight: 27),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: LiqKeyboard._suggestionDivider),
        ),
      ),
      child: Row(children: cells),
    );
  }
}

class _Keys extends StatelessWidget {
  const _Keys({required this.rows});

  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: <Widget>[
          for (final row in rows)
            for (final label in row) _KeyPill(label: label),
        ],
      ),
    );
  }
}

class _KeyPill extends StatelessWidget {
  const _KeyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 30, minHeight: 40),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.fromBorderSide(
            BorderSide(color: LiqKeyboard._keyBorder),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: LiqKeyboard._keyShadow, offset: Offset(0, 1)),
          ],
        ),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            child: Text(
              label,
              style: const TextStyle(
                color: LiqKeyboard._keyText,
                fontSize: 17,
                height: 22 / 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: LiqKeyboard._toolbarBg,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(
          BorderSide(color: LiqKeyboard._toolbarBorder),
        ),
      ),
      child: const Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 24,
            child: CustomPaint(
              painter: _EmojiGlyphPainter(),
              size: Size(24, 24),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.fromBorderSide(
                    BorderSide(color: LiqKeyboard._keyBorder),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 40,
            height: 24,
            child: CustomPaint(painter: _MicGlyphPainter(), size: Size(24, 24)),
          ),
        ],
      ),
    );
  }
}

class _EmojiGlyphPainter extends CustomPainter {
  const _EmojiGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    final dx = (size.width - s) / 2;
    final dy = (size.height - s) / 2;
    final c = Offset(dx + s / 2, dy + s / 2);
    final r = s / 2 - 1;
    final stroke =
        Paint()
          ..color = LiqKeyboard._glyph
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4;
    final fill = Paint()..color = LiqKeyboard._glyph;
    final eyeDy = c.dy - s * 0.12;
    canvas
      ..drawCircle(c, r, stroke)
      ..drawCircle(Offset(c.dx - s * 0.18, eyeDy), s * 0.05, fill)
      ..drawCircle(Offset(c.dx + s * 0.18, eyeDy), s * 0.05, fill);
    final mouth =
        Path()
          ..moveTo(c.dx - s * 0.22, c.dy + s * 0.05)
          ..quadraticBezierTo(
            c.dx,
            c.dy + s * 0.28,
            c.dx + s * 0.22,
            c.dy + s * 0.05,
          );
    canvas.drawPath(mouth, stroke);
  }

  @override
  bool shouldRepaint(_EmojiGlyphPainter oldDelegate) => false;
}

class _MicGlyphPainter extends CustomPainter {
  const _MicGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final stroke =
        Paint()
          ..color = LiqKeyboard._glyph
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = LiqKeyboard._glyph;
    final capsule = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 3), width: 8, height: 13),
      const Radius.circular(4),
    );
    final arc = Rect.fromCenter(
      center: Offset(cx, cy + 1),
      width: 14,
      height: 14,
    );
    canvas
      ..drawRRect(capsule, fill)
      ..drawArc(arc, math.pi * 0.12, math.pi - math.pi * 0.24, false, stroke)
      ..drawLine(Offset(cx, cy + 7), Offset(cx, cy + 10), stroke)
      ..drawLine(Offset(cx - 3, cy + 10), Offset(cx + 3, cy + 10), stroke);
  }

  @override
  bool shouldRepaint(_MicGlyphPainter oldDelegate) => false;
}
