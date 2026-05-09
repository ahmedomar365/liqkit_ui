import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/travel_models.dart';

class TravelPackageCard extends StatelessWidget {
  final TravelPackage package;
  final VoidCallback onTap;

  const TravelPackageCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.network(
              package.imageUrl,
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (package.isAllInclusive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            context.appleColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ALL INCLUSIVE',
                        style: context.textStyles.caption2.copyWith(
                          color: context.appleColors.green,
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    package.name,
                    style: context.textStyles.headline.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${package.days} days / ${package.nights} nights',
                    style: context.textStyles.subheadline.secondary,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(
                        'From ',
                        style: context.textStyles.caption1.secondary,
                      ),
                      Text(
                        r'$' + package.price.toInt().toString(),
                        style: context.textStyles.title3.copyWith(
                          fontWeight: LiqAppleTypography.bold,
                          color: context.appleColors.blue,
                        ),
                      ),
                      Text(
                        ' per person',
                        style: context.textStyles.caption1.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
