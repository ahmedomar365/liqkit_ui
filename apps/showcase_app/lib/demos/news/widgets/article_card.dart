import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/news_models.dart';
import '../models/news_providers.dart';

class ArticleCard extends ConsumerWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiqCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    article.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                if (article.isPremium)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: context.appleColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            LiqIcons.star,
                            size: 14,
                            color: LiqColors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Premium',
                            style: context.textStyles.caption1.copyWith(
                              color: LiqColors.white,
                              fontWeight: LiqAppleTypography.semibold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(articlesProvider.notifier)
                          .toggleBookmark(article.id);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: LiqColors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        article.isBookmarked
                            ? LiqIcons.bookmark
                            : LiqMaterialIcons.bookmarkOutline,
                        color: LiqColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              context.appleColors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: context.textStyles.caption2.copyWith(
                            color: context.appleColors.blue,
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        LiqMaterialIcons.accessTime,
                        size: 14,
                        color: context.appleColors.tertiaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.readTime} min read',
                        style: context.textStyles.caption1.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: context.textStyles.headline.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.subtitle,
                    style: context.textStyles.subheadline.secondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Text(
                        article.author,
                        style: context.textStyles.caption1.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_formatDate(article.publishedAt)}',
                        style: context.textStyles.caption1.secondary,
                      ),
                      const Spacer(),
                      if (article.views > 0) ...<Widget>[
                        Icon(
                          LiqMaterialIcons.visibility,
                          size: 14,
                          color: context.appleColors.tertiaryLabel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatCount(article.views),
                          style: context.textStyles.caption1.secondary,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
