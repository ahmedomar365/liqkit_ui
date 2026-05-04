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
      };
      final isLightSurface =
          surface == SnippetFrameSurface.light ||
          surface == SnippetFrameSurface.liquidLight ||
          (surface == SnippetFrameSurface.themed &&
              brightness == Brightness.light);
      final themedChild = switch (surface) {
        SnippetFrameSurface.light || SnippetFrameSurface.liquidLight =>
          LiqTheme(data: LiqThemeData.light, child: child),
        SnippetFrameSurface.dark || SnippetFrameSurface.liquidDark => LiqTheme(
          data: LiqThemeData.dark,
          child: child,
        ),
        _ => child,
      };
      final content = Padding(
        padding: surfacePadding,
        child: Center(child: themedChild),
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
        child: switch (surface) {
          SnippetFrameSurface.liquidLight => _LiquidBackdrop(
            brightness: Brightness.light,
            child: content,
          ),
          SnippetFrameSurface.liquidDark => _LiquidBackdrop(
            brightness: Brightness.dark,
            child: content,
          ),
          _ => content,
        },
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
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111114) : const Color(0xFFEFEFF4),
            ),
          ),
          Positioned(
            left: -28,
            top: -22,
            child: _BackdropPatch(
              color: isDark ? const Color(0xFF1A84FF) : const Color(0xFF2F8DFF),
              size: 150,
            ),
          ),
          Positioned(
            right: -16,
            bottom: -24,
            child: _BackdropPatch(
              color: isDark ? const Color(0xFFFF4F79) : const Color(0xFFFF6B8A),
              size: 160,
            ),
          ),
          Positioned(
            left: 150,
            bottom: 18,
            child: _BackdropPatch(
              color: isDark ? const Color(0xFF32D74B) : const Color(0xFF58D68D),
              size: 112,
            ),
          ),
          ColoredBox(
            color: isDark ? const Color(0x33000000) : const Color(0x24FFFFFF),
          ),
          child,
        ],
      ),
    );
  }
}

class _BackdropPatch extends StatelessWidget {
  const _BackdropPatch({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.72),
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}
