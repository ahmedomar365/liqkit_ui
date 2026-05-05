import 'package:flutter/cupertino.dart' show cupertinoTextSelectionControls;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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
    this.brightness,
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

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

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
  int? _dragSelectionBase;
  Offset? _pointerDownPosition;
  DateTime? _lastPointerDownAt;
  Offset? _lastPointerDownPosition;

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
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textWidth = constraints.maxWidth - (LiqTextField._padding * 2);
          return Container(
            height: LiqTextField._height,
            padding: const EdgeInsets.symmetric(
              horizontal: LiqTextField._padding,
            ),
            decoration: BoxDecoration(
              color: bg,
              border:
                  filled ? Border(bottom: BorderSide(color: separator)) : null,
            ),
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown:
                  widget.enabled && !widget.obscureText
                      ? (event) => _handlePointerDown(
                        event.localPosition,
                        textStyle,
                        textWidth,
                      )
                      : widget.enabled
                      ? (_) => _focusNode.requestFocus()
                      : null,
              onPointerMove:
                  widget.enabled && !widget.obscureText
                      ? (event) => _handlePointerMove(
                        event.localPosition,
                        event.buttons,
                        textStyle,
                        textWidth,
                      )
                      : null,
              onPointerUp: (_) => _endMouseSelection(),
              onPointerCancel: (_) => _endMouseSelection(),
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
                    selectionControls: cupertinoTextSelectionControls,
                    rendererIgnoresPointer: true,
                    inputFormatters: const <TextInputFormatter>[],
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePointerDown(
    Offset localPosition,
    TextStyle style,
    double maxWidth,
  ) {
    final now = DateTime.now();
    final lastAt = _lastPointerDownAt;
    final lastPosition = _lastPointerDownPosition;
    final isDoubleClick =
        lastAt != null &&
        lastPosition != null &&
        now.difference(lastAt) < const Duration(milliseconds: 450) &&
        (localPosition - lastPosition).distance < 16;

    _focusNode.requestFocus();
    _pointerDownPosition = localPosition;
    _dragSelectionBase = null;
    _lastPointerDownAt = now;
    _lastPointerDownPosition = localPosition;

    if (isDoubleClick) {
      _selectWordAt(localPosition, style, maxWidth);
    } else {
      widget.controller.selection = TextSelection.collapsed(
        offset: _textOffsetAt(localPosition, style, maxWidth),
      );
    }
  }

  void _handlePointerMove(
    Offset localPosition,
    int buttons,
    TextStyle style,
    double maxWidth,
  ) {
    if (buttons & kPrimaryMouseButton == 0) return;
    final downPosition = _pointerDownPosition;
    if (downPosition == null) return;
    if (_dragSelectionBase == null) {
      if ((localPosition - downPosition).distance < 2) return;
      _dragSelectionBase = _textOffsetAt(downPosition, style, maxWidth);
    }
    widget.controller.selection = TextSelection(
      baseOffset: _dragSelectionBase!,
      extentOffset: _textOffsetAt(localPosition, style, maxWidth),
    );
  }

  void _endMouseSelection() {
    _dragSelectionBase = null;
    _pointerDownPosition = null;
  }

  void _selectWordAt(Offset localPosition, TextStyle style, double maxWidth) {
    final text = widget.controller.text;
    if (text.isEmpty) return;
    final offset = _textOffsetAt(localPosition, style, maxWidth);
    var start = offset;
    var end = offset;
    if (start == text.length && start > 0) {
      start--;
      end = text.length;
    }
    while (start > 0 && _isWordCodeUnit(text.codeUnitAt(start - 1))) {
      start--;
    }
    while (end < text.length && _isWordCodeUnit(text.codeUnitAt(end))) {
      end++;
    }
    if (start == end) return;
    widget.controller.selection = TextSelection(
      baseOffset: start,
      extentOffset: end,
    );
  }

  int _textOffsetAt(Offset localPosition, TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: widget.controller.text, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout(maxWidth: maxWidth < 0 ? 0 : maxWidth);
    return painter
        .getPositionForOffset(Offset(localPosition.dx, painter.height / 2))
        .offset
        .clamp(0, widget.controller.text.length);
  }

  bool _isWordCodeUnit(int codeUnit) {
    return (codeUnit >= 48 && codeUnit <= 57) ||
        (codeUnit >= 65 && codeUnit <= 90) ||
        (codeUnit >= 97 && codeUnit <= 122) ||
        codeUnit == 95;
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
