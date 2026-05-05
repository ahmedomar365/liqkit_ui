import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_quality.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';
import 'package:liqkit_ui/src/theme/liq_theme_data.dart';

/// Shared internal helpers for resolving liqkit theme tokens.
extension LiqThemeResolver on BuildContext {
  /// Whether a liqkit theme exists above this context.
  bool get liqHasTheme => LiqTheme.maybeOf(this) != null;

  /// Nearest liqkit theme, if one exists.
  LiqThemeData? get liqTheme => LiqTheme.maybeOf(this);

  /// Nearest liqkit brightness, defaulting to light when no theme exists.
  Brightness get liqBrightness =>
      LiqTheme.maybeOf(this)?.brightness ?? Brightness.light;

  /// Whether the nearest liqkit theme is dark.
  bool get liqIsDark => liqBrightness == Brightness.dark;

  /// Resolved primary/accent color for the nearest liqkit theme.
  Color get liqPrimaryColor {
    final theme = LiqTheme.maybeOf(this);
    final brightness = theme?.brightness ?? Brightness.light;
    return theme?.primaryColor.resolve(brightness) ?? const Color(0xFF007AFF);
  }

  /// Resolved primary label color for the nearest liqkit theme.
  Color get liqLabelColor {
    final theme = LiqTheme.maybeOf(this);
    final brightness = theme?.brightness ?? Brightness.light;
    return theme?.labelColor.resolve(brightness) ??
        (brightness == Brightness.dark
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF000000));
  }

  /// Resolved secondary label color for the nearest liqkit theme.
  Color get liqSecondaryLabelColor {
    final theme = LiqTheme.maybeOf(this);
    final brightness = theme?.brightness ?? Brightness.light;
    return theme?.secondaryLabelColor.resolve(brightness) ??
        (brightness == Brightness.dark
            ? const Color(0xB2EBEBF5)
            : const Color(0x993C3C43));
  }

  /// Resolved base surface color for the nearest liqkit theme.
  Color get liqSurfaceColor {
    final theme = LiqTheme.maybeOf(this);
    final brightness = theme?.brightness ?? Brightness.light;
    return theme?.surfaceColor.resolve(brightness) ??
        (brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFFFFFFF));
  }

  /// Whether platform accessibility settings request stronger contrast.
  bool get liqHighContrast => MediaQuery.maybeOf(this)?.highContrast ?? false;

  /// Whether platform settings request less animation.
  bool get liqDisableAnimations {
    final theme = LiqTheme.maybeOf(this);
    if (theme?.semantics.respectReduceMotion == false) {
      return false;
    }
    final media = MediaQuery.maybeOf(this);
    return (media?.disableAnimations ?? false) ||
        (media?.accessibleNavigation ?? false);
  }

  /// Returns [duration], or [Duration.zero] when reduced motion is active.
  Duration liqMotionDuration(Duration duration) =>
      liqDisableAnimations ? Duration.zero : duration;

  /// Active glass-rendering quality tier.
  LiqQuality get liqQuality =>
      LiqTheme.maybeOf(this)?.quality ?? LiqQuality.standard;

  /// Whether transparent materials should fall back to opaque surfaces.
  ///
  /// Apple guidance calls out that transparency can adapt for accessibility
  /// and contrast. Flutter exposes high-contrast and animation/navigation
  /// accessibility signals, so liqkit_ui uses those plus the explicit
  /// [LiqQuality.minimal] theme tier as the cross-platform fallback policy.
  bool get liqUseOpaqueMaterials =>
      liqQuality == LiqQuality.minimal || liqHighContrast;
}
