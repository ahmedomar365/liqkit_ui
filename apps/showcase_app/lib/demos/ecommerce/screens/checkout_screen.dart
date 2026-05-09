import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ecommerce_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int currentStep = 0;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = ref.watch(cartProvider.notifier).totalPrice;
    final shipping = totalPrice > 50 ? 0.0 : 5.99;
    final finalTotal = totalPrice + shipping;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Checkout',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  _buildStep(0, 'Shipping', currentStep >= 0),
                  _buildStepConnector(currentStep > 0),
                  _buildStep(1, 'Payment', currentStep >= 1),
                  _buildStepConnector(currentStep > 1),
                  _buildStep(2, 'Review', currentStep >= 2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    if (currentStep == 0) _buildShippingStep(),
                    if (currentStep == 1) _buildPaymentStep(),
                    if (currentStep == 2) _buildReviewStep(),
                  ],
                ),
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
                        Text(
                          'Total',
                          style: context.textStyles.title2.copyWith(
                            fontWeight: LiqAppleTypography.bold,
                          ),
                        ),
                        Text(
                          r'$' + finalTotal.toStringAsFixed(2),
                          style: context.textStyles.title2.copyWith(
                            fontWeight: LiqAppleTypography.bold,
                            color: context.appleColors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        if (currentStep > 0)
                          Expanded(
                            child: LiqButton(
                              label: 'Back',
                              fullWidth: true,
                              style: LiqButtonStyle.borderedSecondary,
                              onPressed: () {
                                setState(() => currentStep--);
                              },
                            ),
                          ),
                        if (currentStep > 0) const SizedBox(width: 16),
                        Expanded(
                          child: LiqButton(
                            label:
                                currentStep < 2 ? 'Continue' : 'Place Order',
                            fullWidth: true,
                            onPressed: () {
                              if (currentStep < 2) {
                                if (_validateCurrentStep()) {
                                  setState(() => currentStep++);
                                }
                              } else {
                                _completeOrder();
                              }
                            },
                          ),
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

  Widget _buildStep(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive
                  ? context.appleColors.blue
                  : LiqColors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? LiqColors.white : LiqColors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? null : LiqColors.grey,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive
            ? context.appleColors.blue
            : LiqColors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildShippingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Shipping Information',
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 24),
        LiqTextField(
          controller: _emailController,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        LiqTextField(
          controller: _nameController,
          placeholder: 'Full Name',
        ),
        const SizedBox(height: 16),
        LiqTextField(
          controller: _addressController,
          placeholder: 'Address',
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: LiqTextField(
                controller: _cityController,
                placeholder: 'City',
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: LiqTextField(
                controller: _zipController,
                placeholder: 'ZIP Code',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Payment Information',
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 24),
        LiqTextField(
          controller: _cardNumberController,
          placeholder: 'Card Number',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        LiqTextField(
          controller: _cardHolderController,
          placeholder: 'Cardholder Name',
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: LiqTextField(
                controller: _expiryController,
                placeholder: 'MM/YY',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: LiqTextField(
                controller: _cvvController,
                placeholder: 'CVV',
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartProvider.notifier).totalPrice;
    final shipping = totalPrice > 50 ? 0.0 : 5.99;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Order Review',
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 24),
        ...cartItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.product.name, style: context.textStyles.body),
                      Text(
                        'Qty: ${item.quantity}',
                        style: context.textStyles.caption1.secondary,
                      ),
                    ],
                  ),
                ),
                Text(
                  r'$' + item.totalPrice.toStringAsFixed(2),
                  style: context.textStyles.body,
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 32, child: Center(child: LiqDivider())),
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
              shipping == 0 ? 'FREE' : r'$' + shipping.toStringAsFixed(2),
              style: context.textStyles.body.copyWith(
                color: shipping == 0 ? context.appleColors.green : null,
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
              style: context.textStyles.title3.copyWith(
                fontWeight: LiqAppleTypography.bold,
              ),
            ),
            Text(
              r'$' + (totalPrice + shipping).toStringAsFixed(2),
              style: context.textStyles.title3.copyWith(
                fontWeight: LiqAppleTypography.bold,
                color: context.appleColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Shipping to:',
          style: context.textStyles.headline.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 8),
        Text(_nameController.text, style: context.textStyles.body),
        Text(_addressController.text, style: context.textStyles.body),
        Text(
          '${_cityController.text}, ${_zipController.text}',
          style: context.textStyles.body,
        ),
        const SizedBox(height: 24),
        Text(
          'Payment Method:',
          style: context.textStyles.headline.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _cardNumberController.text.length >= 4
              ? 'Card ending in ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}'
              : 'Card details incomplete',
          style: context.textStyles.body,
        ),
      ],
    );
  }

  bool _validateCurrentStep() {
    if (currentStep == 0) {
      return _emailController.text.contains('@') &&
          _nameController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _zipController.text.isNotEmpty;
    }
    if (currentStep == 1) {
      return _cardNumberController.text.length >= 16 &&
          _cardHolderController.text.isNotEmpty &&
          _expiryController.text.isNotEmpty &&
          _cvvController.text.isNotEmpty;
    }
    return true;
  }

  void _completeOrder() {
    ref.read(cartProvider.notifier).clearCart();
    LiqAlert.show<void>(
      context: context,
      title: 'Order Placed!',
      description:
          'Your order has been successfully placed. You will receive a confirmation email shortly.',
      barrierDismissible: false,
      actions: [
        LiqAlertAction(
          label: 'OK',
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
