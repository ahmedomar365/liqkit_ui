import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Surface variant for [LiqTextField].
enum LiqTextFieldVariant {
  /// Plain row on a transparent surface (no background).
  plain,

  /// Filled row on the canonical light background (#FFFFFF) with a
  /// hairline bottom separator.
  filled,
}

/// iOS 26 single-line text field row.
///
/// Sourced from `native/components/text-fields.css`:
///   - row 52pt tall, 16pt horizontal padding
///   - primary text #000 (light) / #FFF (dark)
///   - placeholder rgba(60,60,67,0.3) / rgba(235,235,245,0.3)
///   - cursor accent #0088FF (light) / #0091FF (dark)
///   - separator #D8D8DC (light) / #1A1A1A (dark)
final class LiqTextField extends StatefulWidget {
  /// Creates a text field.
  const LiqTextField({
    required this.controller,
    this.placeholder,
    this.variant = LiqTextFieldVariant.filled,
    this.brightness = Brightness.light,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// Backing controller.
  final TextEditingController controller;

  /// Placeholder text shown when [controller] is empty.
  final String? placeholder;

  /// Surface variant.
  final LiqTextFieldVariant variant;

  /// Surface brightness.
  final Brightness brightness;

  /// When false the field rejects focus / typing.
  final bool enabled;

  /// Whether to mask entered characters.
  final bool obscureText;

  /// Called on every character change.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (Return).
  final ValueChanged<String>? onSubmitted;

  static const double _height = 52;
  static const double _padding = 16;
  static const double _fontSize = 17;
  static const Color _accentLight = Color(0xFF0088FF);
  static const Color _accentDark = Color(0xFF0091FF);
  static const Color _primaryLight = Color(0xFF000000);
  static const Color _primaryDark = Color(0xFFFFFFFF);
  static const Color _placeholderLight = Color(0x4D3C3C43);
  static const Color _placeholderDark = Color(0x4DEBEBF5);
  static const Color _separatorLight = Color(0xFFD8D8DC);
  static const Color _separatorDark = Color(0xFF1A1A1A);
  static const Color _bgLight = Color(0xFFFFFFFF);
  static const Color _bgDark = Color(0xFF1C1C1E);

  @override
  State<LiqTextField> createState() => _LiqTextFieldState();
}

class _LiqTextFieldState extends State<LiqTextField> {
  late final FocusNode _focusNode = FocusNode(canRequestFocus: widget.enabled)
    ..addListener(_handleFocus);

  void _handleFocus() => setState(() {});

  @override
  void didUpdateWidget(LiqTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      _focusNode.canRequestFocus = widget.enabled;
      if (!widget.enabled && _focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.brightness == Brightness.dark;
    final filled = widget.variant == LiqTextFieldVariant.filled;
    final bg =
        !filled
            ? const Color(0x00000000)
            : (isDark ? LiqTextField._bgDark : LiqTextField._bgLight);
    final primary =
        isDark ? LiqTextField._primaryDark : LiqTextField._primaryLight;
    final placeholder =
        isDark ? LiqTextField._placeholderDark : LiqTextField._placeholderLight;
    final separator =
        isDark ? LiqTextField._separatorDark : LiqTextField._separatorLight;
    final accent =
        isDark ? LiqTextField._accentDark : LiqTextField._accentLight;

    final textStyle = TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: LiqTextField._fontSize,
      letterSpacing: -0.43,
      color: widget.enabled ? primary : placeholder,
    );
    final placeholderStyle = textStyle.copyWith(color: placeholder);

    return Semantics(
      textField: true,
      enabled: widget.enabled,
      child: Container(
        height: LiqTextField._height,
        padding: const EdgeInsets.symmetric(horizontal: LiqTextField._padding),
        decoration: BoxDecoration(
          color: bg,
          border: filled ? Border(bottom: BorderSide(color: separator)) : null,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? _focusNode.requestFocus : null,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.controller,
                builder: (context, value, _) {
                  if (value.text.isNotEmpty || widget.placeholder == null) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    widget.placeholder!,
                    style: placeholderStyle,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
              EditableText(
                controller: widget.controller,
                focusNode: _focusNode,
                readOnly: !widget.enabled,
                obscureText: widget.obscureText,
                style: textStyle,
                cursorColor: accent,
                backgroundCursorColor: placeholder,
                selectionColor: accent.withValues(alpha: 0.25),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('placeholder', widget.placeholder))
      ..add(EnumProperty<LiqTextFieldVariant>('variant', widget.variant))
      ..add(EnumProperty<Brightness>('brightness', widget.brightness))
      ..add(
        FlagProperty(
          'enabled',
          value: widget.enabled,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}
