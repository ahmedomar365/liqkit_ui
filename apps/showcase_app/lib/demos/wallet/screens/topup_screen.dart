import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_providers.dart';

class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen> {
  double _amount = 50;

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
          'Top Up',
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LiqCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text('Amount to add',
                      style: context.textStyles.subheadline.secondary),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_amount.toStringAsFixed(0)}',
                    style: context.textStyles.largeTitle.copyWith(
                        fontWeight: LiqAppleTypography.bold,
                        fontSize: 56),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [25.0, 50.0, 100.0, 200.0, 500.0]
                  .map((preset) => SizedBox(
                        width: 100,
                        child: LiqButton(
                          label: '\$${preset.toStringAsFixed(0)}',
                          style: _amount == preset
                              ? LiqButtonStyle.liquid
                              : LiqButtonStyle.borderedSecondary,
                          onPressed: () => setState(() => _amount = preset),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            if (card != null) ...[
              Text('To',
                  style: context.textStyles.caption1.secondary
                      .copyWith(fontWeight: LiqAppleTypography.medium)),
              const SizedBox(height: 8),
              LiqCard(
                child: Row(
                  children: [
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
            LiqButton(
              label: 'Add \$${_amount.toStringAsFixed(0)}',
              fullWidth: true,
              onPressed: () {
                LiqAlert.show<void>(
                  context: context,
                  title: 'Funds added',
                  description:
                      '\$${_amount.toStringAsFixed(0)} has been added to your card.',
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
