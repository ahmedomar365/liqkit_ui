import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class AnimationsDemoScreen extends ConsumerStatefulWidget {
  const AnimationsDemoScreen({super.key});

  @override
  ConsumerState<AnimationsDemoScreen> createState() =>
      _AnimationsDemoScreenState();
}

class _AnimationsDemoScreenState extends ConsumerState<AnimationsDemoScreen> {
  bool _showMorphChild = true;
  bool _showShimmer = true;
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Animations')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _section(
            title: 'Liquid Flow Animation',
            child: SizedBox(
              height: 200,
              child: LiqFlowAnimation(
                gradientColors: <Color>[
                  context.appleColors.blue.withValues(alpha: 0.3),
                  context.appleColors.purple.withValues(alpha: 0.3),
                  context.appleColors.pink.withValues(alpha: 0.2),
                ],
                child: Center(
                  child: Text(
                    'Liquid Flow',
                    style: context.textStyles.largeTitle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'Morph Transition',
            child: Column(
              children: <Widget>[
                LiqMorphTransition(
                  showFirst: _showMorphChild,
                  firstChild: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: context.appleColors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        LiqIcons.home,
                        size: 48,
                        color: context.appleColors.blue,
                      ),
                    ),
                  ),
                  secondChild: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: context.appleColors.purple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        LiqMaterialIcons.person,
                        size: 48,
                        color: context.appleColors.purple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LiqButton(
                  label: 'Toggle Morph',
                  style: LiqButtonStyle.borderedSecondary,
                  onPressed: () =>
                      setState(() => _showMorphChild = !_showMorphChild),
                ),
              ],
            ),
          ),
          _section(
            title: 'Ripple Effect',
            child: LiqRipple(
              rippleColor: context.appleColors.blue,
              onTap: () => LiqToastOverlay.show(context, 'Ripple tapped!'),
              child: LiqCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Tap anywhere',
                    style: context.textStyles.headline,
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'Bounce Animation',
            child: LiqBounce(
              bounceHeight: 30,
              child: LiqCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Icon(
                    LiqMaterialIcons.sportsBasketball,
                    size: 48,
                    color: context.appleColors.orange,
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'Pulse Animation',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LiqPulse(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: context.appleColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LiqMaterialIcons.favorite,
                      color: Color(0xFFFFFFFF),
                      size: 32,
                    ),
                  ),
                ),
                LiqPulse(
                  minScale: 0.8,
                  maxScale: 1.2,
                  duration: const Duration(seconds: 1),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: context.appleColors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      LiqIcons.check,
                      color: Color(0xFFFFFFFF),
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Shimmer Effect',
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: LiqButton(
                    label: 'Toggle Shimmer',
                    style: LiqButtonStyle.borderedSecondary,
                    onPressed: () =>
                        setState(() => _showShimmer = !_showShimmer),
                  ),
                ),
                const SizedBox(height: 16),
                LiqShimmer(
                  enabled: _showShimmer,
                  child: LiqCard(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Shimmer Effect',
                        style: context.textStyles.headline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Skeleton Loaders',
            child: Column(
              children: <Widget>[
                LiqShimmer(
                  child: LiqCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            LiqSkeleton(
                              width: 60,
                              height: 60,
                              shape: LiqSkeletonShape.circle,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: LiqSkeletonText(lines: 2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const LiqSkeleton(
                          width: double.infinity,
                          height: 80,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const <Widget>[
                            LiqSkeleton(width: 80, height: 28),
                            SizedBox(width: 8),
                            LiqSkeleton(width: 80, height: 28),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Loading Indicator',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const LiqSpinner(),
                    const SizedBox(height: 8),
                    Text('Loading',
                        style: context.textStyles.caption1.secondary),
                  ],
                ),
                Column(
                  children: <Widget>[
                    const LiqSpinner(size: LiqSpinnerSize.small),
                    const SizedBox(height: 8),
                    Text('Small',
                        style: context.textStyles.caption1.secondary),
                  ],
                ),
              ],
            ),
          ),
          _section(
            title: 'Swipe Gestures',
            child: LiqSwipeDetector(
              onSwipeLeft: () => LiqToastOverlay.show(context, 'Swiped Left'),
              onSwipeRight: () => LiqToastOverlay.show(context, 'Swiped Right'),
              onSwipeUp: () => LiqToastOverlay.show(context, 'Swiped Up'),
              onSwipeDown: () => LiqToastOverlay.show(context, 'Swiped Down'),
              child: LiqCard(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(LiqMaterialIcons.swipe,
                          size: 48, color: context.appleColors.gray),
                      const SizedBox(height: 8),
                      Text(
                        'Swipe in any direction',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'Pinch to Zoom',
            child: LiqPinchDetector(
              onScaleUpdate: (scale) =>
                  setState(() => _currentScale = scale),
              child: LiqCard(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(LiqMaterialIcons.zoomIn,
                          size: 48, color: context.appleColors.gray),
                      const SizedBox(height: 8),
                      Text(
                        'Pinch to zoom',
                        style: context.textStyles.body.secondary,
                      ),
                      Text(
                        'Scale: ${(_currentScale * 100).toInt()}%',
                        style: context.textStyles.caption1.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'Long Press',
            child: LiqLongPress(
              onLongPress: () =>
                  LiqToastOverlay.show(context, 'Long press activated!'),
              rippleColor: context.appleColors.purple,
              child: LiqCard(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(LiqMaterialIcons.touchApp,
                          size: 48, color: context.appleColors.gray),
                      const SizedBox(height: 8),
                      Text(
                        'Long press and hold',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'Page Transitions',
            child: Column(
              children: <Widget>[
                _transitionButton(
                  'Fade Transition',
                  () => _push(
                    'Fade',
                    LiqColors.blue,
                    PageRouteBuilder<void>(
                      pageBuilder: (ctx, a, b) => const _TargetScreen(
                        title: 'Fade Transition',
                        color: LiqColors.blue,
                      ),
                      transitionsBuilder: (ctx, a, b, child) =>
                          FadeTransition(opacity: a, child: child),
                      transitionDuration:
                          const Duration(milliseconds: 320),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _transitionButton(
                  'Slide Up Transition',
                  () => _push(
                    'Slide Up',
                    LiqColors.purple,
                    PageRouteBuilder<void>(
                      pageBuilder: (ctx, a, b) => const _TargetScreen(
                        title: 'Slide Up Transition',
                        color: LiqColors.purple,
                      ),
                      transitionsBuilder: (ctx, a, b, child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: a,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      ),
                      transitionDuration:
                          const Duration(milliseconds: 320),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _transitionButton(
                  'Scale Transition',
                  () => _push(
                    'Scale',
                    LiqColors.green,
                    PageRouteBuilder<void>(
                      pageBuilder: (ctx, a, b) => const _TargetScreen(
                        title: 'Scale Transition',
                        color: LiqColors.green,
                      ),
                      transitionsBuilder: (ctx, a, b, child) => ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1).animate(
                          CurvedAnimation(parent: a, curve: Curves.easeOutBack),
                        ),
                        child: FadeTransition(opacity: a, child: child),
                      ),
                      transitionDuration:
                          const Duration(milliseconds: 360),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title2.copyWith(
              fontWeight: LiqAppleTypography.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _transitionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: LiqButton(
        label: label,
        style: LiqButtonStyle.borderedSecondary,
        onPressed: onPressed,
      ),
    );
  }

  void _push(String name, Color color, PageRoute<void> route) {
    Navigator.of(context).push<void>(route);
  }
}

class _TargetScreen extends StatelessWidget {
  const _TargetScreen({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: LiqAppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(LiqMaterialIcons.animation, size: 80, color: color),
            ),
            const SizedBox(height: 24),
            Text(title, style: context.textStyles.title1),
            const SizedBox(height: 16),
            LiqButton(
              label: 'Go Back',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
