import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_extras.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Modal loading panel — translucent glass card with a centered
/// spinner (or determinate ring if [showProgress] is true) plus an
/// optional [message]. Designed to be shown over content.
final class LiqActivityIndicatorView extends StatelessWidget
    with Diagnosticable {
  /// Creates an activity indicator view.
  const LiqActivityIndicatorView({
    this.message,
    this.showProgress = false,
    this.progress = 0,
    super.key,
  });

  /// Show this view as a modal route. Caller is responsible for
  /// dismissing via `Navigator.of(context).pop()`.
  static Future<void> show({
    required BuildContext context,
    String? message,
    bool dismissible = true,
  }) {
    return Navigator.of(context).push<void>(
      _LiqActivityIndicatorRoute(
        message: message,
        dismissible: dismissible,
      ),
    );
  }

  final String? message;
  final bool showProgress;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final messageStyle = LiqAppleTypography.subheadline(brightness);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, minHeight: 160),
      child: LiqGlassSurface(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showProgress)
              LiqCircularProgress(
                value: progress.clamp(0, 1),
                size: 60,
                strokeWidth: 5,
                showPercentage: true,
              )
            else
              const LiqSpinner(size: LiqSpinnerSize.regular),
            if (message != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                message!,
                style: messageStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('message', message))
      ..add(FlagProperty('showProgress',
          value: showProgress, ifTrue: 'progress'))
      ..add(DoubleProperty('progress', progress));
  }
}

class _LiqActivityIndicatorRoute extends ModalRoute<void> {
  _LiqActivityIndicatorRoute({
    required this.message,
    required this.dismissible,
  });

  final String? message;
  final bool dismissible;

  @override
  Color? get barrierColor => const Color(0x66000000);
  @override
  bool get barrierDismissible => dismissible;
  @override
  String? get barrierLabel => 'loading';
  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Center(
      child: FadeTransition(
        opacity: animation,
        child: LiqActivityIndicatorView(message: message),
      ),
    );
  }
}
