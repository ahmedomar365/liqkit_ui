import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/alerts/liq_alert.dart';
import 'package:liqkit_ui/src/components/text_fields/liq_text_field.dart';

/// iOS-style alert with a single text input and validation.
///
/// Resolves to the entered string when the confirm action is tapped
/// (and validation passes), or `null` when cancelled or dismissed.
final class LiqTextInputDialog extends StatefulWidget with Diagnosticable {
  /// Creates a text input dialog.
  const LiqTextInputDialog({
    required this.title,
    this.description,
    this.placeholder,
    this.initialValue,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    super.key,
  });

  /// Convenience to push the dialog as a modal route.
  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? description,
    String? placeholder,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Navigator.of(context).push<String>(
      _LiqTextInputDialogRoute(
        title: title,
        description: description,
        placeholder: placeholder,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  /// Bold title.
  final String title;

  /// Optional description.
  final String? description;

  /// Field placeholder.
  final String? placeholder;

  /// Initial field value.
  final String? initialValue;

  /// Confirm button label.
  final String confirmText;

  /// Cancel button label.
  final String cancelText;

  /// Whether to obscure the input (passwords).
  final bool obscureText;

  /// Optional keyboard type for the field.
  final TextInputType? keyboardType;

  /// Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional validator. Returning a non-null string blocks confirm and
  /// shows the message inline.
  final String? Function(String?)? validator;

  @override
  State<LiqTextInputDialog> createState() => _LiqTextInputDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('placeholder', placeholder))
      ..add(FlagProperty('obscureText', value: obscureText, ifTrue: 'obscured'))
      ..add(
        FlagProperty(
          'hasValidator',
          value: validator != null,
          ifTrue: 'with validator',
        ),
      );
  }
}

class _LiqTextInputDialogState extends State<LiqTextInputDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final value = _controller.text;
    final validator = widget.validator;
    if (validator != null) {
      final error = validator(value);
      if (error != null) {
        setState(() => _errorText = error);
        return;
      }
    }
    Navigator.of(context).pop(value);
  }

  void _handleCancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xFFFF383C);
    return LiqAlert(
      title: widget.title,
      description: widget.description,
      layout: LiqAlertActionLayout.sideBySide,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LiqTextField(
            controller: _controller,
            placeholder: widget.placeholder,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            autofocus: true,
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
            onSubmitted: (_) => _handleConfirm(),
          ),
          if (_errorText != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                fontSize: 13,
                color: errorColor,
              ),
            ),
          ],
        ],
      ),
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: widget.cancelText,
          onPressed: _handleCancel,
        ),
        LiqAlertAction(
          label: widget.confirmText,
          style: LiqAlertActionStyle.filled,
          onPressed: _handleConfirm,
        ),
      ],
    );
  }
}

class _LiqTextInputDialogRoute extends ModalRoute<String> {
  _LiqTextInputDialogRoute({
    required this.title,
    this.description,
    this.placeholder,
    this.initialValue,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final String title;
  final String? description;
  final String? placeholder;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Color? get barrierColor => const Color(0x80000000);
  @override
  bool get barrierDismissible => false;
  @override
  String? get barrierLabel => 'text input dialog';
  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: Center(
          child: LiqTextInputDialog(
            title: title,
            description: description,
            placeholder: placeholder,
            initialValue: initialValue,
            confirmText: confirmText,
            cancelText: cancelText,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
          ),
        ),
      ),
    );
  }
}
