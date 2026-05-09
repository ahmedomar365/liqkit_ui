import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_models.dart';
import '../models/travel_providers.dart';
import 'booking_screen.dart';

class DestinationDetailScreen extends ConsumerWidget {
  const DestinationDetailScreen({super.key, required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return LiqScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          LiqSliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: LiqFlexibleSpaceBar(
              gradient: false,
              background: Stack(
                children: <Widget>[
                  PageView.builder(
                    itemCount: destination.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        destination.images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                        destination.images.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: LiqColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              LiqIconButton(
                icon: destination.isFavorite
                    ? LiqMaterialIcons.favorite
                    : LiqMaterialIcons.favoriteOutline,
                color: destination.isFavorite
                    ? context.appleColors.red
                    : null,
                onPressed: () {
                  ref
                      .read(destinationsProvider.notifier)
                      .toggleFavorite(destination.id);
                },
              ),
              LiqIconButton(icon: LiqIcons.share,
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    destination.name,
                    style: context.textStyles.largeTitle.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Icon(
                        LiqMaterialIcons.locationOn,
                        size: 16,
                        color: context.appleColors.gray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        destination.country,
                        style: context.textStyles.body.secondary,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        LiqIcons.star,
                        size: 16,
                        color: context.appleColors.yellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${destination.rating}',
                        style: context.textStyles.body.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${destination.reviews} reviews)',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _QuickInfoCard(
                          icon: LiqMaterialIcons.hotel,
                          label: 'Type',
                          value: destination.type.toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickInfoCard(
                          icon: LiqMaterialIcons.attachMoney,
                          label: 'Price',
                          value: '\$${destination.pricePerNight.toInt()}/night',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickInfoCard(
                          icon: LiqMaterialIcons.thermostat,
                          label: 'Weather',
                          value:
                              '${destination.weather.temperature.toInt()}°C',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About',
                    style: context.textStyles.title2.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(destination.description, style: context.textStyles.body),
                  const SizedBox(height: 24),
                  Text(
                    'Amenities',
                    style: context.textStyles.title2.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: destination.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: context.appleColors.blue
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              _getAmenityIcon(amenity),
                              size: 16,
                              color: context.appleColors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              amenity,
                              style: context.textStyles.caption1.copyWith(
                                color: context.appleColors.blue,
                                fontWeight: LiqAppleTypography.semibold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (destination.activities.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 32),
                    Text(
                      'Things to Do',
                      style: context.textStyles.title2.copyWith(
                        fontWeight: LiqAppleTypography.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...destination.activities.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LiqCard(
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  activity.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      activity.name,
                                      style: context.textStyles.headline
                                          .copyWith(
                                        fontWeight:
                                            LiqAppleTypography.semibold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      activity.description,
                                      style: context
                                          .textStyles.caption1.secondary,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          r'$' +
                                              activity.price.toInt().toString(),
                                          style: context.textStyles.body
                                              .copyWith(
                                            fontWeight:
                                                LiqAppleTypography.bold,
                                            color: context.appleColors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${activity.duration.inHours}h',
                                          style: context
                                              .textStyles.caption1.secondary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LiqGlassSurface(
        borderRadius: BorderRadius.zero,
        padding: EdgeInsets.zero,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'From',
                      style: context.textStyles.caption1.secondary,
                    ),
                    Text(
                      r'$' + destination.pricePerNight.toInt().toString(),
                      style: context.textStyles.title2.copyWith(
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
                const SizedBox(width: 16),
                Expanded(
                  child: LiqButton(
                    label: 'Book Now',
                    fullWidth: true,
                    onPressed: () {
                      ref
                          .read(bookingDetailsProvider.notifier)
                          .selectDestination(destination);
                      Navigator.push(
                        context,
                        LiqPageRoute<void>(
                          builder: (context) => const BookingScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return LiqIcons.wifi;
      case 'pool':
        return LiqMaterialIcons.pool;
      case 'spa':
        return LiqMaterialIcons.spa;
      case 'restaurant':
        return LiqMaterialIcons.restaurant;
      case 'beach access':
        return LiqMaterialIcons.beachAccess;
      case 'gym':
        return LiqMaterialIcons.fitnessCenter;
      case 'parking':
        return LiqMaterialIcons.localParking;
      default:
        return LiqMaterialIcons.checkCircle;
    }
  }
}

class _QuickInfoCard extends StatelessWidget {
  const _QuickInfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 24, color: context.appleColors.blue),
          const SizedBox(height: 8),
          Text(label, style: context.textStyles.caption1.secondary),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textStyles.body.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
