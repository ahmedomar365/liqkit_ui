import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/news_providers.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedArticles = ref.watch(bookmarkedArticlesProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Bookmarks',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(
              child: LiqEmptyState(
                icon: Icon(
                  LiqMaterialIcons.bookmarkOutline,
                  size: 48,
                  color: context.appleColors.gray,
                ),
                iconBackground: true,
                title: 'No bookmarks yet',
                description: 'Articles you bookmark will appear here',
                cta: LiqEmptyStateCta(
                  label: 'Browse Articles',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return ArticleCard(
                  article: article,
                  onTap: () {
                    ref
                        .read(articlesProvider.notifier)
                        .incrementViews(article.id);
                    Navigator.push(
                      context,
                      LiqPageRoute<void>(
                        builder: (context) =>
                            ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
