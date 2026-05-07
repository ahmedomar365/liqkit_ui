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

    final appBarHeight = appBar?.preferredSize.height ?? 0;

    final bodyContent = Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: body,
    );

    return ColoredBox(
      color: bg,
      child: SafeArea(
        top: true,
        bottom: bottomNavigationBar == null,
        child: Stack(
          children: <Widget>[
            // Body — positioned to leave room for appBar / bottomNavBar
            // unless extend* flags allow it to bleed under them.
            Positioned.fill(
              top: extendBodyBehindAppBar ? 0 : appBarHeight,
              bottom: extendBody ? 0 : null,
              child: bodyContent,
            ),
            // App bar pinned at the top.
            if (appBar != null)
              Positioned(top: 0, left: 0, right: 0, child: appBar!),
            // Bottom nav pinned at the bottom.
            if (bottomNavigationBar != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: bottomNavigationBar!,
              ),
            // FAB anchored.
            if (floatingActionButton != null)
              Positioned.fill(
                top: appBarHeight,
                child: Padding(
                  padding: floatingActionButtonPadding,
                  child: Align(
                    alignment: floatingActionButtonAlignment,
                    child: floatingActionButton,
                  ),
                ),
              ),
            // Drawer overlays — caller manages open/close.
            if (drawer != null)
              Align(alignment: AlignmentDirectional.centerStart, child: drawer),
            if (endDrawer != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: endDrawer,
              ),
          ],
        ),
      ),
    );
  }
}
