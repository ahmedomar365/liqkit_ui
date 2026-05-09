import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_providers.dart';
import '../widgets/destination_card.dart';
import '../widgets/search_suggestions.dart';
import '../widgets/travel_package_card.dart';
import 'destination_detail_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class TravelHomeScreen extends ConsumerStatefulWidget {
  const TravelHomeScreen({super.key});

  @override
  ConsumerState<TravelHomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends ConsumerState<TravelHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popularDestinations = ref.watch(popularDestinationsProvider);
    final packages = ref.watch(packagesProvider);

    return LiqScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          LiqSliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: LiqFlexibleSpaceBar(
              background: Image.network(
                'https://picsum.photos/800/600?random=400',
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'Discover Your',
                style: context.textStyles.title1.copyWith(
                  color: LiqColors.white,
                ),
              ),
              title: Text(
                'Next Adventure',
                style: context.textStyles.largeTitle.copyWith(
                  color: LiqColors.white,
                  fontWeight: LiqAppleTypography.bold,
                ),
              ),
            ),
            actions: <Widget>[
              LiqIconButton(icon: LiqMaterialIcons.favoriteOutline,
                onPressed: () {
                  Navigator.push(
                    context,
                    LiqPageRoute<void>(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    LiqPageRoute<void>(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: LiqTextField(
                    controller: _searchController,
                    prefixIcon: const Icon(LiqIcons.search),
                    placeholder: 'Search destinations...',
                    suffixIcon: const Icon(LiqMaterialIcons.tune),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SearchSuggestions()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Popular Destinations',
                    style: context.textStyles.title2.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                    ),
                  ),
                  LiqButton(
                    label: 'See All',
                    style: LiqButtonStyle.borderless,
                    onPressed: () {
                      Navigator.push(
                        context,
                        LiqPageRoute<void>(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: popularDestinations.length,
                itemBuilder: (context, index) {
                  final destination = popularDestinations[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 250,
                      child: DestinationCard(
                        destination: destination,
                        onTap: () {
                          Navigator.push(
                            context,
                            LiqPageRoute<void>(
                              builder: (context) => DestinationDetailScreen(
                                destination: destination,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              child: Text(
                'Exclusive Packages',
                style: context.textStyles.title2.copyWith(
                  fontWeight: LiqAppleTypography.bold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final package = packages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: TravelPackageCard(
                    package: package,
                    onTap: () {},
                  ),
                );
              },
              childCount: packages.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: LiqButton(
        label: 'Plan Trip',
        leadingIcon: LiqMaterialIcons.explore,
        onPressed: () {},
        style: LiqButtonStyle.borderedProminent,
      ),
    );
  }
}
