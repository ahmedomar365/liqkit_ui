import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/news_home_screen.dart';

class NewsDemo extends StatelessWidget {
  const NewsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: NewsHomeScreen(),
    );
  }
}