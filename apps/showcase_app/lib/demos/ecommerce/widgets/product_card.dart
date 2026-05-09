import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/ecommerce_providers.dart';
import '../models/product_model.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  // Local placeholders — the original sample data pointed at
  // `via.placeholder.com` which has been offline since 2024. Network
  // image failures left the grid blank on real devices, so we render
  // a deterministic category-themed gradient + glyph instead.
  IconData _iconFor(String category) {
    switch (category) {
      case 'Electronics':
        return LiqMaterialIcons.devices;
      case 'Fashion':
        return LiqMaterialIcons.shoppingBag;
      case 'Smart Home':
        return LiqMaterialIcons.homeOutlined;
      case 'Fitness':
        return LiqMaterialIcons.fitnessCenter;
      default:
        return LiqMaterialIcons.shoppingBag;
    }
  }

  LinearGradient _gradientFor(String category, BuildContext context) {
    final c = context.appleColors;
    switch (category) {
      case 'Electronics':
        return LinearGradient(colors: [c.blue, c.indigo]);
      case 'Fashion':
        return LinearGradient(colors: [c.purple, c.pink]);
      case 'Smart Home':
        return LinearGradient(colors: [c.teal, c.cyan]);
      case 'Fitness':
        return LinearGradient(colors: [c.orange, c.red]);
      default:
        return LinearGradient(colors: [c.gray, c.gray2]);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(product.id);
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;
    final favoriteBg =
        (isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF))
            .withValues(alpha: 0.8);

    return LiqCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: _gradientFor(product.category, context),
                ),
                child: Center(
                  child: Icon(
                    _iconFor(product.category),
                    size: 64,
                    color: LiqColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: favoriteBg,
                    shape: BoxShape.circle,
                  ),
                  child: LiqIconButton(
                    icon: isFavorite ? LiqMaterialIcons.favorite : LiqMaterialIcons.favoriteBorder,
                    color: isFavorite ? context.appleColors.red : null,
                    style: LiqIconButtonStyle.borderless,
                    size: 36,
                    onPressed: () {
                      ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(product.id);
                    },
                  ),
                ),
              ),
              if (product.stock < 5 && product.stock > 0)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.appleColors.orange.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Only ${product.stock} left',
                      style: const TextStyle(
                        color: LiqColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: context.textStyles.headline.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Icon(
                        LiqIcons.star,
                        size: 16,
                        color: context.appleColors.yellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: context.textStyles.caption1,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviews})',
                        style: context.textStyles.caption1.secondary,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    r'$' + product.price.toStringAsFixed(2),
                    style: context.textStyles.title3.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                      color: context.appleColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
