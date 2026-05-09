import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/social_models.dart';
import '../models/social_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Activity',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    LiqMaterialIcons.favoriteOutline,
                    size: 80,
                    color: context.appleColors.tertiaryLabel,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Activity Yet',
                    style: context.textStyles.title2.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "When someone likes or comments on your posts,\nyou'll see it here",
                    style: context.textStyles.body.secondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(notification: notification);
              },
            ),
    );
  }
}

class _NotificationItem extends ConsumerWidget {
  const _NotificationItem({required this.notification});

  final SocialNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiqCard(
        padding: const EdgeInsets.all(16),
        onTap: () {
          ref
              .read(notificationsProvider.notifier)
              .markAsRead(notification.id);
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: LiqColors.grey.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  notification.from.avatarUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      style: context.textStyles.body,
                      children: <InlineSpan>[
                        TextSpan(
                          text: notification.from.username,
                          style: const TextStyle(
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: notification.message,
                          style: TextStyle(
                            color: notification.isRead
                                ? context.appleColors.secondaryLabel
                                : context.appleColors.label,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: context.textStyles.caption1.secondary,
                  ),
                ],
              ),
            ),
            _getNotificationIcon(context, notification.type),
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIcon(BuildContext context, NotificationType type) {
    IconData icon;
    Color color;
    switch (type) {
      case NotificationType.like:
        icon = LiqMaterialIcons.favorite;
        color = context.appleColors.red;
      case NotificationType.comment:
        icon = LiqMaterialIcons.chatBubble;
        color = context.appleColors.blue;
      case NotificationType.follow:
        icon = LiqMaterialIcons.personAdd;
        color = context.appleColors.green;
      case NotificationType.mention:
        icon = LiqMaterialIcons.alternateEmail;
        color = context.appleColors.purple;
      default:
        icon = LiqMaterialIcons.notifications;
        color = context.appleColors.gray;
    }
    return Icon(icon, size: 20, color: color);
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${timestamp.day}/${timestamp.month}';
  }
}
