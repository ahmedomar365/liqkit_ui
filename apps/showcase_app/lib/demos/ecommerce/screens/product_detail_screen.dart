import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ecommerce_providers.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends ConsumerState<ProductDetailScreen> {
  String? selectedColor;
  String? selectedSize;
  int quantity = 1;

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
  void initState() {
    super.initState();
    if (widget.product.colors.isNotEmpty) {
      selectedColor = widget.product.colors.first;
    }
    if (widget.product.sizes.isNotEmpty) {
      selectedSize = widget.product.sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(widget.product.id);
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark
        ? const Color(0xFF000000)
        : const Color(0xFFF5F5F5);

    return LiqScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          LiqSliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: LiqColors.transparent,
            flexibleSpace: LiqFlexibleSpaceBar(
              gradient: false,
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // The original sample data pointed at via.placeholder.com
                  // (offline since 2024) — fall back to a category-themed
                  // gradient + glyph so the hero area is never blank.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _gradientFor(widget.product.category, context),
                    ),
                    child: Center(
                      child: Icon(
                        _iconFor(widget.product.category),
                        size: 120,
                        color: LiqColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          LiqColors.transparent,
                          LiqColors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scaffoldBg.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: LiqIconButton(icon: LiqMaterialIcons.arrowBack,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scaffoldBg.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: LiqIconButton(
                    icon: isFavorite
                        ? LiqMaterialIcons.favorite
                        : LiqMaterialIcons.favoriteBorder,
                    color: isFavorite ? context.appleColors.red : null,
                    onPressed: () {
                      ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(widget.product.id);
                    },
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: context.textStyles.largeTitle.copyWith(
                            fontWeight: LiqAppleTypography.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        r'$' + widget.product.price.toStringAsFixed(2),
                        style: context.textStyles.title1.copyWith(
                          fontWeight: LiqAppleTypography.bold,
                          color: context.appleColors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      ...List<Widget>.generate(5, (index) {
                        return Icon(
                          index < widget.product.rating.floor()
                              ? LiqIcons.star
                              : LiqMaterialIcons.starBorder,
                          size: 20,
                          color: context.appleColors.yellow,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.rating} (${widget.product.reviews} reviews)',
                        style: context.textStyles.body,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: context.textStyles.title2.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: context.textStyles.body,
                  ),
                  const SizedBox(height: 24),
                  if (widget.product.colors.isNotEmpty) ...<Widget>[
                    Text(
                      'Color',
                      style: context.textStyles.title3.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: widget.product.colors.map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedColor = color);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: isSelected ? 2 : 1,
                                color: isSelected
                                    ? context.appleColors.blue
                                    : LiqColors.grey.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              color,
                              style: TextStyle(
                                color: isSelected
                                    ? context.appleColors.blue
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (widget.product.sizes.isNotEmpty) ...<Widget>[
                    Text(
                      'Size',
                      style: context.textStyles.title3.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: widget.product.sizes.map((size) {
                        final isSelected = selectedSize == size;
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedSize = size);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: isSelected ? 2 : 1,
                                color: isSelected
                                    ? context.appleColors.blue
                                    : LiqColors.grey.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                color: isSelected
                                    ? context.appleColors.blue
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Quantity',
                    style: context.textStyles.title3.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      LiqCard(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            LiqIconButton(icon: LiqMaterialIcons.remove,
                              onPressed: quantity > 1
                                  ? () {
                                      setState(() => quantity--);
                                    }
                                  : null,
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 60),
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: context.textStyles.title3.copyWith(
                                  fontWeight: LiqAppleTypography.semibold,
                                ),
                              ),
                            ),
                            LiqIconButton(icon: LiqMaterialIcons.add,
                              onPressed: quantity < widget.product.stock
                                  ? () {
                                      setState(() => quantity++);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (widget.product.stock > 0)
                        Text(
                          '${widget.product.stock} available',
                          style: context.textStyles.body.secondary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  LiqButton(
                    label: widget.product.stock > 0
                        ? 'Add to Cart'
                        : 'Out of Stock',
                    fullWidth: true,
                    onPressed: widget.product.stock > 0
                        ? () {
                            for (var i = 0; i < quantity; i++) {
                              ref.read(cartProvider.notifier).addToCart(
                                    widget.product,
                                    color: selectedColor,
                                    size: selectedSize,
                                  );
                            }
                            LiqToastOverlay.show(
                              context,
                              'Added $quantity item(s) to cart',
                              variant: LiqToastVariant.success,
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
