import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/text_fields/liq_text_field.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 search field — `LiqTextField` pre-configured with a leading
/// search glyph, a clear-on-tap suffix, and the `search` return-key.
///
/// Pass any [IconData] (e.g. `LiqIcons.search` from `liqkit_ui_icons`)
/// to [searchIcon] / [clearIcon]; the default keeps liqkit_ui itself
/// dependency-free by drawing the glyphs as small [CustomPaint]s.
final class LiqSearchField extends StatefulWidget {
  /// Creates a search field.
  const LiqSearchField({
    this.controller,
    this.placeholder = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.showClearButton = true,
    this.brightness,
    this.variant = LiqTextFieldVariant.filled,
    this.searchIcon,
    this.clearIcon,
    super.key,
  });

  /// Optional controller. When `null`, the widget manages its own.
  final TextEditingController? controller;

  /// Placeholder text. Defaults to `'Search'`.
  final String placeholder;

  /// Called on every character change.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Called when the clear suffix is tapped.
  final VoidCallback? onClear;

  /// Whether to autofocus on first mount.
  final bool autofocus;

  /// Whether to render a clear-on-tap suffix.
  final bool showClearButton;

  /// Surface brightness override.
  final Brightness? brightness;

  /// Underlying field variant (`filled` by default).
  final LiqTextFieldVariant variant;

  /// Optional override for the leading search icon.
  final IconData? searchIcon;

  /// Optional override for the trailing clear icon.
  final IconData? clearIcon;

  @override
  State<LiqSearchField> createState() => _LiqSearchFieldState();
}

class _LiqSearchFieldState extends State<LiqSearchField> {
  TextEditingController? _internalController;
  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
    final placeholderColor =
        isDark ? const Color(0x4DEBEBF5) : const Color(0x4D3C3C43);

    final searchGlyph = widget.searchIcon != null
        ? Icon(widget.searchIcon, size: 18, color: placeholderColor)
        : SizedBox(
            width: 18,
            height: 18,
            child: CustomPaint(
              painter: _SearchGlyphPainter(color: placeholderColor),
            ),
          );

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;
        return LiqTextField(
          controller: _controller,
          placeholder: widget.placeholder,
          autofocus: widget.autofocus,
          variant: widget.variant,
          brightness: widget.brightness,
          textInputAction: TextInputAction.search,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          prefixIcon: searchGlyph,
          suffixIcon: widget.showClearButton && hasText
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _controller.clear();
                    widget.onClear?.call();
                    widget.onChanged?.call('');
                  },
                  child: widget.clearIcon != null
                      ? Icon(
                          widget.clearIcon,
                          size: 16,
                          color: placeholderColor,
                        )
                      : SizedBox(
                          width: 16,
                          height: 16,
                          child: CustomPaint(
                            painter:
                                _ClearGlyphPainter(color: placeholderColor),
                          ),
                        ),
                )
              : null,
        );
      },
    );
  }
}

class _SearchGlyphPainter extends CustomPainter {
  _SearchGlyphPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.7;
    final cx = size.width * 0.42;
    final cy = size.height * 0.42;
    final radius = size.width * 0.32;
    canvas.drawCircle(Offset(cx, cy), radius, paint);
    canvas.drawLine(
      Offset(cx + radius * 0.7, cy + radius * 0.7),
      Offset(size.width * 0.92, size.height * 0.92),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SearchGlyphPainter old) => old.color != color;
}

class _ClearGlyphPainter extends CustomPainter {
  _ClearGlyphPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color.withValues(alpha: 0.18);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      fill,
    );
    final stroke = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;
    final inset = size.width * 0.3;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _ClearGlyphPainter old) => old.color != color;
}
