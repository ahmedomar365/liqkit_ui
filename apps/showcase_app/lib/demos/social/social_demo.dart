import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/social_home_screen.dart';

class SocialMediaDemo extends StatelessWidget {
  const SocialMediaDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: SocialHomeScreen(),
    );
  }
}