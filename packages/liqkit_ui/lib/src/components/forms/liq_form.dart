import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Lightweight form container that propagates [validate]/[reset]/[save]
/// calls down to every [LiqValidatedField] descendant.
///
/// Drop-in replacement for Material's `Form` for the typical "submit
/// button calls `_formKey.currentState?.validate()`" pattern. No
/// `package:flutter/material.dart` dependency.
///
/// ```dart
/// final _formKey = GlobalKey<LiqFormState>();
/// LiqForm(
///   key: _formKey,
///   child: Column(children: [
///     LiqValidatedField<String>(
///       initialValue: '',
///       validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
///       builder: (state) => LiqTextField(
///         onChanged: state.didChange,
///         errorText: state.errorText,
///       ),
///     ),
///     LiqButton(
///       label: 'Submit',
///       onPressed: () {
///         if (_formKey.currentState?.validate() ?? false) … ,
///       },
///     ),
///   ]),
/// )
/// ```
final class LiqForm extends StatefulWidget {
  /// Creates a form.
  const LiqForm({
    required this.child,
    this.autovalidate = false,
    this.onChanged,
    super.key,
  });

  /// Form contents.
  final Widget child;

  /// When true, every field re-runs its validator on every value
  /// change instead of only on explicit `validate()` calls.
  final bool autovalidate;

  /// Optional callback invoked whenever any descendant field's value
  /// changes.
  final VoidCallback? onChanged;

  /// Returns the [LiqFormState] above [context], if any.
  static LiqFormState? maybeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_LiqFormScope>();
    return scope?.state;
  }

  @override
  State<LiqForm> createState() => LiqFormState();
}

/// Public API of a [LiqForm] state — accessible via a
/// `GlobalKey<LiqFormState>`.
class LiqFormState extends State<LiqForm> {
  final Set<_LiqValidatedFieldState<dynamic>> _fields = <_LiqValidatedFieldState<dynamic>>{};

  void _register(_LiqValidatedFieldState<dynamic> field) => _fields.add(field);
  void _unregister(_LiqValidatedFieldState<dynamic> field) => _fields.remove(field);

  void _notifyChanged() {
    widget.onChanged?.call();
    if (widget.autovalidate) {
      for (final field in _fields) {
        field._validate();
      }
    }
  }

  /// Run every descendant field's validator. Returns true iff all
  /// fields pass (i.e. no validator returned a non-null error).
  bool validate() {
    var ok = true;
    for (final field in _fields) {
      if (!field._validate()) ok = false;
    }
    return ok;
  }

  /// Reset every descendant field to its initial value.
  void reset() {
    for (final field in _fields) {
      field._reset();
    }
  }

  /// Run every descendant field's onSaved callback.
  void save() {
    for (final field in _fields) {
      field._save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LiqFormScope(state: this, child: widget.child);
  }
}

class _LiqFormScope extends InheritedWidget {
  const _LiqFormScope({required this.state, required super.child});

  final LiqFormState state;

  @override
  bool updateShouldNotify(_LiqFormScope old) => state != old.state;
}

/// Per-field validator signature: receives the current value and
/// returns null on success or an error message on failure.
typedef LiqValidatedFieldValidator<T> = String? Function(T? value);

/// Per-field setter signature: receives the final value when the
/// surrounding [LiqForm] is saved.
typedef LiqValidatedFieldSetter<T> = void Function(T? value);

/// Per-field builder signature: receives the field's state (containing
/// the current value, error text, and `didChange` to update) and
/// returns the visual.
typedef LiqValidatedFieldBuilder<T> = Widget Function(LiqValidatedFieldData<T> field);

/// Public face of a [LiqValidatedField]'s state passed to the builder.
class LiqValidatedFieldData<T> {
  /// Creates a field-data view (called internally).
  LiqValidatedFieldData._(this._state);

  final _LiqValidatedFieldState<T> _state;

  /// Current value of the field.
  T? get value => _state._value;

  /// Latest validator error text, or null if the field is valid.
  String? get errorText => _state._error;

  /// True when the validator has returned an error and not been cleared.
  bool get hasError => _state._error != null;

  /// Update the field's value. Triggers form-level onChanged and, if
  /// autovalidate is on, re-runs the validator.
  void didChange(T? newValue) => _state._didChange(newValue);
}

/// Validation-aware wrapper around any input widget.
///
/// Pair with [LiqForm] above and call
/// `Form.maybeOf(context)?.validate()` (or use a `GlobalKey<LiqFormState>`)
/// to validate every field in one shot.
final class LiqValidatedField<T> extends StatefulWidget with Diagnosticable {
  /// Creates a form field.
  const LiqValidatedField({
    required this.builder,
    this.initialValue,
    this.validator,
    this.onSaved,
    super.key,
  });

  /// Builder that consumes the field's [LiqValidatedFieldData] and renders
  /// the actual input UI (typically a `LiqTextField`).
  final LiqValidatedFieldBuilder<T> builder;

  /// Starting value.
  final T? initialValue;

  /// Optional validator. Returning null means "valid".
  final LiqValidatedFieldValidator<T>? validator;

  /// Optional save callback fired by `LiqForm.save()`.
  final LiqValidatedFieldSetter<T>? onSaved;

  @override
  State<LiqValidatedField<T>> createState() => _LiqValidatedFieldState<T>();
}

class _LiqValidatedFieldState<T> extends State<LiqValidatedField<T>> {
  T? _value;
  String? _error;
  LiqFormState? _form;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final form = LiqForm.maybeOf(context);
    if (form != _form) {
      _form?._unregister(this);
      _form = form;
      _form?._register(this);
    }
  }

  @override
  void dispose() {
    _form?._unregister(this);
    super.dispose();
  }

  void _didChange(T? value) {
    setState(() {
      _value = value;
      _error = null;
    });
    _form?._notifyChanged();
  }

  bool _validate() {
    final err = widget.validator?.call(_value);
    if (err != _error) {
      setState(() => _error = err);
    }
    return err == null;
  }

  void _reset() {
    setState(() {
      _value = widget.initialValue;
      _error = null;
    });
  }

  void _save() => widget.onSaved?.call(_value);

  @override
  Widget build(BuildContext context) {
    return widget.builder(LiqValidatedFieldData<T>._(this));
  }
}
