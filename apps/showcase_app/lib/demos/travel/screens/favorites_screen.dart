import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/travel_providers.dart';
import '../widgets/destination_card.dart';
import 'destination_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteDestinations = ref.watch(favoriteDestinationsProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Favorites',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: favoriteDestinations.isEmpty
          ? Center(
              child: LiqEmptyState(
                icon: Icon(
                  LiqMaterialIcons.favoriteOutline,
                  size: 48,
                  color: context.appleColors.gray,
                ),
                iconBackground: true,
                title: 'No favorites yet',
                description:
                    'Destinations you mark as favorite will appear here',
                cta: LiqEmptyStateCta(
                  label: 'Explore Destinations',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoriteDestinations.length,
              itemBuilder: (context, index) {
                final destination = favoriteDestinations[index];
                return DestinationCard(
                  destination: destination,
                  onTap: () {
                    Navigator.push(
                      context,
                      LiqPageRoute<void>(
                        builder: (context) =>
                            DestinationDetailScreen(destination: destination),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
