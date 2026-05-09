/// Canonical notification variants — banners, toasts, notification cards,
/// and badges. Single source of truth for the showcase app and the
/// liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/badges/liq_badge.dart';
import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/cards/liq_card.dart';
import 'package:liqkit_ui/src/components/notifications/liq_banner.dart';
import 'package:liqkit_ui/src/components/toasts/liq_toast.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

void _toast(BuildContext c, String message) =>
    LiqToastOverlay.show(c, message);

const _styleNames = <LiqBannerStyle, String>{
  LiqBannerStyle.info: 'Info',
  LiqBannerStyle.success: 'Success',
  LiqBannerStyle.warning: 'Warning',
  LiqBannerStyle.error: 'Error',
  LiqBannerStyle.custom: 'Custom',
};

/// Inline banners shown above page content. One per style with close + actions.
final class NotificationBannersAllStylesExample extends StatelessWidget {
  const NotificationBannersAllStylesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final entry in _styleNames.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LiqBanner(
              title: entry.value,
              body: 'Style preview for ${entry.value.toLowerCase()}',
              style: entry.key,
              tintColor: entry.key == LiqBannerStyle.custom
                  ? context.appleColors.purple
                  : null,
              onClose: () => _toast(context, 'Banner closed'),
              actions: <Widget>[
                LiqButton(
                  label: 'View',
                  style: LiqButtonStyle.borderless,
                  size: LiqButtonSize.small,
                  onPressed: () => _toast(context, 'View tapped'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Same `LiqBanner` with each option axis toggled.
final class NotificationBannerConfigurationsExample extends StatelessWidget {
  const NotificationBannerConfigurationsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const LiqBanner(
          title: 'Default',
          body: 'Title + body, no close, no icon, no actions.',
        ),
        const SizedBox(height: 12),
        LiqBanner(
          title: 'With Close',
          body: 'Pass an onClose callback to show the X button.',
          onClose: () => _toast(context, 'Closed'),
        ),
        const SizedBox(height: 12),
        LiqBanner(
          title: 'With Actions',
          body: 'Inline button actions on the right.',
          actions: <Widget>[
            LiqButton(
              label: 'Cancel',
              style: LiqButtonStyle.borderless,
              size: LiqButtonSize.small,
              onPressed: () => _toast(context, 'Cancel'),
            ),
            LiqButton(
              label: 'Confirm',
              size: LiqButtonSize.small,
              onPressed: () => _toast(context, 'Confirm'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const LiqBanner(title: 'Title Only', style: LiqBannerStyle.success),
        const SizedBox(height: 12),
        LiqBanner(
          title: 'Custom Tint',
          body: 'tintColor lets you pick any system color.',
          style: LiqBannerStyle.custom,
          tintColor: context.appleColors.purple,
          onClose: () => _toast(context, 'Closed'),
        ),
      ],
    );
  }
}

/// Brief floating messages that auto-dismiss.
final class NotificationToastVariantsExample extends StatelessWidget {
  const NotificationToastVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        LiqButton(
          label: 'Info',
          leadingIcon: LiqMaterialIcons.infoOutline,
          onPressed: () => LiqToastOverlay.show(
            context,
            'Information saved',
            icon: LiqMaterialIcons.infoOutline,
          ),
        ),
        LiqButton(
          label: 'Success',
          leadingIcon: LiqMaterialIcons.checkCircleOutline,
          onPressed: () => LiqToastOverlay.show(
            context,
            'Action completed',
            variant: LiqToastVariant.success,
            icon: LiqMaterialIcons.checkCircleOutline,
          ),
        ),
        LiqButton(
          label: 'Error',
          leadingIcon: LiqMaterialIcons.errorOutline,
          onPressed: () => LiqToastOverlay.show(
            context,
            'Operation failed',
            variant: LiqToastVariant.error,
            icon: LiqMaterialIcons.errorOutline,
          ),
        ),
        LiqButton(
          label: 'No Icon',
          style: LiqButtonStyle.borderedSecondary,
          onPressed: () => LiqToastOverlay.show(
            context,
            'Plain message — no icon',
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.icon,
    required this.isRead,
    this.onTap,
    this.onReply,
    this.onArchive,
  });

  final String title;
  final String subtitle;
  final String body;
  final IconData icon;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onReply;
  final VoidCallback? onArchive;

  @override
  Widget build(BuildContext context) {
    final palette = context.appleColors;
    return LiqCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28, color: palette.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      title,
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    if (!isRead) ...<Widget>[
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: palette.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(subtitle, style: context.textStyles.subheadline.secondary),
                const SizedBox(height: 6),
                Text(body, style: context.textStyles.body),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    LiqButton(
                      label: 'Reply',
                      style: LiqButtonStyle.borderless,
                      size: LiqButtonSize.small,
                      onPressed: onReply,
                    ),
                    const SizedBox(width: 8),
                    LiqButton(
                      label: 'Archive',
                      style: LiqButtonStyle.borderless,
                      size: LiqButtonSize.small,
                      onPressed: onArchive,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _kSampleNotifications = <({
  String title,
  String subtitle,
  String body,
  IconData icon,
  bool isRead,
})>[
  (
    title: 'New Message',
    subtitle: 'John Doe',
    body: 'Hey! Are you available for a quick call?',
    icon: LiqMaterialIcons.person,
    isRead: false,
  ),
  (
    title: 'Software Update',
    subtitle: 'iOS 17.2',
    body: 'A new software update is available for your device',
    icon: LiqMaterialIcons.systemUpdate,
    isRead: false,
  ),
  (
    title: 'Reminder',
    subtitle: 'Meeting at 3 PM',
    body: "Don't forget about your team meeting today",
    icon: LiqMaterialIcons.calendarToday,
    isRead: true,
  ),
];

/// Rich in-app notification cards with title, subtitle, body, and inline actions.
final class NotificationCardsExample extends StatelessWidget {
  const NotificationCardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final n in _kSampleNotifications)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _NotificationCard(
              title: n.title,
              subtitle: n.subtitle,
              body: n.body,
              icon: n.icon,
              isRead: n.isRead,
              onTap: () => _toast(context, '${n.title} tapped'),
              onReply: () => _toast(context, 'Reply tapped'),
              onArchive: () => _toast(context, 'Archive tapped'),
            ),
          ),
      ],
    );
  }
}

class _BadgeLabel extends StatelessWidget {
  const _BadgeLabel({required this.label, required this.badge});

  final String label;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 90,
          child: Text(label, style: context.textStyles.footnote.secondary),
        ),
        badge,
      ],
    );
  }
}

/// Every `LiqBadgeVariant` value rendered with a sample count.
final class NotificationBadgesAllVariantsExample extends StatelessWidget {
  const NotificationBadgesAllVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        _BadgeLabel(
          label: 'Neutral',
          badge: LiqBadge(count: 3, variant: LiqBadgeVariant.neutral),
        ),
        _BadgeLabel(
          label: 'Primary',
          badge: LiqBadge(count: 7, variant: LiqBadgeVariant.primary),
        ),
        _BadgeLabel(
          label: 'Success',
          badge: LiqBadge(count: 12, variant: LiqBadgeVariant.success),
        ),
        _BadgeLabel(
          label: 'Warning',
          badge: LiqBadge(count: 24, variant: LiqBadgeVariant.warning),
        ),
        _BadgeLabel(
          label: 'Destructive',
          badge: LiqBadge(count: 99, variant: LiqBadgeVariant.destructive),
        ),
        _BadgeLabel(
          label: '99+',
          badge: LiqBadge(count: 250, variant: LiqBadgeVariant.destructive),
        ),
      ],
    );
  }
}

/// Badges anchored to icons, app tiles, and inline rows.
final class NotificationBadgesCommonAnchorsExample extends StatelessWidget {
  const NotificationBadgesCommonAnchorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.appleColors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                LiqIcons.message,
                color: Color(0xFFFFFFFF),
                size: 40,
              ),
            ),
            const Positioned(
              top: -6,
              right: -6,
              child:
                  LiqBadge(count: 5, variant: LiqBadgeVariant.destructive),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Icon(
              LiqMaterialIcons.inbox,
              size: 32,
              color: context.appleColors.label,
            ),
            const Positioned(
              top: -6,
              right: -8,
              child: LiqBadge(
                count: 12,
                variant: LiqBadgeVariant.destructive,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: context.appleColors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                LiqMaterialIcons.notifications,
                color: context.appleColors.label,
              ),
              const SizedBox(width: 12),
              const Text('Notifications'),
              const SizedBox(width: 12),
              const LiqBadge(
                count: 99,
                variant: LiqBadgeVariant.destructive,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
