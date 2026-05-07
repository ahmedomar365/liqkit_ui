import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/empty_states/liq_empty_state.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Common semantic types for empty-state placeholders. Each maps to a
/// default glyph + tint via [LiqEmptyStatePresets].
enum LiqEmptyStateType {
  /// No items in a collection (inbox, list, gallery).
  noData,

  /// Operation failed / unrecoverable error.
  error,

  /// Connectivity / offline indicator.
  noConnection,

  /// Search returned zero results.
  noResults,

  /// Caller-provided icon and copy.
  custom,
}

/// Glyph + accent color preset for a [LiqEmptyStateType]. Resolved
/// using only Cupertino-glyph IconData to avoid Material font deps.
@immutable
class LiqEmptyStatePresets {
  const LiqEmptyStatePresets._();

  /// Inbox tray glyph.
  static const IconData noDataIcon = IconData(0xf3a4,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  /// Exclamation mark in triangle.
  static const IconData errorIcon = IconData(0xf42d,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  /// Wifi-slash glyph.
  static const IconData noConnectionIcon = IconData(0xf473,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  /// Magnifying-glass glyph.
  static const IconData noResultsIcon = IconData(0xf4a5,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  /// Default star/sparkles glyph for `custom`.
  static const IconData customIcon = IconData(0xf4ac,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  /// Returns the default icon for [type].
  static IconData iconFor(LiqEmptyStateType type) => switch (type) {
        LiqEmptyStateType.noData => noDataIcon,
        LiqEmptyStateType.error => errorIcon,
        LiqEmptyStateType.noConnection => noConnectionIcon,
        LiqEmptyStateType.noResults => noResultsIcon,
        LiqEmptyStateType.custom => customIcon,
      };

  /// Returns the default accent tint for [type].
  static Color colorFor(LiqEmptyStateType type) => switch (type) {
        LiqEmptyStateType.error => LiqAppleColors.systemRed,
        LiqEmptyStateType.noConnection => LiqAppleColors.systemOrange,
        LiqEmptyStateType.noResults => LiqAppleColors.systemGray,
        _ => LiqAppleColors.systemBlue,
      };
}

/// Builds a [LiqEmptyState] preconfigured for the given [type] —
/// preset icon + tint + composes the standard CTA via
/// [LiqEmptyStateCta].
final class LiqTypedEmptyState extends StatelessWidget with Diagnosticable {
  /// Creates a preset-typed empty state.
  const LiqTypedEmptyState({
    required this.type,
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 60,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// Convenience for no-data state.
  const LiqTypedEmptyState.noData({
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 60,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : type = LiqEmptyStateType.noData;

  /// Convenience for error state.
  const LiqTypedEmptyState.error({
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 60,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : type = LiqEmptyStateType.error;

  /// Convenience for no-connection state.
  const LiqTypedEmptyState.noConnection({
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 60,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : type = LiqEmptyStateType.noConnection;

  /// Convenience for no-results state.
  const LiqTypedEmptyState.noResults({
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 60,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : type = LiqEmptyStateType.noResults;

  final LiqEmptyStateType type;
  final String title;
  final String? description;
  final IconData? icon;
  final double iconSize;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final glyph = icon ?? LiqEmptyStatePresets.iconFor(type);
    final tint = LiqEmptyStatePresets.colorFor(type);
    return LiqEmptyState(
      title: title,
      description: description,
      iconBackground: true,
      icon: Icon(glyph, size: 22, color: tint),
      cta: actionLabel == null
          ? null
          : LiqEmptyStateCta(label: actionLabel!, onPressed: onAction),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqEmptyStateType>('type', type))
      ..add(StringProperty('title', title));
  }
}

/// Compact horizontal empty-state tile — small icon + label, optional
/// tap. Used inline (e.g. inside an empty list cell).
final class LiqCompactEmptyState extends StatelessWidget with Diagnosticable {
  /// Creates a compact empty state.
  const LiqCompactEmptyState({
    required this.icon,
    required this.text,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final textColor = isDark
        ? const Color(0x99EBEBF5)
        : const Color(0x993C3C43);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 32, color: textColor),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: LiqAppleTypography.footnote(brightness)
                  .copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}

/// Larger empty-state placeholder with a custom illustration widget
/// (e.g. animated graphic) instead of a glyph, plus stacked actions.
final class LiqIllustratedEmptyState extends StatelessWidget
    with Diagnosticable {
  /// Creates an illustrated empty state.
  const LiqIllustratedEmptyState({
    required this.illustration,
    required this.title,
    this.subtitle,
    this.actions = const <Widget>[],
    super.key,
  });

  final Widget illustration;
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final subtitleColor = isDark
        ? const Color(0x99EBEBF5)
        : const Color(0x993C3C43);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          illustration,
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: LiqAppleTypography.title2(brightness).copyWith(
              color: titleColor,
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: LiqAppleTypography.body(brightness)
                  .copyWith(color: subtitleColor),
            ),
          ],
          if (actions.isNotEmpty) ...<Widget>[
            const SizedBox(height: 24),
            for (final action in actions) action,
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle));
  }
}

/// Centered loading state with [LiqSpinner] + optional message.
final class LiqLoadingState extends StatelessWidget with Diagnosticable {
  /// Creates a loading state.
  const LiqLoadingState({
    this.message,
    this.size = 40,
    super.key,
  });

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const LiqSpinner(),
          if (message != null) ...<Widget>[
            const SizedBox(height: 16),
            Text(
              message!,
              style: LiqAppleTypography.body(brightness),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
  }
}
