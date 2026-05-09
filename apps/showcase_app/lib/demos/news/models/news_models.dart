import 'package:flutter/widgets.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

// Article model
class Article {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final String category;
  final int readTime; // in minutes
  final bool isPremium;
  final bool isBookmarked;
  final List<String> tags;
  final String source;
  final int views;
  final int shares;

  const Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.category,
    required this.readTime,
    this.isPremium = false,
    this.isBookmarked = false,
    this.tags = const [],
    this.source = '',
    this.views = 0,
    this.shares = 0,
  });

  Article copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? content,
    String? imageUrl,
    String? author,
    DateTime? publishedAt,
    String? category,
    int? readTime,
    bool? isPremium,
    bool? isBookmarked,
    List<String>? tags,
    String? source,
    int? views,
    int? shares,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      readTime: readTime ?? this.readTime,
      isPremium: isPremium ?? this.isPremium,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      views: views ?? this.views,
      shares: shares ?? this.shares,
    );
  }
}

// Category model
class NewsCategory {
  final String id;
  final String name;
  final IconData icon;
  final String color;

  const NewsCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Breaking news model
class BreakingNews {
  final String id;
  final String title;
  final String tag;
  final DateTime timestamp;
  final String urgency; // high, medium, low

  const BreakingNews({
    required this.id,
    required this.title,
    required this.tag,
    required this.timestamp,
    this.urgency = 'medium',
  });
}

// Weather model for news app
class WeatherInfo {
  final String location;
  final double temperature;
  final String condition;
  final IconData icon;
  final double high;
  final double low;

  const WeatherInfo({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.high,
    required this.low,
  });
}

// Sample data
class NewsSampleData {
  static final List<NewsCategory> categories = [
    const NewsCategory(
      id: 'all',
      name: 'All',
      icon: LiqMaterialIcons.public,
      color: '#007AFF',
    ),
    const NewsCategory(
      id: 'trending',
      name: 'Trending',
      icon: LiqMaterialIcons.trendingUp,
      color: '#FF3B30',
    ),
    const NewsCategory(
      id: 'technology',
      name: 'Technology',
      icon: LiqMaterialIcons.devices,
      color: '#5856D6',
    ),
    const NewsCategory(
      id: 'business',
      name: 'Business',
      icon: LiqMaterialIcons.businessCenter,
      color: '#34C759',
    ),
    const NewsCategory(
      id: 'sports',
      name: 'Sports',
      icon: LiqMaterialIcons.sportsSoccer,
      color: '#FF9500',
    ),
    const NewsCategory(
      id: 'entertainment',
      name: 'Entertainment',
      icon: LiqMaterialIcons.movie,
      color: '#FF2D55',
    ),
    const NewsCategory(
      id: 'science',
      name: 'Science',
      icon: LiqMaterialIcons.science,
      color: '#00C7BE',
    ),
    const NewsCategory(
      id: 'health',
      name: 'Health',
      icon: LiqMaterialIcons.localHospital,
      color: '#30B0C7',
    ),
  ];

  static List<Article> generateArticles() {
    return [
      Article(
        id: '1',
        title: 'Revolutionary AI Breakthrough: New Model Surpasses Human Performance',
        subtitle: 'Scientists achieve unprecedented results in natural language understanding',
        content: _generateLongContent(),
        imageUrl: 'https://picsum.photos/800/600?random=200',
        author: 'Dr. Sarah Johnson',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'technology',
        readTime: 5,
        tags: ['AI', 'Technology', 'Innovation'],
        source: 'Tech Daily',
        views: 15420,
        shares: 234,
      ),
      Article(
        id: '2',
        title: 'Global Markets Rally as Economic Recovery Accelerates',
        subtitle: 'Stock indices reach new heights amid positive economic indicators',
        content: _generateLongContent(),
        imageUrl: 'https://picsum.photos/800/600?random=201',
        author: 'Michael Chen',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        category: 'business',
        readTime: 3,
        isPremium: true,
        tags: ['Markets', 'Economy', 'Finance'],
        source: 'Financial Times',
        views: 8932,
        shares: 156,
      ),
      Article(
        id: '3',
        title: 'Historic Victory: Underdog Team Wins Championship',
        subtitle: 'Against all odds, the team secures their first title in 50 years',
        content: _generateLongContent(),
        imageUrl: 'https://picsum.photos/800/600?random=202',
        author: 'James Williams',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        category: 'sports',
        readTime: 4,
        tags: ['Sports', 'Championship', 'Victory'],
        source: 'Sports Weekly',
        views: 24567,
        shares: 567,
        isBookmarked: true,
      ),
      Article(
        id: '4',
        title: 'New Blockbuster Movie Breaks Box Office Records',
        subtitle: 'Opening weekend surpasses all expectations with record-breaking numbers',
        content: _generateLongContent(),
        imageUrl: 'https://picsum.photos/800/600?random=203',
        author: 'Emma Davis',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'entertainment',
        readTime: 6,
        tags: ['Movies', 'Entertainment', 'Box Office'],
        source: 'Entertainment Today',
        views: 31234,
        shares: 789,
      ),
      Article(
        id: '5',
        title: 'Breakthrough in Cancer Research Offers New Hope',
        subtitle: 'Revolutionary treatment shows promising results in clinical trials',
        content: _generateLongContent(),
        imageUrl: 'https://picsum.photos/800/600?random=204',
        author: 'Dr. Robert Martinez',
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        category: 'health',
        readTime: 7,
        isPremium: true,
        tags: ['Health', 'Medicine', 'Research'],
        source: 'Medical Journal',
        views: 19876,
        shares: 432,
      ),
      Article(
        id: '6',
        title: 'Space Exploration: New Discovery Changes Everything',
        subtitle: 'Astronomers detect signs of potential life on distant exoplanet',
        content: _generateLongContent(),
        imageUrl: 'https://picsum.photos/800/600?random=205',
        author: 'Dr. Lisa Anderson',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'science',
        readTime: 8,
        tags: ['Space', 'Science', 'Discovery'],
        source: 'Science Daily',
        views: 28765,
        shares: 901,
      ),
    ];
  }

  static List<BreakingNews> generateBreakingNews() {
    return [
      BreakingNews(
        id: 'b1',
        title: 'Major earthquake strikes coastal region',
        tag: 'BREAKING',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        urgency: 'high',
      ),
      BreakingNews(
        id: 'b2',
        title: 'Central bank announces interest rate decision',
        tag: 'ECONOMY',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        urgency: 'medium',
      ),
    ];
  }

  static WeatherInfo generateWeather() {
    return const WeatherInfo(
      location: 'San Francisco',
      temperature: 72,
      condition: 'Partly Cloudy',
      icon: LiqMaterialIcons.cloudOutlined,
      high: 78,
      low: 65,
    );
  }

  static String _generateLongContent() {
    return '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet.

At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.

Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.

Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.
''';
  }
}