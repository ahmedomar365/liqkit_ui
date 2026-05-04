import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 numeric input — text field with optional ± stepper buttons.
///
/// Useful for quantity inputs (cart items), settings values, and anywhere
/// a number is required. Calls [onChanged] with the parsed value, clamped
/// to `[min, max]`. When the user types something unparseable, [onChanged]
/// is not called until the field reaches a parseable value again.
///
/// Sourced from `native/components/number-fields.css` (iOS 26 spec):
///   - field 44pt height, 10pt corner radius, 1pt border
///   - active border 1.5pt accent #007AFF
///   - 44×44 circular ± buttons flanking the field, 8pt gap
final class LiqNumberField extends StatefulWidget {
  /// Creates a number field.
  const LiqNumberField({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999999,
    this.step = 1,
    this.placeholder,
    this.suffix,
    this.showButtons = true,
    super.key,
  }) : assert(min <= max, 'min must be <= max'),
       assert(step > 0, 'step must be positive');

  /// Current numeric value.
  final num value;

  /// Called whenever the user changes the value, either by tapping the
  /// ± buttons or by typing a parseable number into the field. The
  /// emitted value is clamped to `[min, max]`.
  final ValueChanged<num>? onChanged;

  /// Minimum allowed value (inclusive).
  final num min;

  /// Maximum allowed value (inclusive).
  final num max;

  /// Increment per ± button tap.
  final num step;

  /// Placeholder shown when the field is empty.
  final String? placeholder;

  /// Optional unit label rendered to the right of the value (inside the
  /// field). E.g. ` kg` or ` %`.
  final String? suffix;

  /// When true the `−` and `+` buttons flank the field. When false it's
  /// a plain numeric input.
  final bool showButtons;

  /// Field height.
  static const double fieldHeight = 44;

  /// Field corner radius.
  static const double fieldRadius = 10;

  /// Inactive border thickness.
  static const double inactiveBorderWidth = 1;

  /// Focused border thickness.
  static const double activeBorderWidth = 1.5;

  /// Inactive border color.
  static const Color inactiveBorderColor = Color(0xFFE5E5EA);

  /// Focused border color.
  static const Color activeBorderColor = Color(0xFF007AFF);

  /// Field background color.
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Primary text color.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Placeholder text color.
  static const Color placeholderColor = Color(0xFFC7C7CC);

  /// Suffix label color.
  static const Color suffixColor = Color(0xFF8E8E93);

  /// Stepper button background color.
  static const Color buttonBackgroundColor = Color(0xFFE5E5EA);

  /// Stepper button glyph color.
  static const Color buttonGlyphColor = Color(0xFF1C1C1E);

  /// Stepper button diameter.
  static const double buttonSize = 44;

  /// Spacing between the field and each stepper button.
  static const double buttonSpacing = 8;

  /// Padding to the left of the suffix label.
  static const double suffixSpacing = 6;

  /// Default text style for the typed value.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  /// Text style for the suffix label.
  static const TextStyle suffixTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    color: suffixColor,
  );

  @override
  State<LiqNumberField> createState() => _LiqNumberFieldState();
}

