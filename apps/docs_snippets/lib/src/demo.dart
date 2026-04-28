import 'package:flutter/widgets.dart';

/// Tiny stateful wrapper used by interactive snippet builders.
///
/// Most liqkit_ui inputs are uncontrolled-friendly: they take a `value`
/// + an `onChanged` callback. To make snippets *actually* interactive
/// inside the docs iframe (so a slider drags, a toggle flips, a
/// segmented control switches), we hoist a small piece of state next
/// to the widget under demo:
///
/// ```dart
/// LiqDemo<double>(
///   initial: 0.4,
///   builder: (v, set) => LiqSlider(value: v, onChanged: set),
/// );
/// ```
///
/// `set` is a `ValueChanged<T>` ready to drop into the widget's
/// `onChanged:` slot. The snippet generator extracts the body between
/// `// {@highlight}` markers, so the highlighted code shows the
/// LiqSlider construction and not this wrapper.
class LiqDemo<T> extends StatefulWidget {
  /// Creates a demo with [initial] state and the given [builder].
  const LiqDemo({required this.initial, required this.builder, super.key});

  /// The starting value.
  final T initial;

  /// Called every rebuild with the current value and a setter.
  final Widget Function(T value, ValueChanged<T> set) builder;

  @override
  State<LiqDemo<T>> createState() => _LiqDemoState<T>();
}

class _LiqDemoState<T> extends State<LiqDemo<T>> {
  late T _value = widget.initial;

  @override
  Widget build(BuildContext context) =>
      widget.builder(_value, (v) => setState(() => _value = v));
}
