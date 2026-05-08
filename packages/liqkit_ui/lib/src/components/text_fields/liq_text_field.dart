import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Surface variant for [LiqTextField].
enum LiqTextFieldVariant {
  /// Plain row on a transparent surface (no background).
  plain,

  /// Filled row on an iOS system-fill surface with a rounded hairline rim.
  filled,
}

/// iOS 26 single-line text field row.
///
/// Sourced from `native/components/text-fields.css`:
///   - row 52pt tall, 16pt horizontal padding
///   - primary text #000 (light) / #FFF (dark)
///   - placeholder follows secondary-label contrast on filled dark surfaces
///   - cursor accent #0088FF (light) / #0091FF (dark)
///   - rounded system-fill surface with a hairline rim
///
/// Mirrors the Material `TextField` API for the props app developers
/// most commonly need: prefix/suffix icons, label/error text, keyboard
/// type, formatters, max lines, autofocus, focusNode, etc.
final class LiqTextField extends StatefulWidget {
  /// Creates a text field.
  const LiqTextField({
    required this.controller,
    this.placeholder,
    this.labelText,
    this.errorText,
    this.helperText,
    this.variant = LiqTextFieldVariant.filled,
    this.brightness,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.style,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    super.key,
  }) : assert(
         maxLines == null || maxLines > 0,
         'maxLines must be > 0 when provided',
       );

  /// Backing controller.
  final TextEditingController controller;

  /// Placeholder shown when [controller] is empty (a.k.a. hint).
  final String? placeholder;

  /// Optional label rendered above the field.
  final String? labelText;

  /// Optional error message rendered below the field. When non-null the
  /// field also renders a destructive (red) focus ring.
  final String? errorText;

  /// Optional helper message rendered below the field. Suppressed when
  /// [errorText] is non-null.
  final String? helperText;

  /// Surface variant.
  final LiqTextFieldVariant variant;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  /// When false the field rejects focus / typing.
  final bool enabled;

  /// When true, [controller] still drives content but the user can't
  /// modify the text. Useful for "view-only" form rows.
  final bool readOnly;

  /// Whether to mask entered characters (passwords).
  final bool obscureText;

  /// Whether the system spell-checker is enabled.
  final bool autocorrect;

  /// Whether the system word suggestion bar is shown.
  final bool enableSuggestions;

  /// Whether the field auto-focuses when first inserted.
  final bool autofocus;

  /// Maximum visible lines. Default 1. Pass `null` for unbounded.
  final int? maxLines;

  /// Minimum visible lines (multi-line variants).
  final int? minLines;

  /// Optional max length cap. Doesn't render a counter.
  final int? maxLength;

  /// On-screen keyboard type (`emailAddress`, `number`, …).
  final TextInputType? keyboardType;

  /// Return-key action (`done`, `next`, `search`, …).
  final TextInputAction? textInputAction;

  /// Optional input formatters (digit-only, mask, etc.).
  final List<TextInputFormatter>? inputFormatters;

  /// Auto-capitalization rule.
  final TextCapitalization textCapitalization;

  /// Horizontal alignment of the entered text.
  final TextAlign textAlign;

  /// Optional style override for the entered text.
  final TextStyle? style;

  /// Optional external focus node. When `null`, the field manages its
  /// own.
  final FocusNode? focusNode;

  /// Optional widget rendered before the text (icon, glyph).
  final Widget? prefixIcon;

  /// Optional widget rendered after the text (icon, clear button).
  final Widget? suffixIcon;

  /// Optional padding override around the text. Defaults to symmetric
  /// 16pt horizontal.
  final EdgeInsetsGeometry? contentPadding;

  /// Called on every character change.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (Return).
  final ValueChanged<String>? onSubmitted;

  /// Called when an editing session ends (focus loss, submit).
  final VoidCallback? onEditingComplete;

  /// Called when the field is tapped while enabled. Useful for
  /// triggering pickers from a `readOnly: true` field.
  final VoidCallback? onTap;

  static const double _heightSingle = 52;
  static const double _padding = 16;
  static const double _fontSize = 17;
  static const BorderRadius _radius = BorderRadius.all(Radius.circular(14));
  static const Color _accentLight = Color(0xFF0088FF);
  static const Color _accentDark = Color(0xFF0091FF);
  static const Color _primaryLight = Color(0xFF000000);
  static const Color _primaryDark = Color(0xFFFFFFFF);
  static const Color _placeholderLight = Color(0x4D3C3C43);
  static const Color _placeholderDark = Color(0x99EBEBF5);
  static const Color _errorRed = Color(0xFFFF383C);

  @override
  State<LiqTextField> createState() => _LiqTextFieldState();
}

class _LiqTextFieldState extends State<LiqTextField> {
  FocusNode? _internalFocusNode;
  int? _dragSelectionBase;
  Offset? _pointerDownPosition;
  DateTime? _lastPointerDownAt;
  Offset? _lastPointerDownPosition;

  FocusNode get _focusNode =>
      widget.focusNode ??
      (_internalFocusNode ??= FocusNode(
        canRequestFocus: widget.enabled && !widget.readOnly,
      )..addListener(_handleFocus));

