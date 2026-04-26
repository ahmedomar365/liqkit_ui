import 'package:flutter/widgets.dart';

// Conditional imports must use relative URIs - the analyzer evaluates
// the condition at compile time and resolves both branches relative to
// the importing file. Suppress the always_use_package_imports lint here.
// ignore: always_use_package_imports
import 'ready_io.dart' if (dart.library.js_interop) 'ready_web.dart';

/// Wraps a child and signals readiness to Playwright once the engine
/// has had two consecutive post-frame ticks — required because
/// BackdropFilter save-layers do not finish compositing on the first
/// frame.
///
/// We call [setReadyFlag] directly after the second tick rather than
/// deferring it via `SchedulerBinding.scheduleTask(..., Priority.idle)`
/// because routes containing repeating animations (spinners, progress
/// bars, etc.) prevent idle-priority tasks from ever running.
class ShowcaseReadinessGate extends StatefulWidget {
  /// Creates a readiness gate.
  const ShowcaseReadinessGate({required this.child, super.key});

  /// Child to render after readiness is signaled.
  final Widget child;

  @override
  State<ShowcaseReadinessGate> createState() => _ShowcaseReadinessGateState();
}

class _ShowcaseReadinessGateState extends State<ShowcaseReadinessGate> {
  int _ticks = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onFrame);
  }

  void _onFrame(Duration _) {
    _ticks += 1;
    if (_ticks < 2) {
      WidgetsBinding.instance.addPostFrameCallback(_onFrame);
      return;
    }
    setReadyFlag();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
