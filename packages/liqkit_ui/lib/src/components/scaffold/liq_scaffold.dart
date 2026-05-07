import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Material-free scaffold for liqkit_ui apps.
///
/// Replaces Flutter's `Scaffold` with a Liq-styled host. Provides the
/// usual slot anatomy:
///
/// ```text
///  ┌─────────────────────────────────────┐
///  │  appBar (PreferredSizeWidget)       │
///  ├─────────────────────────────────────┤
///  │                                     │
///  │  body                               │
///  │                                     │
///  │  (floatingActionButton overlays here)
///  ├─────────────────────────────────────┤
///  │  bottomNavigationBar                │
///  └─────────────────────────────────────┘
/// ```
///
/// Use with `LiqAppBar` and `LiqBottomNavBar`. For drawers, layer them
/// in a parent [Stack] (or use the `endDrawer` / `drawer` slots).
final class LiqScaffold extends StatelessWidget {
  /// Creates a Liq-styled scaffold.
  const LiqScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonAlignment =
        AlignmentDirectional.bottomEnd,
    this.floatingActionButtonPadding =
        const EdgeInsets.fromLTRB(0, 0, 16, 16),
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  /// Main content area.
  final Widget body;

  /// Optional top navigation bar. Counted toward layout via its
  /// [PreferredSizeWidget.preferredSize].
  final PreferredSizeWidget? appBar;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional floating action button (or any overlay widget) anchored
  /// to [floatingActionButtonAlignment].
  final Widget? floatingActionButton;

  /// Alignment of [floatingActionButton] within the scaffold.
  final AlignmentDirectional floatingActionButtonAlignment;

  /// Padding around [floatingActionButton] before alignment.
  final EdgeInsets floatingActionButtonPadding;

  /// Optional left-side overlay (slides in from leading edge). Layered
  /// above the body; consumer manages open/close state externally.
  final Widget? drawer;

  /// Optional right-side overlay (slides in from trailing edge).
  final Widget? endDrawer;

  /// Background color. Defaults to `LiqAppleColors.systemGroupedBackground`
  /// (light) or solid black (dark).
  final Color? backgroundColor;

  /// When true, [body] is allowed to extend behind [appBar].
  final bool extendBodyBehindAppBar;

  /// When true, [body] is allowed to extend behind [bottomNavigationBar].
  final bool extendBody;

  /// When true (default), [body] resizes when the on-screen keyboard
  /// appears.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final bg = backgroundColor ??
        (isDark
            ? const Color(0xFF000000)
            : LiqAppleColors.systemGroupedBackground);

    final mediaQuery = MediaQuery.of(context);
    final keyboardInset =
        resizeToAvoidBottomInset ? mediaQuery.viewInsets.bottom : 0.0;

    Widget bodySlot = Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: body,
    );

    // FAB and drawers overlay the body via an inner Stack so they don't
    // affect the body's vertical sizing.
    if (floatingActionButton != null ||
        drawer != null ||
        endDrawer != null) {
      bodySlot = Stack(
        children: <Widget>[
          Positioned.fill(child: bodySlot),
          if (floatingActionButton != null)
            Positioned.fill(
              child: SafeArea(
                top: false,
                bottom: false,
                child: Padding(
                  padding: floatingActionButtonPadding,
                  child: Align(
                    alignment: floatingActionButtonAlignment,
                    child: floatingActionButton,
                  ),
                ),
              ),
            ),
          if (drawer != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: drawer,
            ),
          if (endDrawer != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: endDrawer,
            ),
        ],
      );
    }

    // Vertical chrome composition: appBar | body | bottomNav.
    // Using Column gives the body Expanded → bounded height, which is
    // what every viewport-based child (SingleChildScrollView, GridView,
    // PageView) needs in the cross axis. Previously this was a Stack
    // with `Positioned.fill(bottom: null)` which gave unbounded height
    // and crashed any consumer that nested a viewport directly.
    final bool overlayAppBar = extendBodyBehindAppBar && appBar != null;
    final bool overlayBottomNav =
        extendBody && bottomNavigationBar != null;

    Widget chrome = Column(
      children: <Widget>[
        if (appBar != null && !overlayAppBar) appBar!,
        Expanded(child: bodySlot),
        if (bottomNavigationBar != null && !overlayBottomNav)
          bottomNavigationBar!,
      ],
    );

    if (overlayAppBar || overlayBottomNav) {
      chrome = Stack(
        children: <Widget>[
          Positioned.fill(child: chrome),
          if (overlayAppBar)
            Positioned(top: 0, left: 0, right: 0, child: appBar!),
          if (overlayBottomNav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: bottomNavigationBar!,
            ),
        ],
      );
    }

    return ColoredBox(
      color: bg,
      child: SafeArea(
        top: !overlayAppBar,
        bottom: bottomNavigationBar == null && !overlayBottomNav,
        child: chrome,
      ),
    );
  }
}
