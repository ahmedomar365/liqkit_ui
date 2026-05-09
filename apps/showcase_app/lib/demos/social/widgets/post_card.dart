import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_models.dart';
import '../models/social_providers.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _PostHeader(post: post),
          
          // Images
          _PostImages(images: post.images, type: post.type),
          
          // Actions
          _PostActions(post: post),
          
          // Likes
          if (post.likes > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${post.likes} likes',
                style: context.textStyles.body.copyWith(
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
            ),
          
          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RichText(
                text: TextSpan(
                  style: context.textStyles.body,
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: const TextStyle(fontWeight: LiqAppleTypography.semibold),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
            ),
          
          // Comments
          if (post.comments > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'View all ${post.comments} comments',
                style: context.textStyles.subheadline.secondary,
              ),
            ),
          
          // Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              _formatTimestamp(post.timestamp),
              style: context.textStyles.caption1.secondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;
  
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: LiqColors.grey.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                post.author.avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.author.username,
                      style: context.textStyles.body.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    if (post.author.isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(
                        LiqMaterialIcons.verified,
                        size: 14,
                        color: context.appleColors.blue,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // More button
          LiqIconButton(
            icon: LiqMaterialIcons.moreHoriz,
            onPressed: () {
              // Show options
            },
          ),
        ],
      ),
    );
  }
}

class _PostImages extends StatelessWidget {
  final List<String> images;
  final PostType type;
  
  const _PostImages({
    required this.images,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (type == PostType.carousel && images.length > 1) {
      // Carousel view
      return SizedBox(
        height: screenWidth,
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              width: screenWidth,
              height: screenWidth,
            );
          },
        ),
      );
    } else {
      // Single image
      return Image.network(
        images.first,
        fit: BoxFit.cover,
        width: screenWidth,
        height: screenWidth,
      );
    }
  }
}

class _PostActions extends ConsumerWidget {
  final Post post;
  
  const _PostActions({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Like button
          LiqIconButton(
            icon: post.isLiked
                ? LiqMaterialIcons.favorite
                : LiqMaterialIcons.favoriteOutline,
            color: post.isLiked ? context.appleColors.red : null,
            onPressed: () {
              ref.read(postsProvider.notifier).toggleLike(post.id);
            },
          ),
          // Comment button
          LiqIconButton(
            icon: LiqMaterialIcons.chatBubbleOutline,
            onPressed: () {
              // Open comments
            },
          ),
          // Share button
          LiqIconButton(
            icon: LiqMaterialIcons.sendOutlined,
            onPressed: () {
              // Share post
            },
          ),
          const Spacer(),
          // Save button
          LiqIconButton(
            icon: post.isSaved
                ? LiqIcons.bookmark
                : LiqMaterialIcons.bookmarkOutline,
            onPressed: () {
              ref.read(postsProvider.notifier).toggleSave(post.id);
            },
          ),
        ],
      ),
    );
  }
}