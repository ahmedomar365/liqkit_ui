import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_providers.dart';
import '../widgets/payment_card_widget.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'My Cards',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(
            icon: LiqMaterialIcons.add,
            onPressed: () => _showAddCardSheet(context),
            semanticLabel: 'Add card',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...cards.map((card) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    PaymentCardWidget(
                      card: card,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    LiqCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          _CardActionRow(
                            icon: LiqIcons.lock,
                            title: 'Lock Card',
                            subtitle: card.isLocked
                                ? 'Card is locked'
                                : 'Card is active',
                            trailing: LiqToggle(
                              value: card.isLocked,
                              onChanged: (value) {
                                ref
                                    .read(cardsProvider.notifier)
                                    .toggleLock(card.id);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _CardActionRow(
                            icon: LiqIcons.star,
                            title: 'Default Card',
                            subtitle: 'Use for all payments',
                            trailing: LiqToggle(
                              value: card.isDefault,
                              onChanged: (value) {
                                if (value) {
                                  ref
                                      .read(cardsProvider.notifier)
                                      .setDefaultCard(card.id);
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _CardActionRow(
                            icon: LiqIcons.settings,
                            title: 'Card Settings',
                            subtitle: 'Manage limits and security',
                            trailing: Icon(
                              LiqMaterialIcons.arrowForwardIos,
                              size: 16,
                              color: context.appleColors.gray,
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 16),
                          _CardActionRow(
                            icon: LiqMaterialIcons.delete,
                            title: 'Remove Card',
                            subtitle: 'Delete from wallet',
                            trailing: Icon(
                              LiqMaterialIcons.arrowForwardIos,
                              size: 16,
                              color: context.appleColors.gray,
                            ),
                            onTap: () async {
                              final confirmed = await LiqAlert.showConfirmation(
                                context: context,
                                title: 'Remove Card',
                                description:
                                    'Are you sure you want to remove this '
                                    'card from your wallet?',
                                confirmText: 'Remove',
                                cancelText: 'Cancel',
                                isDestructive: true,
                              );
                              if (confirmed == true) {
                                ref
                                    .read(cardsProvider.notifier)
                                    .removeCard(card.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _CardActionRow extends StatelessWidget {
  const _CardActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.appleColors.gray.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: context.appleColors.label,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: context.textStyles.body.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
                Text(subtitle, style: context.textStyles.caption1.secondary),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

void _showAddCardSheet(BuildContext context) {
  final numberCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();
  LiqSheet.show<void>(
    context: context,
    title: 'Add Card',
    height: 520,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LiqTextField(
            controller: numberCtrl,
            placeholder: 'Card number',
          ),
          const SizedBox(height: 12),
          LiqTextField(
            controller: nameCtrl,
            placeholder: 'Cardholder name',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LiqTextField(
                  controller: expiryCtrl,
                  placeholder: 'MM/YY',
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: LiqTextField(
                  controller: cvvCtrl,
                  placeholder: 'CVV',
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (sheetCtx) => LiqButton(
              label: 'Add Card',
              fullWidth: true,
              onPressed: () {
                Navigator.of(sheetCtx).pop();
                LiqAlert.show<void>(
                  context: context,
                  title: 'Card added',
                  description:
                      'Your card ending in ${numberCtrl.text.length >= 4 ? numberCtrl.text.substring(numberCtrl.text.length - 4) : '0000'} is now linked.',
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
          ),
        ],
      ),
    ),
  );
}
