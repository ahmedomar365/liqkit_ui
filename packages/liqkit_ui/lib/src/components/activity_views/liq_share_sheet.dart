import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/activity_views/liq_activity_sheet.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Single tappable item rendered inside a [LiqShareSheet] grid row.
@immutable
class LiqShareActivity {
  /// Creates a share-sheet activity tile.
  const LiqShareActivity({
    required this.title,
    required this.icon,
    this.onTap,
    this.color,
    this.iconColor = const Color(0xFFFFFFFF),
  });

  /// Caption rendered below the tile.
  final String title;

  /// Glyph rendered inside the squircle.
  final IconData icon;

  /// Tap callback. When null, the tile is rendered disabled.
  final VoidCallback? onTap;

  /// Background fill of the tile. Defaults to system-blue.
  final Color? color;

  /// Glyph color. Defaults to white.
  final Color iconColor;
}

/// iOS-style share sheet — a translucent panel anchored at the bottom
/// with optional [title] / [message] header, a horizontal scroll of
/// [systemActivities] (the "Mail / Message / AirDrop" row), and a
/// vertical list of [applicationActivities] (the "Save Image / Add to
/// Reading List" row).
final class LiqShareSheet extends StatelessWidget with Diagnosticable {
  /// Creates a share sheet.
  const LiqShareSheet({
    this.title,
    this.message,
    this.systemActivities = const <LiqShareActivity>[],
    this.applicationActivities = const <LiqShareActivity>[],
    super.key,
  });

  /// Show this share sheet as a modal bottom-anchored route. Returns
  /// when dismissed.
  static Future<void> show({
    required BuildContext context,
    String? title,
    String? message,
    List<LiqShareActivity> systemActivities = const <LiqShareActivity>[],
    List<LiqShareActivity> applicationActivities =
        const <LiqShareActivity>[],
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<void>(
      _LiqShareSheetRoute(
        title: title,
        message: message,
        systemActivities: systemActivities,
        applicationActivities: applicationActivities,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  final String? title;
  final String? message;
  final List<LiqShareActivity> systemActivities;
  final List<LiqShareActivity> applicationActivities;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final captionStyle = LiqAppleTypography.caption2(brightness).copyWith(
      color: isDark
          ? const Color(0x99EBEBF5)
          : const Color(0x993C3C43),
    );
    final titleStyle = LiqAppleTypography.headline(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    final messageStyle = LiqAppleTypography.subheadline(brightness)
        .copyWith(color: captionStyle.color);
    return LiqActivitySheet(
      width: 402,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null || message != null) ...<Widget>[
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
              ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: messageStyle,
                ),
              ),
          ],
          if (systemActivities.isNotEmpty)
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: systemActivities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    _ActivityTile(activity: systemActivities[index],
                        captionStyle: captionStyle),
              ),
            ),
          if (systemActivities.isNotEmpty &&
              applicationActivities.isNotEmpty)
            const SizedBox(height: 8),
          if (applicationActivities.isNotEmpty)
            DecoratedBox(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0x4D767680)
                    : const Color(0x33767680),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var i = 0;
                      i < applicationActivities.length;
                      i++) ...<Widget>[
                    if (i > 0)
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: isDark
                            ? const Color(0x1AEBEBF5)
                            : const Color(0x1A3C3C43),
                      ),
                    _ApplicationRow(
                      activity: applicationActivities[i],
                      brightness: brightness,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(IntProperty('systemActivities', systemActivities.length))
      ..add(IntProperty('applicationActivities', applicationActivities.length));
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.captionStyle,
  });

  final LiqShareActivity activity;
  final TextStyle captionStyle;

  @override
  Widget build(BuildContext context) {
    final disabled = activity.onTap == null;
    final fill = activity.color ?? LiqAppleColors.systemBlue;
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: activity.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                activity.icon,
                size: 30,
                color: activity.iconColor,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 76,
              child: Text(
                activity.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: captionStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationRow extends StatelessWidget {
  const _ApplicationRow({
    required this.activity,
    required this.brightness,
  });

  final LiqShareActivity activity;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final disabled = activity.onTap == null;
    final labelColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: activity.onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  activity.title,
                  style: LiqAppleTypography.body(brightness).copyWith(
                    color: labelColor,
                  ),
                ),
              ),
              Icon(activity.icon, color: labelColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiqShareSheetRoute extends ModalRoute<void> {
  _LiqShareSheetRoute({
    required this.title,
    required this.message,
    required this.systemActivities,
    required this.applicationActivities,
    bool barrierDismissible = true,
  }) : _barrierDismissible = barrierDismissible;

  final String? title;
  final String? message;
  final List<LiqShareActivity> systemActivities;
  final List<LiqShareActivity> applicationActivities;
  final bool _barrierDismissible;

  @override
  Color? get barrierColor => const Color(0x66000000);
  @override
  bool get barrierDismissible => _barrierDismissible;
  @override
  String? get barrierLabel => 'share sheet';
  @override
  bool get opaque => false;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 240);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LiqShareSheet(
              title: title,
              message: message,
              systemActivities: systemActivities,
              applicationActivities: applicationActivities,
            ),
          ),
        ),
      ),
    );
  }
}
