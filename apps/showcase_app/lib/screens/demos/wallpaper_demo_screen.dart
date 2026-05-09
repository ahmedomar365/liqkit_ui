import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class WallpaperDemoScreen extends ConsumerStatefulWidget {
  const WallpaperDemoScreen({super.key});

  @override
  ConsumerState<WallpaperDemoScreen> createState() =>
      _WallpaperDemoScreenState();
}

class _WallpaperDemoScreenState extends ConsumerState<WallpaperDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Wallpapers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Linear Gradient',
              description: 'Diagonal gradient between two system colors.',
              child: _WallpaperPreview(
                wallpaper: LiqWallpaper(
                  type: LiqWallpaperType.gradient,
                  gradientColors: <Color>[
                    context.appleColors.blue,
                    context.appleColors.purple,
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Multi-Color Gradient',
              description: 'Vertical gradient through three stops.',
              child: _WallpaperPreview(
                wallpaper: LiqWallpaper(
                  type: LiqWallpaperType.gradient,
                  gradientColors: <Color>[
                    context.appleColors.pink,
                    context.appleColors.orange,
                    context.appleColors.yellow,
                  ],
                  gradientStops: const <double>[0.0, 0.5, 1.0],
                  gradientBegin: Alignment.topCenter,
                  gradientEnd: Alignment.bottomCenter,
                ),
              ),
            ),
            _Section(
              title: 'Mesh Gradients',
              description: 'Multi-color blurred mesh.',
              child: Column(
                children: <Widget>[
                  _WallpaperPreview(
                    title: 'Colorful Mesh',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.mesh,
                      gradientColors: <Color>[
                        context.appleColors.blue.withValues(alpha: 0.5),
                        context.appleColors.purple.withValues(alpha: 0.5),
                        context.appleColors.pink.withValues(alpha: 0.5),
                        context.appleColors.orange.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Cool Mesh',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.mesh,
                      gradientColors: <Color>[
                        context.appleColors.blue.withValues(alpha: 0.4),
                        context.appleColors.teal.withValues(alpha: 0.4),
                        context.appleColors.cyan.withValues(alpha: 0.4),
                        context.appleColors.mint.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Patterns',
              description:
                  'Mesh-typed wallpapers used as repeating texture patterns, '
                  'optionally layered over a base gradient.',
              child: Column(
                children: <Widget>[
                  const _WallpaperPreview(
                    title: 'Grid Pattern',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.mesh,
                      blurAmount: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Pattern with Gradient',
                    wallpaper: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        LiqWallpaper(
                          type: LiqWallpaperType.gradient,
                          gradientColors: <Color>[
                            context.appleColors.systemGroupedBackground,
                            context.appleColors.tertiarySystemBackground,
                          ],
                        ),
                        const LiqWallpaper(
                          type: LiqWallpaperType.mesh,
                          opacity: 0.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Dynamic Wallpapers',
              description:
                  'Wallpapers tuned for live blur over a content layer (lock '
                  'screen, control center).',
              child: Column(
                children: <Widget>[
                  const _WallpaperPreview(
                    title: 'Dynamic Blur',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      blurAmount: 10,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Dynamic Gradient',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      gradientColors: <Color>[
                        context.appleColors.blue,
                        context.appleColors.purple,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Animated',
              description:
                  'Wallpapers that animate over time — used for ambient '
                  'backgrounds and Live Photos parallax.',
              child: Column(
                children: <Widget>[
                  const _WallpaperPreview(
                    title: 'Animated Scale',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      gradientColors: <Color>[
                        Color(0xFF007AFF),
                        Color(0xFF00C7BE),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Animated Mesh',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.mesh,
                      gradientColors: <Color>[
                        context.appleColors.purple.withValues(alpha: 0.6),
                        context.appleColors.pink.withValues(alpha: 0.6),
                        context.appleColors.orange.withValues(alpha: 0.6),
                        context.appleColors.yellow.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Custom Configuration',
              description:
                  'A LiqWallpaper assembled with explicit gradient, '
                  'alignment, blur, and opacity overrides.',
              child: _WallpaperPreview(
                title: 'Custom',
                wallpaper: LiqWallpaper(
                  type: LiqWallpaperType.gradient,
                  gradientColors: <Color>[
                    context.appleColors.blue,
                    context.appleColors.purple,
                    context.appleColors.pink,
                  ],
                  blurAmount: 12,
                  opacity: 0.9,
                  gradientBegin: Alignment.topCenter,
                  gradientEnd: Alignment.bottomCenter,
                ),
              ),
            ),
            _Section(
              title: 'Blurred Wallpapers',
              description: 'Same wallpaper components but with stronger blur applied.',
              child: Column(
                children: <Widget>[
                  _WallpaperPreview(
                    title: 'Blurred Gradient',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      gradientColors: <Color>[
                        context.appleColors.red,
                        context.appleColors.orange,
                      ],
                      blurAmount: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Heavy Blur',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.mesh,
                      gradientColors: <Color>[
                        context.appleColors.blue,
                        context.appleColors.green,
                        context.appleColors.yellow,
                        context.appleColors.red,
                      ],
                      blurAmount: 50,
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Presets',
              description: 'Pre-tuned brand-style wallpapers.',
              child: Column(
                children: const <Widget>[
                  _WallpaperPreview(
                    title: 'Blue Gradient',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      gradientColors: <Color>[Color(0xFF0A84FF), Color(0xFF5E5CE6)],
                    ),
                  ),
                  SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Purple Gradient',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      gradientColors: <Color>[Color(0xFFAF52DE), Color(0xFFFF2D55)],
                    ),
                  ),
                  SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Sunset Gradient',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.gradient,
                      gradientColors: <Color>[Color(0xFFFF9500), Color(0xFFFF2D55)],
                    ),
                  ),
                  SizedBox(height: 16),
                  _WallpaperPreview(
                    title: 'Dark Mesh',
                    wallpaper: LiqWallpaper(
                      type: LiqWallpaperType.mesh,
                      gradientColors: <Color>[Color(0xFF1C1C1E), Color(0xFF2C2C2E)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WallpaperPreview extends StatelessWidget {
  const _WallpaperPreview({
    this.title,
    required this.wallpaper,
  });

  final String? title;
  final Widget wallpaper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null) ...<Widget>[
          Text(
            title!,
            style: context.textStyles.footnote.copyWith(
              fontWeight: LiqAppleTypography.semibold,
              color: context.appleColors.gray,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 320,
          decoration: BoxDecoration(
            border: Border.all(color: context.appleColors.separator),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              wallpaper,
              Center(
                child: LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        LiqMaterialIcons.wallpaper,
                        size: 48,
                        color: context.appleColors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sample Content',
                        style: context.textStyles.title3.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is how content looks over the wallpaper',
                        style: context.textStyles.body.secondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
