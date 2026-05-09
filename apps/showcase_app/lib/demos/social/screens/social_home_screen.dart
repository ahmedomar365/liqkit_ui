import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

import '../models/social_providers.dart';
import 'create_post_screen.dart';
import 'explore_screen.dart';
import 'feed_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class SocialHomeScreen extends ConsumerWidget {
  const SocialHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(socialTabIndexProvider);

    final screens = <Widget>[
      const FeedScreen(),
      const ExploreScreen(),
      const CreatePostScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    return LiqScaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: LiqGlassSurface(
        borderRadius: BorderRadius.zero,
        padding: EdgeInsets.zero,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    _NavBarItem(
                      icon: LiqMaterialIcons.homeOutlined,
                      selectedIcon: LiqIcons.home,
                      index: 0,
                      label: 'Home',
                    ),
                    _NavBarItem(
                      icon: LiqMaterialIcons.searchOutlined,
                      selectedIcon: LiqIcons.search,
                      index: 1,
                      label: 'Explore',
                    ),
                    _NavBarItem(
                      icon: LiqMaterialIcons.addBoxOutlined,
                      selectedIcon: LiqMaterialIcons.addBox,
                      index: 2,
                      label: 'Create',
                    ),
                    _NavBarItem(
                      icon: LiqMaterialIcons.favoriteOutline,
                      selectedIcon: LiqMaterialIcons.favorite,
                      index: 3,
                      label: 'Activity',
                    ),
                    _NavBarItem(
                      icon: LiqMaterialIcons.personOutline,
                      selectedIcon: LiqMaterialIcons.person,
                      index: 4,
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

class _NavBarItem extends ConsumerWidget {
  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.index,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final int index;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(socialTabIndexProvider);
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(behavior: HitTestBehavior.opaque, 
        onTap: () {
          ref.read(socialTabIndexProvider.notifier).state = index;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              isSelected ? selectedIcon : icon,
              size: 26,
              color: isSelected
                  ? context.appleColors.label
                  : context.appleColors.tertiaryLabel,
            ),
          ],
        ),
      ),
    );
  }
}
