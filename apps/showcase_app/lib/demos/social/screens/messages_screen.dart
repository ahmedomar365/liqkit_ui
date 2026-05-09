import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

import '../models/social_models.dart';
import '../models/social_providers.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Messages',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(icon: LiqMaterialIcons.editOutlined,
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return _ChatItem(chat: chat);
        },
      ),
    );
  }
}

class _ChatItem extends ConsumerWidget {
  const _ChatItem({required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = chat.participants.first;
    final hasUnread = chat.unreadCount > 0;

    return GestureDetector(behavior: HitTestBehavior.opaque, 
      onTap: () {
        ref.read(chatsProvider.notifier).markAsRead(chat.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: LiqColors.grey.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: ClipOval(
                child: Image.network(user.avatarUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        user.displayName,
                        style: context.textStyles.body.copyWith(
                          fontWeight: hasUnread
                              ? LiqAppleTypography.semibold
                              : LiqAppleTypography.regular,
                        ),
                      ),
                      Text(
                        _formatTimestamp(chat.lastActivity),
                        style: context.textStyles.caption1.copyWith(
                          color: hasUnread
                              ? context.appleColors.blue
                              : context.appleColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (chat.lastMessage != null)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            chat.lastMessage!.text,
                            style: context.textStyles.subheadline.copyWith(
                              color: hasUnread
                                  ? context.appleColors.label
                                  : context.appleColors.secondaryLabel,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread) ...<Widget>[
                          const SizedBox(width: 8),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.appleColors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                chat.unreadCount.toString(),
                                style: context.textStyles.caption2.copyWith(
                                  color: LiqColors.white,
                                  fontWeight: LiqAppleTypography.semibold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
