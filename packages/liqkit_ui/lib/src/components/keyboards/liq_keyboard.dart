import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_separator.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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
  static const Color _bgDark = Color(0xFF1C1C1E);
  static const Color _hairline = Color(0x1A161B26);
  static const Color _hairlineDark = LiqSeparator.dark;
  // Shadow is handled by LiqGlassSurface elevation.
  static const Color _suggestionDivider = Color(0x14000000);
  static const Color _suggestionDividerDark = LiqSeparator.dark;
  static const Color _suggestionText = Color(0xFF1A1A1A);
  static const Color _suggestionTextDark = Color(0xFFFFFFFF);
  static const Color _keyText = Color(0xFF000000);
  static const Color _keyTextDark = Color(0xFFFFFFFF);
  static const Color _keyBg = Color(0xFFFFFFFF);
  static const Color _keyBgDark = Color(0xFF2C2C2E);
  static const Color _keyBorder = Color(0x1F000000);
  static const Color _keyBorderDark = Color(0x24FFFFFF);
  static const Color _keyShadow = Color(0x1F000000);
  static const Color _toolbarBg = Color(0xD9F4F6FA);
  static const Color _toolbarBgDark = Color(0xD92C2C2E);
  static const Color _toolbarBorder = Color(0x14000000);
  static const Color _toolbarBorderDark = Color(0x24FFFFFF);
  static const Color _glyph = Color(0xA1222B59);
  static const Color _glyphDark = Color(0x99EBEBF5);

  @override
  Widget build(BuildContext context) {
    final palette = _KeyboardPalette.resolve(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width, minHeight: minHeight),
      child: LiqGlassSurface(
        elevation: LiqGlassElevation.modal,
        borderRadius: const BorderRadius.all(Radius.circular(44)),
        padding: const EdgeInsets.fromLTRB(14, 22, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Suggestions(suggestions: suggestions, palette: palette),
            const SizedBox(height: 14),
            Expanded(child: _Keys(rows: keyRows, palette: palette)),
            const SizedBox(height: 14),
            _Toolbar(palette: palette),
          ],
        ),
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

final class _KeyboardPalette {
  const _KeyboardPalette({
    required this.background,
    required this.hairline,
    required this.suggestionDivider,
    required this.suggestionText,
    required this.keyBackground,
    required this.keyText,
    required this.keyBorder,
    required this.toolbarBackground,
    required this.toolbarBorder,
    required this.glyph,
  });

  factory _KeyboardPalette.resolve(BuildContext context) {
    if (context.liqIsDark) {
      return const _KeyboardPalette(
        background: LiqKeyboard._bgDark,
        hairline: LiqKeyboard._hairlineDark,
        suggestionDivider: LiqKeyboard._suggestionDividerDark,
        suggestionText: LiqKeyboard._suggestionTextDark,
        keyBackground: LiqKeyboard._keyBgDark,
        keyText: LiqKeyboard._keyTextDark,
        keyBorder: LiqKeyboard._keyBorderDark,
        toolbarBackground: LiqKeyboard._toolbarBgDark,
        toolbarBorder: LiqKeyboard._toolbarBorderDark,
        glyph: LiqKeyboard._glyphDark,
      );
    }
    return const _KeyboardPalette(
      background: LiqKeyboard._bg,
      hairline: LiqKeyboard._hairline,
      suggestionDivider: LiqKeyboard._suggestionDivider,
      suggestionText: LiqKeyboard._suggestionText,
      keyBackground: LiqKeyboard._keyBg,
      keyText: LiqKeyboard._keyText,
      keyBorder: LiqKeyboard._keyBorder,
      toolbarBackground: LiqKeyboard._toolbarBg,
      toolbarBorder: LiqKeyboard._toolbarBorder,
      glyph: LiqKeyboard._glyph,
    );
  }

  final Color background;
  final Color hairline;
  final Color suggestionDivider;
  final Color suggestionText;
  final Color keyBackground;
  final Color keyText;
  final Color keyBorder;
  final Color toolbarBackground;
  final Color toolbarBorder;
  final Color glyph;
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.suggestions, required this.palette});

  final List<String> suggestions;
  final _KeyboardPalette palette;

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
              style: TextStyle(
                color: palette.suggestionText,
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
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.suggestionDivider)),
      ),
      child: Row(children: cells),
    );
  }
}

class _Keys extends StatelessWidget {
  const _Keys({required this.rows, required this.palette});

  final List<List<String>> rows;
  final _KeyboardPalette palette;

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
            for (final label in row) _KeyPill(label: label, palette: palette),
        ],
      ),
    );
  }
}

class _KeyPill extends StatelessWidget {
  const _KeyPill({required this.label, required this.palette});

  final String label;
  final _KeyboardPalette palette;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 30, minHeight: 40),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.keyBackground,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.fromBorderSide(BorderSide(color: palette.keyBorder)),
          boxShadow: const <BoxShadow>[
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
              style: TextStyle(
                color: palette.keyText,
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
  const _Toolbar({required this.palette});

  final _KeyboardPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: palette.toolbarBackground,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(color: palette.toolbarBorder)),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 24,
            child: CustomPaint(
              painter: _EmojiGlyphPainter(palette.glyph),
              size: const Size(24, 24),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.keyBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.fromBorderSide(
                    BorderSide(color: palette.keyBorder),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 40,
            height: 24,
            child: CustomPaint(
              painter: _MicGlyphPainter(palette.glyph),
              size: const Size(24, 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiGlyphPainter extends CustomPainter {
  const _EmojiGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    final dx = (size.width - s) / 2;
    final dy = (size.height - s) / 2;
    final c = Offset(dx + s / 2, dy + s / 2);
    final r = s / 2 - 1;
    final stroke =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4;
    final fill = Paint()..color = color;
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
  bool shouldRepaint(_EmojiGlyphPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _MicGlyphPainter extends CustomPainter {
  const _MicGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final stroke =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = color;
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
  bool shouldRepaint(_MicGlyphPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