  void _handleFocus() => setState(() {});

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_handleFocus);
    }
  }

  @override
  void didUpdateWidget(LiqTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocus);
      widget.focusNode?.addListener(_handleFocus);
    }
    final canFocus = widget.enabled && !widget.readOnly;
    final node = widget.focusNode ?? _internalFocusNode;
    if (node != null && node.canRequestFocus != canFocus) {
      node.canRequestFocus = canFocus;
      if (!canFocus && node.hasFocus) node.unfocus();
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocus);
    _internalFocusNode
      ?..removeListener(_handleFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
    final filled = widget.variant == LiqTextFieldVariant.filled;
    final hasError = widget.errorText != null;
    final focused = _focusNode.hasFocus;
    final multiline = widget.maxLines == null || (widget.maxLines ?? 1) > 1;

    final bg =
        !filled
            ? const Color(0x00000000)
            : (isDark
                ? LiqAppleColors.tertiarySystemFillDark
                : LiqAppleColors.tertiarySystemFill);
    final primary =
        isDark ? LiqTextField._primaryDark : LiqTextField._primaryLight;
    final placeholder =
        isDark ? LiqTextField._placeholderDark : LiqTextField._placeholderLight;
    final rim =
        hasError
            ? LiqTextField._errorRed
            : (focused
                ? (isDark
                    ? LiqTextField._accentDark
                    : LiqTextField._accentLight)
                : (isDark
                    ? LiqAppleColors.separatorDark
                    : LiqAppleColors.separator));
    final accent =
        isDark ? LiqTextField._accentDark : LiqTextField._accentLight;

    final defaultStyle = TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: LiqTextField._fontSize,
      color: widget.enabled ? primary : placeholder,
    );
    final textStyle = (widget.style ?? defaultStyle).copyWith(
      color: widget.enabled ? primary : placeholder,
    );
    final placeholderStyle = textStyle.copyWith(color: placeholder);

    final padding =
        widget.contentPadding ??
        const EdgeInsets.symmetric(horizontal: LiqTextField._padding);

    final fieldHeight = multiline ? null : LiqTextField._heightSingle;

    final field = Semantics(
      textField: true,
      enabled: widget.enabled,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textWidth = constraints.maxWidth - LiqTextField._padding * 2;
          final inner = SizedBox(
            height: fieldHeight,
            child: Padding(
              padding: padding,
              child: Row(
              crossAxisAlignment:
                  multiline
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.prefixIcon != null) ...<Widget>[
                  widget.prefixIcon!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap:
                        widget.enabled
                            ? () {
                              widget.onTap?.call();
                              if (!widget.readOnly) _focusNode.requestFocus();
                            }
                            : null,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown:
                          widget.enabled &&
                                  !widget.obscureText &&
                                  !widget.readOnly
                              ? (event) => _handlePointerDown(
                                event.localPosition,
                                textStyle,
                                textWidth,
                              )
                              : null,
                      onPointerMove:
                          widget.enabled &&
                                  !widget.obscureText &&
                                  !widget.readOnly
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
                              if (value.text.isNotEmpty ||
                                  widget.placeholder == null) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                widget.placeholder!,
                                style: placeholderStyle,
                                maxLines: multiline ? null : 1,
                                textAlign: widget.textAlign,
                              );
                            },
                          ),
                          EditableText(
                            controller: widget.controller,
                            focusNode: _focusNode,
                            readOnly: !widget.enabled || widget.readOnly,
                            obscureText: widget.obscureText,
                            autocorrect: widget.autocorrect,
                            enableSuggestions: widget.enableSuggestions,
                            autofocus: widget.autofocus,
                            maxLines: widget.maxLines,
                            minLines: widget.minLines,
                            textCapitalization: widget.textCapitalization,
                            textAlign: widget.textAlign,
                            keyboardType:
                                widget.keyboardType ??
                                (multiline
                                    ? TextInputType.multiline
                                    : TextInputType.text),
                            textInputAction: widget.textInputAction,
                            style: textStyle,
                            cursorColor: accent,
                            backgroundCursorColor: placeholder,
                            selectionColor: accent.withValues(alpha: 0.25),
                            rendererIgnoresPointer: true,
                            inputFormatters: <TextInputFormatter>[
                              if (widget.maxLength != null)
                                LengthLimitingTextInputFormatter(
                                  widget.maxLength,
                                ),
                              ...?widget.inputFormatters,
                            ],
                            onChanged: widget.onChanged,
                            onSubmitted: widget.onSubmitted,
                            onEditingComplete: widget.onEditingComplete,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.suffixIcon != null) ...<Widget>[
                  const SizedBox(width: 12),
                  widget.suffixIcon!,
                ],
              ],
            ),
            ),
          );
          if (!filled) return inner;
          return LiqGlassSurface(
            // Opaque + flat — input fields render their own placeholder /
            // value text, so the BackdropFilter shader path would sample
            // the surrounding label widgets and bleed them into the
            // field as ghost text. iOS 26's text fields are solid
            // translucent with no drop shadow.
            tint: LiqGlassTint.opaque,
            elevation: LiqGlassElevation.flat,
            borderRadius: LiqTextField._radius,
            padding: EdgeInsets.zero,
            baseFill: bg,
            rimColor: rim,
            child: inner,
          );
        },
      ),
    );

    if (widget.labelText == null &&
        widget.errorText == null &&
        widget.helperText == null) {
      return field;
    }

    final labelStyle = LiqAppleTypography.subheadline(
      isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      fontWeight: LiqAppleTypography.medium,
      color:
          widget.enabled
              ? (isDark ? LiqAppleColors.labelDark : LiqAppleColors.label)
              : placeholder,
    );
    final captionStyle = LiqAppleTypography.caption2(
      isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      color:
          hasError
              ? LiqTextField._errorRed
              : (isDark
                  ? LiqAppleColors.secondaryLabelDark
                  : LiqAppleColors.secondaryLabel),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.labelText != null) ...<Widget>[
          Text(widget.labelText!, style: labelStyle),
          const SizedBox(height: 8),
        ],
        field,
        if (widget.errorText != null || widget.helperText != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            widget.errorText ?? widget.helperText ?? '',
            style: captionStyle,
          ),
        ],
      ],
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
}
