import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../core/theme/liquid_theme.dart';
import '../demos/ecommerce/ecommerce_demo.dart';
import '../demos/news/news_demo.dart';
import '../demos/social/social_demo.dart';
import '../demos/travel/travel_demo.dart';
import '../demos/wallet/wallet_demo.dart';
import 'component_catalog_screen.dart';
import 'settings_screen.dart';
import 'showcase_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = LiqTheme.of(context).brightness == Brightness.dark;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Liquid UI Kit',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(
            icon: isDarkMode ? LiqMaterialIcons.lightMode : LiqMaterialIcons.darkMode,
            onPressed: () {
              ref.read(liquidThemeProvider.notifier).toggleTheme();
            },
            semanticLabel: 'Toggle Theme',
          ),
          LiqIconButton(
            icon: LiqIcons.settings,
            onPressed: () {
              Navigator.of(context).push(
                LiqPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            semanticLabel: 'Settings',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              context.appleColors.blue.withValues(alpha: 0.1),
              context.appleColors.purple.withValues(alpha: 0.1),
              context.appleColors.pink.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Welcome section
                LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  context.appleColors.blue,
                                  context.appleColors.purple,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              LiqMaterialIcons.autoAwesome,
                              color: LiqColors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Welcome to Liquid UI Kit',
                                  style: context.textStyles.title2.copyWith(
                                    fontWeight: LiqAppleTypography.bold,
                                  ),
                                ),
                                Text(
                                  'Beautiful iOS-style components with liquid glass effects',
                                  style: context.textStyles.subheadline.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Experience the future of UI design with our comprehensive collection of '
                        'Flutter components featuring stunning liquid glass effects, real-time blur, '
                        'and smooth animations.',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text('Explore Components', style: context.textStyles.title2.bold),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.dashboard,
                  iconGradient: <Color>[
                    context.appleColors.blue,
                    context.appleColors.cyan,
                  ],
                  title: 'Complete Showcase',
                  subtitle: 'View all components in one scrollable page',
                  features: const <String>[
                    'All components in one place',
                    'Interactive demonstrations',
                    'Live state management',
                    'Theme switching',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const ShowcaseScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.gridView,
                  iconGradient: <Color>[
                    context.appleColors.purple,
                    context.appleColors.pink,
                  ],
                  title: 'Component Catalog',
                  subtitle: 'Browse components by category',
                  features: const <String>[
                    'Organized by category',
                    'Detailed component views',
                    'Search functionality',
                    'Code examples',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const ComponentCatalogScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Demo Apps', style: context.textStyles.title2.bold),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.accountBalanceWallet,
                  iconGradient: <Color>[
                    context.appleColors.indigo,
                    context.appleColors.purple,
                  ],
                  title: 'eWallet Demo',
                  subtitle: 'Digital wallet with liquid glass banking UI',
                  features: const <String>[
                    'Payment cards',
                    'Transactions',
                    'Bills & payments',
                    'Savings goals',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const WalletDemo(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.shoppingBag,
                  iconGradient: <Color>[
                    context.appleColors.orange,
                    context.appleColors.pink,
                  ],
                  title: 'E-commerce Demo',
                  subtitle: 'Complete shopping experience with liquid glass UI',
                  features: const <String>[
                    'Product catalog',
                    'Shopping cart',
                    'Checkout flow',
                    'Order tracking',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const EcommerceDemo(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.chatBubble,
                  iconGradient: <Color>[
                    context.appleColors.purple,
                    context.appleColors.pink,
                  ],
                  title: 'Social Media Demo',
                  subtitle: 'Instagram-style app with liquid glass UI',
                  features: const <String>[
                    'Photo feed',
                    'Stories',
                    'Messaging',
                    'Notifications',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const SocialMediaDemo(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.newspaper,
                  iconGradient: <Color>[
                    context.appleColors.blue,
                    context.appleColors.cyan,
                  ],
                  title: 'News Demo',
                  subtitle: 'Modern news app with liquid glass reading experience',
                  features: const <String>[
                    'Article cards',
                    'Categories',
                    'Reading mode',
                    'Bookmarks',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const NewsDemo(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  icon: LiqMaterialIcons.flight,
                  iconGradient: <Color>[
                    context.appleColors.green,
                    context.appleColors.teal,
                  ],
                  title: 'Travel Demo',
                  subtitle: 'Explore destinations with liquid glass booking flow',
                  features: const <String>[
                    'Destinations',
                    'Search & filters',
                    'Booking flow',
                    'Packages',
                  ],
                  onTap: () => Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) => const TravelDemo(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Key Features', style: context.textStyles.title2.bold),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _FeatureCard(
                        icon: LiqMaterialIcons.blurOn,
                        color: context.appleColors.blue,
                        title: 'Real-time Blur',
                        description: 'Dynamic background blur effects',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _FeatureCard(
                        icon: LiqMaterialIcons.animation,
                        color: context.appleColors.purple,
                        title: 'Smooth Animations',
                        description: 'Fluid 60fps animations',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _FeatureCard(
                        icon: LiqMaterialIcons.darkMode,
                        color: context.appleColors.orange,
                        title: 'Dark Mode',
                        description: 'Full dark mode support',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _FeatureCard(
                        icon: LiqMaterialIcons.devices,
                        color: context.appleColors.green,
                        title: 'Multi-platform',
                        description: 'iOS, Android, Web, Desktop',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        child: _StatItem(
                          value: '50+',
                          label: 'Components',
                          color: context.appleColors.blue,
                        ),
                      ),
                      Flexible(
                        child: _StatItem(
                          value: '100+',
                          label: 'Variants',
                          color: context.appleColors.purple,
                        ),
                      ),
                      Flexible(
                        child: _StatItem(
                          value: '5',
                          label: 'Platforms',
                          color: context.appleColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.onTap,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final List<String> features;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      onTap: onTap,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: iconGradient),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: LiqColors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: context.textStyles.subheadline.secondary,
                    ),
                  ],
                ),
              ),
              Icon(
                LiqMaterialIcons.arrowForwardIos,
                color: context.appleColors.gray,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: features
                .map(
                  (feature) => IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          LiqMaterialIcons.checkCircle,
                          size: 16,
                          color: context.appleColors.green,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            feature,
                            style: context.textStyles.footnote.secondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: context.textStyles.headline.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: context.textStyles.caption1.secondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
            color: color,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: context.textStyles.caption1.secondary,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
