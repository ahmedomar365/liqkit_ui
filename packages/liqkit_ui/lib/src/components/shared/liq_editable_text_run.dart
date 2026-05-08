import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Internal text-editing primitive used by every liqkit_ui text input.
///
/// Wraps [EditableText] (from `flutter/widgets`) with the iOS-26
/// chrome a liqkit_ui field needs:
///
///   * a placeholder rendered behind the editor when empty
///   * tap-to-focus
///   * iOS-26 cursor + selection-band colors
///   * no Cupertino-styled selection toolbar / handles (the kit
///     deliberately does not surface the iOS-13-era toolbar)
///
/// This is intentionally NOT a full text-field surface — callers wrap
/// it inside their own padding / glass / rim / suffix-icon rows.
class LiqEditableTextRun extends StatelessWidget {
  /// Creates an editable-text run.
  const LiqEditableTextRun({
    required this.controller,
    required this.focusNode,
    required this.style,
    required this.cursorColor,
    required this.backgroundCursorColor,
    this.placeholder,
    this.placeholderStyle,
    this.selectionColor,
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.cursorRadius = const Radius.circular(2),
    super.key,
  });

  /// Backing controller.
  final TextEditingController controller;

  /// Backing focus node.
  final FocusNode focusNode;

  /// Style used for the rendered text.
  final TextStyle style;

  /// Caret color.
  final Color cursorColor;

  /// Background-cursor color shown in unfocused TextField when scrolled
  /// off-screen (rare but required by EditableText).
  final Color backgroundCursorColor;

  /// Placeholder text shown when the controller is empty.
  final String? placeholder;

  /// Style for the placeholder. Defaults to [style] with reduced opacity.
  final TextStyle? placeholderStyle;

  /// Selection-band color. Defaults to a translucent tint of
  /// [cursorColor].
  final Color? selectionColor;

  /// Minimum visible text lines.
  final int? minLines;

  /// Maximum visible text lines. `1` for a single-line field, larger
  /// values for textareas.
  final int? maxLines;

  /// Input formatters (e.g. length limit).
  final List<TextInputFormatter>? inputFormatters;

  /// Keyboard type. Defaults to text or multiline based on [maxLines].
  final TextInputType? keyboardType;

  /// Action button shown on the keyboard.
  final TextInputAction? textInputAction;

  /// Capitalization preference.
  final TextCapitalization textCapitalization;

  /// Text alignment.
  final TextAlign textAlign;

  /// Whether to focus on first build.
  final bool autofocus;

  /// Whether autocorrect is enabled.
  final bool autocorrect;

  /// Whether IME suggestions are shown.
  final bool enableSuggestions;

  /// Whether to obscure the rendered text (for passwords).
  final bool obscureText;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field accepts user interaction.
  final bool enabled;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits via the keyboard action.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing completes (the field loses focus or the IME
  /// signals done).
  final VoidCallback? onEditingComplete;

  /// Cursor corner radius.
  final Radius cursorRadius;

  @override
  Widget build(BuildContext context) {
    final isMultiline = (maxLines == null) || (maxLines ?? 1) > 1;
    final resolvedKeyboard = keyboardType ??
        (isMultiline ? TextInputType.multiline : TextInputType.text);

    final placeholderWidget = ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (value.text.isNotEmpty || placeholder == null) {
          return const SizedBox.shrink();
        }
        return IgnorePointer(
          child: Text(
            placeholder!,
            style: placeholderStyle ??
                style.copyWith(
                  color: style.color?.withValues(alpha: 0.45),
                ),
            textAlign: textAlign,
            maxLines: isMultiline ? null : 1,
            textDirection: Directionality.of(context),
          ),
        );
      },
    );

    final editor = EditableText(
      controller: controller,
      focusNode: focusNode,
      readOnly: !enabled || readOnly,
      obscureText: obscureText,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      keyboardType: resolvedKeyboard,
      textInputAction: textInputAction,
      style: style,
      cursorColor: cursorColor,
      backgroundCursorColor: backgroundCursorColor,
      cursorRadius: cursorRadius,
      selectionColor: selectionColor ?? cursorColor.withValues(alpha: 0.25),
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled
          ? () {
              if (!focusNode.hasFocus) focusNode.requestFocus();
            }
          : null,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          placeholderWidget,
          editor,
        ],
      ),
    );
  }
}
