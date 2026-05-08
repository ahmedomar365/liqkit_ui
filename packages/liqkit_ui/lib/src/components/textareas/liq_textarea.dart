import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 multi-line text input.
///
/// Distinct from `LiqTextField` (the single-line pill). Renders a
/// rounded-rectangle surface with a resizable height that grows from
/// [minLines] up to [maxLines] before scrolling.
///
/// Sourced from iOS 26 spec values:
///   - 12pt corner radius, 1pt border #E5E5EA
///   - active border 1.5pt #007AFF
///   - white background, 12pt padding all sides
///   - SF 17pt regular #1C1C1E, line height 1.4
///   - placeholder #C7C7CC
///   - cursor #007AFF, selection #33007AFF
///   - counter SF 12pt #8E8E93, red #FF3B30 when at/over limit
final class LiqTextarea extends StatefulWidget {
  /// Creates a multi-line text input.
  const LiqTextarea({
    this.controller,
    this.value,
    this.onChanged,
    this.placeholder,
    this.minLines = 3,
    this.maxLines = 8,
    this.maxLength,
    this.showCounter = false,
    this.autofocus = false,
    super.key,
  }) : assert(minLines >= 1, 'minLines must be >= 1'),
       assert(maxLines >= minLines, 'maxLines must be >= minLines');

  /// Optional external [TextEditingController]. When null an internal
  /// controller is created from [value].
  final TextEditingController? controller;

  /// Initial value when [controller] is null.
  final String? value;

  /// Called on every character change.
  final ValueChanged<String>? onChanged;

  /// Placeholder text shown when the input is empty.
  final String? placeholder;

  /// Minimum number of visible text lines. The field is at least this
  /// tall. Must be >= 1.
  final int minLines;

  /// Maximum number of visible text lines before the field starts to
  /// scroll internally. Must be >= [minLines].
  final int maxLines;

  /// Optional hard limit on the number of characters that may be typed.
  /// Enforced via a [LengthLimitingTextInputFormatter].
  final int? maxLength;

  /// When true, render an "N / max" counter in the bottom-right corner
  /// of the field. Has no visual effect when [maxLength] is null.
  final bool showCounter;

  /// Whether the field auto-focuses on mount.
  final bool autofocus;

  /// Surface corner radius.
  static const double fieldRadius = 12;

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

  /// Caret color.
  static const Color cursorColor = Color(0xFF007AFF);

  /// Selection-highlight color.
  static const Color selectionColor = Color(0x33007AFF);

  /// Counter color when within the limit.
  static const Color counterColor = Color(0xFF8E8E93);

  /// Counter color when at/over [maxLength].
  static const Color counterOverColor = Color(0xFFFF3B30);

  /// Padding around the editable text.
  static const EdgeInsets contentPadding = EdgeInsets.all(12);

  /// Body text style (SF 17pt regular, line height 1.4).
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    height: 1.4,
    color: textColor,
  );

  /// Counter text style (SF 12pt).
  static const TextStyle counterTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 12,
    color: counterColor,
  );

  /// Top margin between the editor and the counter.
  static const double counterTopMargin = 4;

  @override
  State<LiqTextarea> createState() => _LiqTextareaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('textLength', _externalTextLength()))
      ..add(IntProperty('minLines', minLines))
      ..add(IntProperty('maxLines', maxLines))
      ..add(IntProperty('maxLength', maxLength, defaultValue: null))
      ..add(
        FlagProperty(
          'hasController',
          value: controller != null,
          ifTrue: 'externally controlled',
          ifFalse: 'internal controller',
        ),
      );
  }

  int? _externalTextLength() {
    if (controller != null) return controller!.text.length;
    return value?.length;
  }
}

