import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/news_providers.dart';
import '../widgets/article_card.dart';
import '../widgets/breaking_news_banner.dart';
import '../widgets/category_chips.dart';
import '../widgets/weather_widget.dart';
import 'article_detail_screen.dart';
import 'bookmarks_screen.dart';
import 'search_screen.dart';

class NewsHomeScreen extends ConsumerWidget {
  const NewsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(filteredArticlesProvider);
    final breakingNews = ref.watch(breakingNewsProvider);
    final weather = ref.watch(weatherProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Liquid News',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(icon: LiqIcons.search,
            onPressed: () {
              Navigator.push(
                context,
                LiqPageRoute<void>(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          LiqIconButton(icon: LiqMaterialIcons.bookmarkOutline,
            onPressed: () {
              Navigator.push(
                context,
                LiqPageRoute<void>(
                  builder: (context) => const BookmarksScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LiqRefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: <Widget>[
            if (breakingNews.isNotEmpty)
              SliverToBoxAdapter(
                child: BreakingNewsBanner(breakingNews: breakingNews),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WeatherWidget(weather: weather),
              ),
            ),
            const SliverToBoxAdapter(child: CategoryChips()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Top Stories',
                  style: context.textStyles.title2.copyWith(
                    fontWeight: LiqAppleTypography.bold,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final article = articles[index];
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
                childCount: articles.length,
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
