import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/travel_models.dart';
import '../models/travel_providers.dart';

class DestinationCard extends ConsumerWidget {
  final Destination destination;
  final VoidCallback onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  destination.images.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(destinationsProvider.notifier)
                        .toggleFavorite(destination.id);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: LiqColors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      destination.isFavorite
                          ? LiqMaterialIcons.favorite
                          : LiqMaterialIcons.favoriteOutline,
                      color: destination.isFavorite
                          ? context.appleColors.red
                          : LiqColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: LiqColors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(destination.weather.icon, size: 16, color: LiqColors.white),
                      const SizedBox(width: 4),
                      Text(
                        '${destination.weather.temperature.toInt()}°',
                        style: context.textStyles.caption1.copyWith(
                          color: LiqColors.white,
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  destination.name,
                  style: context.textStyles.headline.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(
                      LiqMaterialIcons.locationOn,
                      size: 14,
                      color: context.appleColors.tertiaryLabel,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      destination.country,
                      style: context.textStyles.subheadline.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          LiqIcons.star,
                          size: 16,
                          color: context.appleColors.yellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination.rating.toString(),
                          style: context.textStyles.caption1.copyWith(
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${destination.reviews})',
                          style: context.textStyles.caption1.secondary,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          r'$' + destination.pricePerNight.toInt().toString(),
                          style: context.textStyles.headline.copyWith(
                            fontWeight: LiqAppleTypography.bold,
                            color: context.appleColors.blue,
                          ),
                        ),
                        Text(
                          'per night',
                          style: context.textStyles.caption2.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
