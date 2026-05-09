import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/news_providers.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Search',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: LiqTextField(
              controller: _searchController,
              prefixIcon: const Icon(LiqIcons.search),
              placeholder: 'Search articles...',
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              suffixIcon: query.isNotEmpty
                  ? LiqIconButton(icon: LiqMaterialIcons.clear,
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    )
                  : null,
            ),
          ),
          Expanded(
            child: query.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          LiqIcons.search,
                          size: 80,
                          color: context.appleColors.tertiaryLabel,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for articles',
                          style: context.textStyles.title2.copyWith(
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Find articles by title, author, or tags',
                          style: context.textStyles.body.secondary,
                        ),
                      ],
                    ),
                  )
                : searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              LiqMaterialIcons.searchOff,
                              size: 80,
                              color: context.appleColors.tertiaryLabel,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: context.textStyles.title2.copyWith(
                                fontWeight: LiqAppleTypography.semibold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching for something else',
                              style: context.textStyles.body.secondary,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final article = searchResults[index];
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
          ),
        ],
      ),
    );
  }
}
