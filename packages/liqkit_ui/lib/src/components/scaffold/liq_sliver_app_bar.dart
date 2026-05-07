import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/scaffold/liq_app_bar.dart';

/// A scrollable iOS 26 app bar that collapses as the page scrolls.
///
/// Provides the SliverAppBar/FlexibleSpaceBar pattern using only
/// `package:flutter/widgets.dart` primitives — no Material dependency.
///
/// Renders as a [SliverPersistentHeader] whose delegate paints
/// [flexibleSpace] (typically a hero image) while expanded and
/// transitions to a [LiqAppBar]-style title row when collapsed past
/// [collapsedHeight] (or pinned at top when [pinned] is true).
///
/// Common iOS-26 use:
///
/// ```dart
/// CustomScrollView(slivers: [
///   LiqSliverAppBar(
///     expandedHeight: 300,
///     pinned: true,
///     flexibleSpace: Image.network(heroImage, fit: BoxFit.cover),
///     title: const Text('Article'),
///     actions: [LiqIconButton(icon: LiqIcons.share, onPressed: …)],
///   ),
///   // … rest of the page
/// ])
/// ```
final class LiqSliverAppBar extends StatelessWidget with Diagnosticable {
  /// Creates a sliver app bar.
  const LiqSliverAppBar({
    this.title,
    this.leading,
    this.actions = const <Widget>[],
    this.flexibleSpace,
    this.expandedHeight = 200,
    this.collapsedHeight,
    this.pinned = true,
    this.floating = false,
    this.stretch = true,
    this.backgroundColor,
    super.key,
  });

  /// Title rendered in the collapsed bar.
  final Widget? title;

  /// Optional leading widget (typically a back button).
  final Widget? leading;

  /// Trailing actions rendered in the collapsed bar.
  final List<Widget> actions;

  /// Background widget rendered while expanded — typically an image.
  /// When null the expanded area is just the [backgroundColor].
  final Widget? flexibleSpace;

  /// Maximum extent (logical pixels) when fully expanded.
  final double expandedHeight;

  /// Minimum extent when fully collapsed. Defaults to `kLiqAppBarHeight`
  /// (44pt) plus the system status-bar inset.
  final double? collapsedHeight;

  /// When true, the bar pins to the top after collapsing instead of
  /// disappearing.
  final bool pinned;

  /// When true, the bar reappears as soon as the user starts scrolling
  /// up. Has no effect while [pinned] is true.
  final bool floating;

  /// When true, [flexibleSpace] grows past [expandedHeight] when the
  /// user over-scrolls down.
  final bool stretch;

  /// Optional background color override for the collapsed state.
  /// Defaults to the system glass surface.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.of(context).padding.top;
    final minExtent = (collapsedHeight ?? 44) + mediaPadding;
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _LiqSliverAppBarDelegate(
        title: title,
        leading: leading,
        actions: actions,
        flexibleSpace: flexibleSpace,
        maxExtent: expandedHeight,
        minExtent: minExtent,
        backgroundColor: backgroundColor,
        stretch: stretch,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('expandedHeight', expandedHeight))
      ..add(DoubleProperty('collapsedHeight', collapsedHeight))
      ..add(FlagProperty('pinned', value: pinned, ifTrue: 'pinned'))
      ..add(FlagProperty('floating', value: floating, ifTrue: 'floating'))
      ..add(FlagProperty('stretch', value: stretch, ifTrue: 'stretch'));
  }
}

class _LiqSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _LiqSliverAppBarDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.flexibleSpace,
    required this.maxExtent,
    required this.minExtent,
    required this.backgroundColor,
    required this.stretch,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? flexibleSpace;
  @override
  final double maxExtent;
  @override
  final double minExtent;
  final Color? backgroundColor;
  final bool stretch;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // [0, 1] collapse progress: 0 = fully expanded, 1 = fully collapsed.
    final t = shrinkOffset >= (maxExtent - minExtent)
        ? 1.0
        : (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final flexibleHeight = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (flexibleSpace != null)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: flexibleHeight,
            child: ClipRect(
              child: Opacity(
                opacity: 1 - t,
                child: stretch
                    ? OverflowBox(
                        minHeight: 0,
                        maxHeight: double.infinity,
                        alignment: Alignment.topCenter,
                        child: SizedBox(height: flexibleHeight, child: flexibleSpace),
                      )
                    : flexibleSpace,
              ),
            ),
          ),
        // Collapsed bar — fades in as the header shrinks.
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: minExtent,
          child: Opacity(
            opacity: t,
            child: LiqGlassSurface(
              borderRadius: BorderRadius.zero,
              padding: EdgeInsets.zero,
              child: SizedBox.expand(),
            ),
          ),
        ),
        // Title row — visible at any t ≥ 0 but anchored to the bottom of
        // the visible header so it tracks the collapse.
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: minExtent,
          child: SafeArea(
            bottom: false,
            child: LiqAppBar(
              title: title,
              leading: leading,
              actions: actions,
              backgroundColor: const Color(0x00000000),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_LiqSliverAppBarDelegate old) {
    return title != old.title ||
        leading != old.leading ||
        actions != old.actions ||
        flexibleSpace != old.flexibleSpace ||
        maxExtent != old.maxExtent ||
        minExtent != old.minExtent ||
        backgroundColor != old.backgroundColor ||
        stretch != old.stretch;
  }
}

/// Convenience helper for building a [LiqSliverAppBar.flexibleSpace]
/// with an image background and an optional gradient + title overlay.
///
/// This mirrors Material's `FlexibleSpaceBar` for the most common
/// "hero image with title at the bottom" pattern.
final class LiqFlexibleSpaceBar extends StatelessWidget with Diagnosticable {
  /// Creates a flexible space bar.
  const LiqFlexibleSpaceBar({
    this.background,
    this.title,
    this.subtitle,
    this.gradient = true,
    super.key,
  });

  /// Widget rendered behind everything (typically `Image.network(...)`).
  final Widget? background;

  /// Optional title rendered in the bottom-left corner.
  final Widget? title;

  /// Optional subtitle rendered above the title.
  final Widget? subtitle;

  /// When true, paints a top-to-bottom black gradient over [background]
  /// so light text stays readable. Default true.
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (background != null) background!,
        if (gradient)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x00000000),
                  Color(0xB3000000),
                ],
              ),
            ),
          ),
        if (title != null || subtitle != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (subtitle != null) subtitle!,
                if (subtitle != null && title != null)
                  const SizedBox(height: 4),
                if (title != null) title!,
              ],
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('gradient', value: gradient, ifTrue: 'overlay'));
  }
}