class _LiqTextareaState extends State<LiqTextarea> {
  TextEditingController? _internalController;
  late final FocusNode _focusNode;
  String _lastEmitted = '';

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.value ?? '');
    }
    _lastEmitted = _controller.text;
    _controller.addListener(_handleControllerChange);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant LiqTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);

    // External controller swapped out from under us.
    if (widget.controller != oldWidget.controller) {
      // Detach the old controller listener.
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleControllerChange,
      );

      if (widget.controller != null) {
        // Switching from internal to external — drop the internal one.
        _internalController?.dispose();
        _internalController = null;
      } else {
        // Switching from external to internal — recreate.
        _internalController = TextEditingController(text: widget.value ?? '');
      }
      _controller.addListener(_handleControllerChange);
      _lastEmitted = _controller.text;
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _internalController)?.removeListener(
      _handleControllerChange,
    );
    _internalController?.dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  void _handleControllerChange() {
    final text = _controller.text;
    if (text != _lastEmitted) {
      _lastEmitted = text;
      widget.onChanged?.call(text);
    } else {
      // Selection-only change still needs a rebuild to refresh the
      // placeholder/counter visibility-by-text path. Counter cares
      // about length, so a length-only check is enough here.
      if (mounted) setState(() {});
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final palette = _TextareaPalette.resolve(context);
    final hasFocus = _focusNode.hasFocus;
    final borderColor = hasFocus ? palette.activeBorder : palette.border;

    final inputFormatters = <TextInputFormatter>[
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(widget.maxLength),
    ];

    final text = _controller.text;

    final editor = CupertinoTextField.borderless(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      padding: EdgeInsets.zero,
      placeholder: widget.placeholder,
      placeholderStyle: LiqTextarea.textStyle.copyWith(
        color: palette.placeholder,
      ),
      style: LiqTextarea.textStyle.copyWith(color: palette.text),
      cursorColor: palette.activeBorder,
      cursorRadius: const Radius.circular(1),
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      inputFormatters: inputFormatters,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );

    Widget counter = const SizedBox.shrink();
    if (widget.showCounter && widget.maxLength != null) {
      final length = text.length;
      final overLimit = length >= widget.maxLength!;
      counter = Padding(
        padding: const EdgeInsets.only(top: LiqTextarea.counterTopMargin),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            '$length / ${widget.maxLength}',
            style: LiqTextarea.counterTextStyle.copyWith(
              color: overLimit ? LiqTextarea.counterOverColor : palette.counter,
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    }

    final field = LiqGlassSurface(
      // Opaque + flat — input fields are solid translucent with no
      // drop shadow (iOS native pattern).
      tint: LiqGlassTint.opaque,
      elevation: LiqGlassElevation.flat,
      baseFill: palette.background,
      rimColor: borderColor,
      borderRadius: BorderRadius.circular(LiqTextarea.fieldRadius),
      padding: LiqTextarea.contentPadding,
      child: editor,
    );

    return Semantics(
      textField: true,
      multiline: true,
      value: _controller.text,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[field, counter],
      ),
    );
  }
}

final class _TextareaPalette {
  const _TextareaPalette({
    required this.background,
    required this.text,
    required this.placeholder,
    required this.border,
    required this.activeBorder,
    required this.counter,
  });

  factory _TextareaPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _TextareaPalette(
        background: LiqTextarea.backgroundColor,
        text: LiqTextarea.textColor,
        placeholder: LiqTextarea.placeholderColor,
        border: LiqTextarea.inactiveBorderColor,
        activeBorder: LiqTextarea.activeBorderColor,
        counter: LiqTextarea.counterColor,
      );
    }

    final secondary = context.liqSecondaryLabelColor;

    return _TextareaPalette(
      background: context.liqSurfaceColor,
      text: context.liqLabelColor,
      placeholder: secondary.withValues(alpha: 0.48),
      border: secondary.withValues(alpha: 0.24),
      activeBorder: context.liqPrimaryColor,
      counter: secondary,
    );
  }

  final Color background;
  final Color text;
  final Color placeholder;
  final Color border;
  final Color activeBorder;
  final Color counter;
}
