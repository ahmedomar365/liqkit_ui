import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 form-field caption.
///
/// A small, semibold, slightly tinted line of text rendered above an
/// input control such as `LiqTextField` or `LiqCheckbox`. Mark the
/// field as required by passing `required: true` — a red asterisk is
/// appended after the label. Mark the field as optional by passing
/// `optional: true` — a muted " (optional)" suffix is appended in
/// regular weight. The two flags are mutually exclusive.
final class LiqLabel extends StatelessWidget with Diagnosticable {
  /// Creates a form-field label.
  const LiqLabel({
    required this.text,
    this.required = false,
    this.optional = false,
    super.key,
  }) : assert(
         !(required && optional),
         'a label cannot be both required and optional',
       );

  /// Label text shown above the input.
  final String text;

  /// When `true`, a red " *" is appended after [text].
  final bool required;

  /// When `true`, a muted " (optional)" is appended after [text].
  final bool optional;

  /// Default label text style: SF semibold 13pt in iOS primary-label.
  static const TextStyle defaultTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1C1C1E),
  );

  /// Color of the required asterisk.
  static const Color requiredColor = Color(0xFFFF3B30);

  /// Style of the muted " (optional)" suffix.
  static const TextStyle optionalSuffixStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Color(0xFF8E8E93),
  );

  /// Suffix appended when [optional] is `true`.
  static const String optionalSuffix = ' (optional)';

  /// Suffix appended when [required] is `true`.
  static const String requiredSuffix = ' *';

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: defaultTextStyle,
        children: <InlineSpan>[
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: requiredSuffix,
              style: TextStyle(color: requiredColor),
            ),
          if (optional)
            const TextSpan(text: optionalSuffix, style: optionalSuffixStyle),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('textLength', text.length))
      ..add(
        FlagProperty(
          'required',
          value: required,
          ifTrue: 'required',
          ifFalse: 'not required',
        ),
      )
      ..add(
        FlagProperty(
          'optional',
          value: optional,
          ifTrue: 'optional',
          ifFalse: 'not optional',
        ),
      );
  }
}

/// Vertical stack of [LiqLabel] + an input control + optional helper
/// or error text.
///
/// When [errorText] is non-null, [helperText] is hidden and the error
/// is shown in red beneath [child]. When both are `null` the trailing
/// helper/error row is omitted entirely.
final class LiqFormField extends StatelessWidget with Diagnosticable {
  /// Creates a labelled form field.
  const LiqFormField({
    required this.label,
    required this.child,
    this.required = false,
    this.optional = false,
    this.helperText,
    this.errorText,
    this.spacing = 6,
    super.key,
  });

  /// Label text shown above [child].
  final String label;

  /// The input control (e.g. a `LiqTextField`).
  final Widget child;

  /// Forwarded to the inner [LiqLabel].
  final bool required;

  /// Forwarded to the inner [LiqLabel].
  final bool optional;

  /// Optional muted helper text shown below [child]. Hidden when
  /// [errorText] is non-null.
  final String? helperText;

  /// Optional red error text shown below [child]. Takes precedence
  /// over [helperText].
  final String? errorText;

  /// Vertical spacing between the label, [child], and helper/error.
  final double spacing;

  /// Style for [helperText].
  static const TextStyle helperTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF8E8E93),
  );

  /// Style for [errorText].
  static const TextStyle errorTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFF3B30),
  );

  @override
  Widget build(BuildContext context) {
    final hasTrailing = errorText != null || helperText != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LiqLabel(text: label, required: required, optional: optional),
        SizedBox(height: spacing),
        child,
        if (hasTrailing) ...<Widget>[
          SizedBox(height: spacing),
          if (errorText != null)
            Text(
              errorText!,
              style: errorTextStyle,
              textDirection: TextDirection.ltr,
            )
          else
            Text(
              helperText!,
              style: helperTextStyle,
              textDirection: TextDirection.ltr,
            ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('hasHelper', helperText != null))
      ..add(DiagnosticsProperty<bool>('hasError', errorText != null));
  }
}
