import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/news_models.dart';
import '../models/news_providers.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingPrefs = ref.watch(readingPreferencesProvider);

    return LiqScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          LiqSliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: LiqFlexibleSpaceBar(
              background: Image.network(article.imageUrl, fit: BoxFit.cover),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (article.isPremium)
                    Container(
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
                            'Premium Article',
                            style: context.textStyles.caption1.copyWith(
                              color: LiqColors.white,
                              fontWeight: LiqAppleTypography.semibold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: context.textStyles.largeTitle.copyWith(
                      color: LiqColors.white,
                      fontWeight: LiqAppleTypography.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              LiqIconButton(
                icon: article.isBookmarked
                    ? LiqIcons.bookmark
                    : LiqMaterialIcons.bookmarkOutline,
                onPressed: () {
                  ref
                      .read(articlesProvider.notifier)
                      .toggleBookmark(article.id);
                },
              ),
              LiqIconButton(icon: LiqIcons.share,
                onPressed: () {
                  ref
                      .read(articlesProvider.notifier)
                      .incrementShares(article.id);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        article.author,
                        style: context.textStyles.body.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_formatDate(article.publishedAt)}',
                        style: context.textStyles.body.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${article.readTime} min read',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(
                        article.source,
                        style: context.textStyles.caption1.secondary,
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Icon(
                            LiqMaterialIcons.visibility,
                            size: 16,
                            color: context.appleColors.tertiaryLabel,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatCount(article.views),
                            style: context.textStyles.caption1.secondary,
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            LiqIcons.share,
                            size: 16,
                            color: context.appleColors.tertiaryLabel,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatCount(article.shares),
                            style: context.textStyles.caption1.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    article.subtitle,
                    style: context.textStyles.title3.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    article.content,
                    style: context.textStyles.body.copyWith(
                      fontSize: readingPrefs.fontSize,
                      height: readingPrefs.lineHeight,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (article.tags.isNotEmpty) ...<Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.appleColors.gray
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '#$tag',
                            style: context.textStyles.caption1.copyWith(
                              color: context.appleColors.blue,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LiqGlassSurface(
        borderRadius: BorderRadius.zero,
        padding: EdgeInsets.zero,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    LiqIconButton(icon: LiqMaterialIcons.textDecrease,
                      onPressed: readingPrefs.fontSize > 12
                          ? () {
                              ref
                                  .read(readingPreferencesProvider.notifier)
                                  .updateFontSize(
                                    readingPrefs.fontSize - 2,
                                  );
                            }
                          : null,
                    ),
                    Text(
                      '${readingPrefs.fontSize.toInt()}',
                      style: context.textStyles.body,
                    ),
                    LiqIconButton(icon: LiqMaterialIcons.textIncrease,
                      onPressed: readingPrefs.fontSize < 24
                          ? () {
                              ref
                                  .read(readingPreferencesProvider.notifier)
                                  .updateFontSize(
                                    readingPrefs.fontSize + 2,
                                  );
                            }
                          : null,
                    ),
                  ],
                ),
                LiqIconButton(
                  icon: readingPrefs.isDarkMode
                      ? LiqMaterialIcons.lightMode
                      : LiqMaterialIcons.darkMode,
                  onPressed: () {
                    ref
                        .read(readingPreferencesProvider.notifier)
                        .toggleDarkMode();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
