import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget motionDefaultBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(maxWidth: 520, height: 260, child: _MotionDemo());
  // {@endhighlight}
}

class _MotionDemo extends StatefulWidget {
  const _MotionDemo();

  @override
  State<_MotionDemo> createState() => _MotionDemoState();
}

class _MotionDemoState extends State<_MotionDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LiqMotion.slow,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _MotionLane(
            label: 'standard',
            duration: '280 ms',
            curve: LiqMotion.standard,
            controller: _controller,
          ),
          const SizedBox(height: 18),
          _MotionLane(
            label: 'snappy',
            duration: '200 ms',
            curve: LiqMotion.snappy,
            controller: _controller,
          ),
          const SizedBox(height: 18),
          _MotionLane(
            label: 'smooth',
            duration: '380 ms',
            curve: LiqMotion.smooth,
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

class _MotionLane extends StatelessWidget {
  const _MotionLane({
    required this.label,
    required this.duration,
    required this.curve,
    required this.controller,
  });

  final String label;
  final String duration;
  final Curve curve;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final theme = LiqTheme.of(context);
    final labelColor = theme.labelColor.resolve(theme.brightness);
    final secondary = theme.secondaryLabelColor.resolve(theme.brightness);
    final trackColor = secondary.withValues(alpha: 0.16);
    final thumbColor = theme.primaryColor.resolve(theme.brightness);

    return Row(
      children: <Widget>[
        SizedBox(
          width: 82,
          child: Text(
            label,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final t = curve.transform(controller.value);
                  final left = (constraints.maxWidth - 46) * t;
                  return SizedBox(
                    height: 32,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Positioned.fill(
                          top: 12,
                          bottom: 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: trackColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(999),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: left,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: thumbColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(999),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: thumbColor.withValues(alpha: 0.22),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const SizedBox(width: 46, height: 24),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 54,
          child: Text(
            duration,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'SF Mono',
              fontSize: 11,
              color: secondary,
            ),
          ),
        ),
      ],
    );
  }
}
