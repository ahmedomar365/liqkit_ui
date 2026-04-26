import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Wraps a child and signals readiness to Playwright once the engine
/// has had two consecutive post-frame ticks - required because
/// BackdropFilter save-layers do not finish compositing on the first
/// frame.
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
    SchedulerBinding.instance.scheduleTask(_signalReady, Priority.idle);
  }

  void _signalReady() {
    setReadyFlag();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Sets `window.liqShowcaseReady = true` and dispatches a
/// `liqshowcase:ready` CustomEvent. Implemented in `ready_web.dart`
/// for web; this stub is the no-op fallback used in unit tests.
void setReadyFlag() {
  // Intentional no-op in this bootstrap. The web-specific implementation
  // is registered via conditional import in a future plan.
}
