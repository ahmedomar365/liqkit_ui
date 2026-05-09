import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ecommerce_providers.dart';
import '../models/product_model.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartProvider.notifier).totalPrice;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Shopping Cart',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: LiqEmptyState(
                icon: Icon(
                  LiqMaterialIcons.shoppingCartOutlined,
                  size: 48,
                  color: context.appleColors.gray,
                ),
                iconBackground: true,
                title: 'Your cart is empty',
                description:
                    'Add some items to your cart to continue shopping',
                cta: LiqEmptyStateCta(
                  label: 'Continue Shopping',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _CartItemWidget(item: item);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: LiqCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Subtotal', style: context.textStyles.body),
                            Text(
                              r'$' + totalPrice.toStringAsFixed(2),
                              style: context.textStyles.body,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Shipping', style: context.textStyles.body),
                            Text(
                              totalPrice > 50 ? 'FREE' : r'$5.99',
                              style: context.textStyles.body.copyWith(
                                color: totalPrice > 50
                                    ? context.appleColors.green
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24, child: Center(child: LiqDivider())),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total',
                              style: context.textStyles.title2.copyWith(
                                fontWeight: LiqAppleTypography.bold,
                              ),
                            ),
                            Text(
                              r'$' +
                                  (totalPrice +
                                          (totalPrice > 50 ? 0 : 5.99))
                                      .toStringAsFixed(2),
                              style: context.textStyles.title2.copyWith(
                                fontWeight: LiqAppleTypography.bold,
                                color: context.appleColors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        LiqButton(
                          label: 'Proceed to Checkout',
                          fullWidth: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              LiqPageRoute<void>(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          },
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

class _CartItemWidget extends ConsumerWidget {
  const _CartItemWidget({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LiqCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.product.name,
                    style: context.textStyles.headline.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.selectedColor != null)
                    Text(
                      'Color: ${item.selectedColor}',
                      style: context.textStyles.caption1.secondary,
                    ),
                  if (item.selectedSize != null)
                    Text(
                      'Size: ${item.selectedSize}',
                      style: context.textStyles.caption1.secondary,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: LiqColors.grey.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LiqIconButton(icon: LiqMaterialIcons.remove,
                              iconSize: 18,
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .updateQuantity(item, item.quantity - 1);
                              },
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 40),
                              alignment: Alignment.center,
                              child: Text(
                                item.quantity.toString(),
                                style: context.textStyles.body,
                              ),
                            ),
                            LiqIconButton(icon: LiqMaterialIcons.add,
                              iconSize: 18,
                              onPressed: item.quantity < item.product.stock
                                  ? () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                            item,
                                            item.quantity + 1,
                                          );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        r'$' + item.totalPrice.toStringAsFixed(2),
                        style: context.textStyles.title3.copyWith(
                          fontWeight: LiqAppleTypography.bold,
                          color: context.appleColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            LiqIconButton(icon: LiqIcons.close,
              iconSize: 20,
              onPressed: () {
                ref.read(cartProvider.notifier).removeFromCart(item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
