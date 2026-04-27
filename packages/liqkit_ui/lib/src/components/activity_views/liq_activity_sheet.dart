import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 share/activity sheet container.
///
/// Sourced from `native/components/activity-views.css` (`.ios26-activity-sheet`):
/// 402pt wide translucent surface, 34pt corner radius, padding 16pt,
/// inner white rim, drop shadow. Renders an optional [LiqActivityHeader]
/// followed by the [child] body.
final class LiqActivitySheet extends StatelessWidget {
  /// Creates an activity sheet.
  const LiqActivitySheet({
    this.header,
    this.child,
    this.width = 402,
    super.key,
  });

  /// Optional sheet header (thumb + title/subtitle + close).
  final Widget? header;

  /// Body content rendered below the header.
  final Widget? child;

  /// Sheet width.
  final double width;

  static const Color _bg = Color(0xE0F7F7F7);
  static const Color _rim = Color(0x9EFFFFFF);
  static const Color _shadow = Color(0x2E000000);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(34)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.all(Radius.circular(34)),
            border: Border.fromBorderSide(BorderSide(color: _rim)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: _shadow, offset: Offset(0, 14), blurRadius: 40),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (header != null) header!,
                if (header != null && child != null) const SizedBox(height: 14),
                if (child != null) child!,
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
    properties.add(DoubleProperty('width', width));
  }
}

/// Header for a [LiqActivitySheet] — 64pt thumb + title/subtitle + 36pt close.
final class LiqActivityHeader extends StatelessWidget {
  /// Creates a header.
  const LiqActivityHeader({
    required this.title,
    this.subtitle,
    this.thumb,
    this.onClose,
    super.key,
  });

  /// Bold first-line title.
  final String title;

  /// Optional smaller subtitle below.
  final String? subtitle;

  /// 64×64 leading thumbnail (file/icon preview).
  final Widget? thumb;

  /// Callback for the trailing close button. Null hides the button.
  final VoidCallback? onClose;

  static const Color _titleColor = Color(0xFF1A1A1A);
  static const Color _subtitleColor = Color(0xFF727272);
  static const Color _closeBg = Color(0x29787880);
  static const Color _closeFg = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 64, height: 64, child: thumb ?? const _DefaultThumb()),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                  fontSize: 15,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  fontWeight: FontWeight.w500,
                  color: _titleColor,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 13,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      fontWeight: FontWeight.w400,
                      color: _subtitleColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (onClose != null) ...<Widget>[
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: 'Close',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: _closeBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 16,
                  height: 16,
                  child: CustomPaint(painter: _CloseGlyphPainter(_closeFg)),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle));
  }
}

class _DefaultThumb extends StatelessWidget {
  const _DefaultThumb();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF4E8BFF),
            Color(0xFF6C4CFF),
            Color(0xFF7139D3),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'A',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontFamily: 'SF Pro Display',
          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

class _CloseGlyphPainter extends CustomPainter {
  const _CloseGlyphPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.7;
    canvas
      ..drawLine(
        Offset(size.width * 0.25, size.height * 0.25),
        Offset(size.width * 0.75, size.height * 0.75),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.75, size.height * 0.25),
        Offset(size.width * 0.25, size.height * 0.75),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _CloseGlyphPainter oldDelegate) =>
      oldDelegate.color != color;
}
