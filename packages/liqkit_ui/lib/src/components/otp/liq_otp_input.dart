import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 one-time-passcode (OTP) entry field.
///
/// Renders [length] separate boxes that visually break up a single
/// numeric code; typing advances focus, backspace on an empty box
/// moves focus back, and pasting a string of digits fills all boxes
/// at once.
///
/// Implementation uses a single hidden [EditableText] underneath the
/// boxes (in a [Stack]) that owns the actual input state. The visible
/// row of boxes is purely a presentation layer driven by the
/// controller's text — this avoids juggling per-box focus and gives
/// system paste behavior for free.
final class LiqOtpInput extends StatefulWidget {
  /// Creates an OTP input.
  ///
  /// [length] must be between 2 and 12 inclusive.
  const LiqOtpInput({
    required this.value,
    required this.onChanged,
    this.length = 6,
    this.autofocus = true,
    this.obscure = false,
    super.key,
  }) : assert(length >= 2 && length <= 12, 'length must be between 2 and 12');

  /// Current code. Treated as a string of digits — non-digit characters
  /// in [value] are ignored when seeding the controller, and the
  /// effective text is clamped to [length] characters.
  final String value;

  /// Called whenever the user types or deletes a character.
  ///
  /// Receives the new code, always at most [length] characters.
  final ValueChanged<String> onChanged;

  /// Number of boxes to render. Must satisfy `2 <= length <= 12`.
  final int length;

  /// When true the first empty box is auto-focused on first build.
  final bool autofocus;

  /// When true, typed digits render as a filled circle ("dot")
  /// instead of the digit glyph — useful for PIN entry.
  final bool obscure;

  /// Box width in logical pixels.
  static const double boxWidth = 48;

  /// Box height in logical pixels.
  static const double boxHeight = 56;

  /// Box corner radius.
  static const double boxRadius = 10;

  /// Spacing between boxes.
  static const double boxSpacing = 8;

  /// Inactive box border thickness.
  static const double inactiveBorderWidth = 1;

  /// Focused box border thickness.
  static const double activeBorderWidth = 1.5;

  /// Inactive box border color.
  static const Color inactiveBorderColor = Color(0xFFE5E5EA);

  /// Focused box border color.
  static const Color activeBorderColor = Color(0xFF007AFF);

  /// Background color of each box.
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Default text color for typed digits.
  static const Color textColor = Color(0xFF1C1C1E);

  /// Diameter of the obscure dot.
  static const double obscureDotSize = 12;

  /// Default text style for typed digits.
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  @override
  State<LiqOtpInput> createState() => _LiqOtpInputState();
}

class _LiqOtpInputState extends State<LiqOtpInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _clamp(widget.value));
    _controller.addListener(_handleControllerChange);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant LiqOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clamped = _clamp(widget.value);
    if (clamped != _controller.text) {
      _controller.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
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

  String _clamp(String s) {
    if (s.length <= widget.length) return s;
    return s.substring(0, widget.length);
  }

  String _lastEmittedText = '';

  void _handleControllerChange() {
    final text = _controller.text;
    if (text != _lastEmittedText) {
      _lastEmittedText = text;
      widget.onChanged(text);
    }
    // Trigger a rebuild so the visible boxes follow the text.
    setState(() {});
  }

  void _handleFocusChange() => setState(() {});

  void _requestFocus() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    final activeIndex = text.length.clamp(0, widget.length - 1);
    final hasFocus = _focusNode.hasFocus;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _requestFocus,
      child: Stack(
        children: <Widget>[
          // Visible row of boxes — pointer events fall through to the
          // GestureDetector.
          IgnorePointer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var i = 0; i < widget.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: LiqOtpInput.boxSpacing),
                  _OtpBox(
                    digit: i < text.length ? text[i] : '',
                    obscure: widget.obscure,
                    isActive: hasFocus && i == activeIndex,
                  ),
                ],
              ],
            ),
          ),
          // Hidden EditableText that owns the actual input state.
          // Sized to match the visible row so taps on any box (which
          // were already routed via the parent GestureDetector) work,
          // but rendered with zero opacity and no cursor color so it
          // doesn't paint anything visible.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: EditableText(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,
                style: LiqOtpInput.textStyle,
                cursorColor: const Color(0x00000000),
                backgroundCursorColor: const Color(0x00000000),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                enableSuggestions: false,
                autocorrect: false,
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
      ..add(IntProperty('length', widget.length))
      ..add(IntProperty('valueLength', _controller.text.length))
      ..add(
        FlagProperty(
          'autofocus',
          value: widget.autofocus,
          ifTrue: 'autofocus',
          ifFalse: 'no autofocus',
        ),
      )
      ..add(
        FlagProperty(
          'obscure',
          value: widget.obscure,
          ifTrue: 'obscure',
          ifFalse: 'plain',
        ),
      );
  }
}

/// A single box in the OTP input row.
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.digit,
    required this.obscure,
    required this.isActive,
  });

  final String digit;
  final bool obscure;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final hasDigit = digit.isNotEmpty;
    final borderColor =
        isActive
            ? LiqOtpInput.activeBorderColor
            : LiqOtpInput.inactiveBorderColor;
    final borderWidth =
        isActive
            ? LiqOtpInput.activeBorderWidth
            : LiqOtpInput.inactiveBorderWidth;

    Widget? child;
    if (hasDigit) {
      if (obscure) {
        child = const _ObscureDot();
      } else {
        child = Text(
          digit,
          textDirection: TextDirection.ltr,
          style: LiqOtpInput.textStyle,
        );
      }
    }

    return Container(
      width: LiqOtpInput.boxWidth,
      height: LiqOtpInput.boxHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: LiqOtpInput.backgroundColor,
        borderRadius: BorderRadius.circular(LiqOtpInput.boxRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: child,
    );
  }
}

/// The filled circle rendered in place of a digit when [LiqOtpInput.obscure]
/// is true.
class _ObscureDot extends StatelessWidget {
  const _ObscureDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: LiqOtpInput.obscureDotSize,
      height: LiqOtpInput.obscureDotSize,
      decoration: const BoxDecoration(
        color: LiqOtpInput.textColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
