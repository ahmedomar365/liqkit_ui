import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Demo backdrop used by [SnippetFrame].
enum SnippetFrameSurface {
  /// Do not add a local demo surface.
  none,

  /// Resolve a subtle surface from the active [LiqTheme].
  themed,

  /// Force a light demo surface, useful for components whose documented
  /// variant is explicitly light even when the docs site is in dark mode.
  light,

  /// Force a dark demo surface, useful for explicitly dark variants.
  dark,

  /// Colorful content backdrop for light Liquid Glass demos.
  liquidLight,

  /// Colorful content backdrop for dark Liquid Glass demos.
  liquidDark,

  /// Colorful content backdrop that follows the active theme brightness.
  liquidThemed,
}

/// Centers snippet content while allowing it to shrink on narrow docs
/// viewports.
class SnippetFrame extends StatelessWidget {
  /// Creates a responsive snippet frame.
  const SnippetFrame({
    required this.child,
    this.maxWidth = 320,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.surface = SnippetFrameSurface.none,
    this.surfacePadding = const EdgeInsets.all(16),
    this.surfaceScrimOpacity = 0,
    super.key,
  });

  /// Maximum content width on wide viewports.
  final double maxWidth;

  /// Optional fixed demo height for preview scenes.
  final double? height;

  /// Outer breathing room inside the iframe.
  final EdgeInsetsGeometry padding;

  /// Optional local demo surface behind [child].
  final SnippetFrameSurface surface;

  /// Padding inside [surface] when it is not [SnippetFrameSurface.none].
  final EdgeInsetsGeometry surfacePadding;

  /// Optional dimming layer above the demo backdrop and below [child].
  ///
  /// Use for modal examples such as dialogs and drawers so all overlay
  /// previews share the same scene construction.
  final double surfaceScrimOpacity;

  /// Demo content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var framedChild = child;
    if (surface != SnippetFrameSurface.none) {
      final theme = LiqTheme.maybeOf(context);
      final brightness = theme?.brightness ?? Brightness.light;
      final surfaceColor = switch (surface) {
        SnippetFrameSurface.none => const Color(0x00000000),
        SnippetFrameSurface.themed =>
          brightness == Brightness.dark
              ? const Color(0xFF1C1C1E)
              : const Color(0xFFFFFFFF),
        SnippetFrameSurface.light => const Color(0xFFFFFFFF),
        SnippetFrameSurface.dark => const Color(0xFF1C1C1E),
        SnippetFrameSurface.liquidLight => const Color(0xFFEFEFF4),
        SnippetFrameSurface.liquidDark => const Color(0xFF111114),
        SnippetFrameSurface.liquidThemed =>
          brightness == Brightness.dark
              ? const Color(0xFF111114)
              : const Color(0xFFEFEFF4),
      };
      final isLightSurface =
          surface == SnippetFrameSurface.light ||
          surface == SnippetFrameSurface.liquidLight ||
          (surface == SnippetFrameSurface.liquidThemed &&
              brightness == Brightness.light) ||
          (surface == SnippetFrameSurface.themed &&
              brightness == Brightness.light);
      final themedChild = switch (surface) {
        SnippetFrameSurface.light || SnippetFrameSurface.liquidLight =>
          LiqTheme(data: LiqThemeData.light, child: child),
        SnippetFrameSurface.dark || SnippetFrameSurface.liquidDark => LiqTheme(
          data: LiqThemeData.dark,
          child: child,
        ),
        SnippetFrameSurface.liquidThemed =>
          brightness == Brightness.dark
              ? LiqTheme(data: LiqThemeData.dark, child: child)
              : LiqTheme(data: LiqThemeData.light, child: child),
        _ => child,
      };
      final content = Padding(
        padding: surfacePadding,
        child: Center(child: themedChild),
      );
      final scene = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          switch (surface) {
            SnippetFrameSurface.liquidLight => const _LiquidBackdrop(
              brightness: Brightness.light,
              child: SizedBox.expand(),
            ),
            SnippetFrameSurface.liquidDark => const _LiquidBackdrop(
              brightness: Brightness.dark,
              child: SizedBox.expand(),
            ),
            SnippetFrameSurface.liquidThemed => _LiquidBackdrop(
              brightness: brightness,
              child: const SizedBox.expand(),
            ),
            _ => const SizedBox.expand(),
          },
          if (surfaceScrimOpacity > 0)
            ColoredBox(
              color: const Color(
                0xFF000000,
              ).withValues(alpha: surfaceScrimOpacity.clamp(0, 1)),
            ),
          content,
        ],
      );
      framedChild = DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          border: Border.fromBorderSide(
            BorderSide(
              color:
                  isLightSurface
                      ? const Color(0x1F000000)
                      : const Color(0x29FFFFFF),
            ),
          ),
        ),
        child:
            surfaceScrimOpacity > 0 ||
                    surface == SnippetFrameSurface.liquidLight ||
                    surface == SnippetFrameSurface.liquidDark ||
                    surface == SnippetFrameSurface.liquidThemed
                ? scene
                : content,
      );
    }

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: framedChild,
      ),
    );
    content = Padding(padding: padding, child: content);
    return Align(heightFactor: 1, child: content);
  }
}

/// Theme-aware text used inside snippets that sit on adaptive surfaces.
class SnippetLabel extends StatelessWidget {
  /// Creates snippet label text.
  const SnippetLabel(
    this.text, {
    this.fontSize = 15,
    this.fontWeight,
    super.key,
  });

  /// Label content.
  final String text;

  /// Label font size.
  final double fontSize;

  /// Label font weight.
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final brightness =
        LiqTheme.maybeOf(context)?.brightness ?? Brightness.light;
    final color =
        brightness == Brightness.dark
            ? const Color(0xFFF5F5F7)
            : const Color(0xFF1A1A1A);
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class _LiquidBackdrop extends StatelessWidget {
  const _LiquidBackdrop({required this.brightness, required this.child});

  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF050506) : const Color(0xFFEFF7FF);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: base,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? const <Color>[
                          Color(0xFF10213D),
                          Color(0xFF061120),
                          Color(0xFF050506),
                          Color(0xFF052726),
                        ]
                        : const <Color>[
                          Color(0xFFBFD8FF),
                          Color(0xFFE6F4FF),
                          Color(0xFFDDFCF3),
                          Color(0xFFFFFFFF),
                        ],
                stops: const <double>[0, 0.33, 0.68, 1],
              ),
            ),
          ),
          Positioned(
            left: -120,
            top: -120,
            width: 360,
            height: 360,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors:
                      isDark
                          ? const <Color>[Color(0xAA2F67B1), Color(0x003060A8)]
                          : const <Color>[Color(0xB978A7FF), Color(0x0078A7FF)],
                ),
              ),
            ),
          ),
          Positioned(
            right: -120,
            top: -80,
            width: 380,
            height: 380,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors:
                      isDark
                          ? const <Color>[Color(0x883BC7B4), Color(0x003BC7B4)]
                          : const <Color>[Color(0xAA7CFFF1), Color(0x007CFFF1)],
                ),
              ),
            ),
          ),
          Positioned(
            left: -80,
            right: -80,
            bottom: -150,
            height: 280,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors:
                      isDark
                          ? const <Color>[Color(0xCC000000), Color(0x00000000)]
                          : const <Color>[Color(0x88FFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
          ColoredBox(
            color: isDark ? const Color(0x30000000) : const Color(0x18FFFFFF),
          ),
          child,
        ],
      ),
    );
  }
}
