import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/ecommerce_providers.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class EcommerceHomeScreen extends ConsumerStatefulWidget {
  const EcommerceHomeScreen({super.key});

  @override
  ConsumerState<EcommerceHomeScreen> createState() =>
      _EcommerceHomeScreenState();
}

class _EcommerceHomeScreenState extends ConsumerState<EcommerceHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = const <String>[
    'All',
    'Electronics',
    'Fashion',
    'Smart Home',
    'Fitness',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = ref.watch(cartProvider.notifier).totalItems;
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    context.appleColors.blue,
                    context.appleColors.purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LiqMaterialIcons.shoppingBag,
                color: LiqColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Liquid Store',
              style: context.textStyles.largeTitle.copyWith(
                fontWeight: LiqAppleTypography.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              LiqIconButton(
                icon: LiqMaterialIcons.shoppingCart,
                onPressed: () {
                  Navigator.push(
                    context,
                    LiqPageRoute<void>(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (totalItems > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.appleColors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        totalItems.toString(),
                        style: const TextStyle(
                          color: LiqColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LiqTextField(
                controller: _searchController,
                placeholder: 'Search products...',
                prefixIcon: const Icon(LiqIcons.search),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isAll = category == 'All';
                  final isSelected = isAll
                      ? selectedCategory == null
                      : selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: LiqButton(
                      label: category,
                      style: isSelected
                          ? LiqButtonStyle.borderedProminent
                          : LiqButtonStyle.borderedSecondary,
                      onPressed: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            isAll ? null : category;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    context.appleColors.purple,
                    context.appleColors.pink,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: LiqColors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Summer Sale',
                            style: context.textStyles.largeTitle.copyWith(
                              color: LiqColors.white,
                              fontWeight: LiqAppleTypography.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Up to 50% off on selected items',
                            style: context.textStyles.body.copyWith(
                              color: LiqColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 16),
                          LiqButton(
                            label: 'Shop Now',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        LiqPageRoute<void>(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  );
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}
