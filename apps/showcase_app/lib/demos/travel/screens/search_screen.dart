import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_providers.dart';
import '../widgets/destination_card.dart';
import 'destination_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDestinations = ref.watch(filteredDestinationsProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final searchFilter = ref.watch(searchFilterProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Search Destinations',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: LiqTextField(
                    controller: _searchController,
                    prefixIcon: const Icon(LiqIcons.search),
                    placeholder: 'Where do you want to go?',
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        ref
                            .read(recentSearchesProvider.notifier)
                            .addSearch(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                LiqIconButton(
                  icon: LiqMaterialIcons.tune,
                  color: _showFilters ? context.appleColors.blue : null,
                  onPressed: () {
                    setState(() => _showFilters = !_showFilters);
                  },
                ),
              ],
            ),
          ),
          if (_showFilters)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LiqColors.grey.withValues(alpha: 0.05),
                border: Border(
                  top: BorderSide(
                    color: LiqColors.grey.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Filters',
                    style: context.textStyles.headline.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Price Range', style: context.textStyles.subheadline),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: LiqTextField(
                          controller: _minPriceController,
                          placeholder: 'Min',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final price = double.tryParse(value);
                            ref.read(searchFilterProvider.notifier).state =
                                searchFilter.copyWith(minPrice: price);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LiqTextField(
                          controller: _maxPriceController,
                          placeholder: 'Max',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final price = double.tryParse(value);
                            ref.read(searchFilterProvider.notifier).state =
                                searchFilter.copyWith(maxPrice: price);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Accommodation Type',
                    style: context.textStyles.subheadline,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        const <String>['All', 'Hotel', 'Resort', 'Villa', 'Apartment']
                            .map((type) {
                      final isSelected = type.toLowerCase() ==
                              searchFilter.type ||
                          (type == 'All' && searchFilter.type == null);
                      return LiqChip(
                        label: type,
                        selected: isSelected,
                        onPressed: () {
                          ref.read(searchFilterProvider.notifier).state =
                              searchFilter.copyWith(
                            type: type == 'All' ? null : type.toLowerCase(),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          if (recentSearches.isNotEmpty && _searchController.text.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Recent Searches',
                        style: context.textStyles.headline.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      LiqButton(
                        label: 'Clear',
                        size: LiqButtonSize.small,
                        style: LiqButtonStyle.borderless,
                        onPressed: () {
                          ref
                              .read(recentSearchesProvider.notifier)
                              .clearSearches();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...recentSearches.map((search) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _searchController.text = search;
                        ref.read(searchQueryProvider.notifier).state = search;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              LiqMaterialIcons.history,
                              size: 20,
                              color: context.appleColors.tertiaryLabel,
                            ),
                            const SizedBox(width: 12),
                            Text(search, style: context.textStyles.body),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          Expanded(
            child: filteredDestinations.isEmpty
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
                          'No destinations found',
                          style: context.textStyles.title2.copyWith(
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: context.textStyles.body.secondary,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredDestinations.length,
                    itemBuilder: (context, index) {
                      final destination = filteredDestinations[index];
                      return DestinationCard(
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
