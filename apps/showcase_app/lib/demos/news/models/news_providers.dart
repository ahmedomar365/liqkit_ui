import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'news_models.dart';

// Selected category provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

// Articles provider
final articlesProvider = StateNotifierProvider<ArticlesNotifier, List<Article>>((ref) {
  return ArticlesNotifier();
});

class ArticlesNotifier extends StateNotifier<List<Article>> {
  ArticlesNotifier() : super(NewsSampleData.generateArticles());

  void toggleBookmark(String articleId) {
    state = state.map((article) {
      if (article.id == articleId) {
        return article.copyWith(isBookmarked: !article.isBookmarked);
      }
      return article;
    }).toList();
  }

  void incrementViews(String articleId) {
    state = state.map((article) {
      if (article.id == articleId) {
        return article.copyWith(views: article.views + 1);
      }
      return article;
    }).toList();
  }

  void incrementShares(String articleId) {
    state = state.map((article) {
      if (article.id == articleId) {
        return article.copyWith(shares: article.shares + 1);
      }
      return article;
    }).toList();
  }
}

// Filtered articles provider
final filteredArticlesProvider = Provider<List<Article>>((ref) {
  final articles = ref.watch(articlesProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  if (selectedCategory == 'all') {
    return articles;
  } else if (selectedCategory == 'trending') {
    // Return articles sorted by views
    return List<Article>.from(articles)
      ..sort((a, b) => b.views.compareTo(a.views));
  } else {
    return articles.where((article) => article.category == selectedCategory).toList();
  }
});

// Breaking news provider
final breakingNewsProvider = StateProvider<List<BreakingNews>>((ref) {
  return NewsSampleData.generateBreakingNews();
});

// Weather provider
final weatherProvider = StateProvider<WeatherInfo>((ref) {
  return NewsSampleData.generateWeather();
});

// Bookmarked articles provider
final bookmarkedArticlesProvider = Provider<List<Article>>((ref) {
  final articles = ref.watch(articlesProvider);
  return articles.where((article) => article.isBookmarked).toList();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search results provider
final searchResultsProvider = Provider<List<Article>>((ref) {
  final articles = ref.watch(articlesProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  
  if (query.isEmpty) {
    return articles;
  }
  
  return articles.where((article) {
    return article.title.toLowerCase().contains(query) ||
           article.subtitle.toLowerCase().contains(query) ||
           article.author.toLowerCase().contains(query) ||
           article.tags.any((tag) => tag.toLowerCase().contains(query));
  }).toList();
});

// Reading preferences provider
final readingPreferencesProvider = StateNotifierProvider<ReadingPreferencesNotifier, ReadingPreferences>((ref) {
  return ReadingPreferencesNotifier();
});

class ReadingPreferences {
  final double fontSize;
  final String fontFamily;
  final bool isDarkMode;
  final double lineHeight;

  const ReadingPreferences({
    this.fontSize = 16.0,
    this.fontFamily = 'SF Pro Text',
    this.isDarkMode = false,
    this.lineHeight = 1.5,
  });

  ReadingPreferences copyWith({
    double? fontSize,
    String? fontFamily,
    bool? isDarkMode,
    double? lineHeight,
  }) {
    return ReadingPreferences(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }
}

class ReadingPreferencesNotifier extends StateNotifier<ReadingPreferences> {
  ReadingPreferencesNotifier() : super(const ReadingPreferences());

  void updateFontSize(double size) {
    state = state.copyWith(fontSize: size);
  }

  void updateFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void updateLineHeight(double height) {
    state = state.copyWith(lineHeight: height);
  }
}