class _LiqNumberFieldState extends State<LiqNumberField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _suppressEmit = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
    _controller.addListener(_handleControllerChange);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant LiqNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final parsed = num.tryParse(_controller.text);
      if (parsed != widget.value) {
        final formatted = _format(widget.value);
        if (_controller.text != formatted) {
          _suppressEmit = true;
          _controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
          _suppressEmit = false;
        }
      }
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerChange)
      ..dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  static String _format(num value) {
    if (value is int) return value.toString();
    if (value == value.truncateToDouble()) return value.toInt().toString();
    return value.toString();
  }

  void _handleControllerChange() {
    if (_suppressEmit) return;
    final text = _controller.text;
    if (text.isEmpty) return;
    final parsed = num.tryParse(text);
    if (parsed == null) return;
    final clamped = _clamp(parsed);
    widget.onChanged?.call(clamped);
  }

  void _handleFocusChange() => setState(() {});

  num _clamp(num n) {
    if (n < widget.min) return widget.min;
    if (n > widget.max) return widget.max;
    return n;
  }

  bool get _canDecrement =>
      widget.onChanged != null && widget.value > widget.min;

  bool get _canIncrement =>
      widget.onChanged != null && widget.value < widget.max;

  void _decrement() {
    if (!_canDecrement) return;
    final next = math.max(widget.min, widget.value - widget.step);
    final clamped = _clamp(next);
    widget.onChanged?.call(clamped);
  }

  void _increment() {
    if (!_canIncrement) return;
    final next = math.min(widget.max, widget.value + widget.step);
    final clamped = _clamp(next);
    widget.onChanged?.call(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final palette = _NumberFieldPalette.resolve(context);
    final hasFocus = _focusNode.hasFocus;
    final borderColor = hasFocus ? palette.activeBorder : palette.border;
    final borderWidth =
        hasFocus
            ? LiqNumberField.activeBorderWidth
            : LiqNumberField.inactiveBorderWidth;

    final inputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
    ];

    final field = Container(
      height: LiqNumberField.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(LiqNumberField.fieldRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown:
            widget.onChanged == null ? null : (_) => _focusNode.requestFocus(),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) {
                      if (value.text.isNotEmpty || widget.placeholder == null) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        widget.placeholder!,
                        style: LiqNumberField.textStyle.copyWith(
                          color: palette.placeholder,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        textDirection: TextDirection.ltr,
                      );
                    },
                  ),
                  EditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: LiqNumberField.textStyle.copyWith(
                      color: palette.text,
                    ),
                    cursorColor: palette.activeBorder,
                    backgroundCursorColor: palette.placeholder,
                    selectionColor: palette.activeBorder.withValues(
                      alpha: 0.25,
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: widget.min < 0,
                    ),
                    inputFormatters: inputFormatters,
                    textAlign: TextAlign.end,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ],
              ),
            ),
            if (widget.suffix != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: LiqNumberField.suffixSpacing,
                ),
                child: Text(
                  widget.suffix!,
                  style: LiqNumberField.suffixTextStyle.copyWith(
                    color: palette.suffix,
                  ),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                ),
              ),
          ],
        ),
      ),
    );

    if (!widget.showButtons) {
      return Semantics(textField: true, value: _controller.text, child: field);
    }

    return Semantics(
      textField: true,
      value: _controller.text,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepperButton(
            icon: Icons.remove,
            enabled: _canDecrement,
            onTap: _canDecrement ? _decrement : null,
            backgroundColor: palette.buttonBackground,
            glyphColor: palette.buttonGlyph,
          ),
          const SizedBox(width: LiqNumberField.buttonSpacing),
          Expanded(child: field),
          const SizedBox(width: LiqNumberField.buttonSpacing),
          _StepperButton(
            icon: Icons.add,
            enabled: _canIncrement,
            onTap: _canIncrement ? _increment : null,
            backgroundColor: palette.buttonBackground,
            glyphColor: palette.buttonGlyph,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<num>('value', widget.value))
      ..add(DiagnosticsProperty<num>('min', widget.min))
      ..add(DiagnosticsProperty<num>('max', widget.max))
      ..add(DiagnosticsProperty<num>('step', widget.step))
      ..add(
        FlagProperty(
          'showButtons',
          value: widget.showButtons,
          ifTrue: 'with buttons',
          ifFalse: 'no buttons',
        ),
      )
      ..add(
        FlagProperty(
          'hasSuffix',
          value: widget.suffix != null,
          ifTrue: 'has suffix',
          ifFalse: 'no suffix',
        ),
      );
  }
}

/// A circular ± button flanking the [LiqNumberField].
class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.backgroundColor,
    required this.glyphColor,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color glyphColor;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: LiqNumberField.buttonSize,
      height: LiqNumberField.buttonSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(
        icon,
        size: 20,
        color: glyphColor,
        textDirection: TextDirection.ltr,
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(opacity: enabled ? 1.0 : 0.4, child: button),
    );
  }
}

final class _NumberFieldPalette {
  const _NumberFieldPalette({
    required this.background,
    required this.text,
    required this.placeholder,
    required this.suffix,
    required this.border,
    required this.activeBorder,
    required this.buttonBackground,
    required this.buttonGlyph,
  });

  factory _NumberFieldPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _NumberFieldPalette(
        background: LiqNumberField.backgroundColor,
        text: LiqNumberField.textColor,
        placeholder: LiqNumberField.placeholderColor,
        suffix: LiqNumberField.suffixColor,
        border: LiqNumberField.inactiveBorderColor,
        activeBorder: LiqNumberField.activeBorderColor,
        buttonBackground: LiqNumberField.buttonBackgroundColor,
        buttonGlyph: LiqNumberField.buttonGlyphColor,
      );
    }

    final label = context.liqLabelColor;
    final secondary = context.liqSecondaryLabelColor;
    final accent = context.liqPrimaryColor;

    return _NumberFieldPalette(
      background: context.liqSurfaceColor,
      text: label,
      placeholder: secondary.withValues(alpha: 0.48),
      suffix: secondary,
      border: secondary.withValues(alpha: 0.24),
      activeBorder: accent,
      buttonBackground: secondary.withValues(alpha: 0.18),
      buttonGlyph: label,
    );
  }

  final Color background;
  final Color text;
  final Color placeholder;
  final Color suffix;
  final Color border;
  final Color activeBorder;
  final Color buttonBackground;
  final Color buttonGlyph;
}
