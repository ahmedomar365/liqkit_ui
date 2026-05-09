import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

import '../models/wallet_providers.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  ConsumerState<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardsProvider);
    final selectedIndex = ref.watch(selectedCardIndexProvider);
    final card = cards.isNotEmpty
        ? cards[selectedIndex.clamp(0, cards.length - 1)]
        : null;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Send Money',
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card != null) ...[
              Text('From',
                  style: context.textStyles.caption1.secondary
                      .copyWith(fontWeight: LiqAppleTypography.medium)),
              const SizedBox(height: 8),
              LiqCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color:
                            context.appleColors.blue.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LiqMaterialIcons.creditCard,
                          color: context.appleColors.blue, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.cardHolderName,
                              style: context.textStyles.headline.copyWith(
                                  fontWeight: LiqAppleTypography.semibold)),
                          Text(
                              '•••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                              style: context.textStyles.caption1.secondary),
                        ],
                      ),
                    ),
                    Text('\$${card.balance.toStringAsFixed(2)}',
                        style: context.textStyles.body.copyWith(
                            fontWeight: LiqAppleTypography.semibold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text('To',
                style: context.textStyles.caption1.secondary
                    .copyWith(fontWeight: LiqAppleTypography.medium)),
            const SizedBox(height: 8),
            LiqTextField(
              controller: _recipientController,
              placeholder: 'Recipient (email or phone)',
            ),
            const SizedBox(height: 24),
            Text('Amount',
                style: context.textStyles.caption1.secondary
                    .copyWith(fontWeight: LiqAppleTypography.medium)),
            const SizedBox(height: 8),
            LiqTextField(
              controller: _amountController,
              placeholder: '\$ 0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            Text('Note',
                style: context.textStyles.caption1.secondary
                    .copyWith(fontWeight: LiqAppleTypography.medium)),
            const SizedBox(height: 8),
            LiqTextField(
              controller: _noteController,
              placeholder: 'What is it for?',
            ),
            const SizedBox(height: 32),
            LiqButton(
              label: 'Send',
              fullWidth: true,
              onPressed: () {
                LiqAlert.show<void>(
                  context: context,
                  title: 'Money sent',
                  description:
                      'Sent \$${_amountController.text.isEmpty ? '0' : _amountController.text} to '
                      '${_recipientController.text.isEmpty ? 'recipient' : _recipientController.text}.',
                  actions: [
                    LiqAlertAction(
                      label: 'OK',
                      style: LiqAlertActionStyle.filled,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
