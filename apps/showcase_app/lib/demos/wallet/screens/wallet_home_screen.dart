import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import '../models/wallet_providers.dart';
import '../widgets/payment_card_widget.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/balance_overview.dart';
import 'transactions_screen.dart';
import 'cards_screen.dart';
import 'bills_screen.dart';
import 'savings_screen.dart';

class WalletHomeScreen extends ConsumerWidget {
  const WalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsProvider);
    final selectedCardIndex = ref.watch(selectedCardIndexProvider);
    final recentTransactions = ref.watch(recentTransactionsProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Liquid Wallet',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: [
          LiqIconButton(
            icon: LiqMaterialIcons.notificationsOutlined,
            onPressed: () {
              // Show notifications
            },
            semanticLabel: 'Notifications',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance overview
            const BalanceOverview(),
            
            // Payment cards carousel
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                onPageChanged: (index) {
                  ref.read(selectedCardIndexProvider.notifier).state = index;
                },
                itemCount: cards.length + 1,
                itemBuilder: (context, index) {
                  if (index == cards.length) {
                    // Add card button
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            LiqPageRoute(
                              builder: (context) => const CardsScreen(),
                            ),
                          );
                        },
                        child: LiqCard(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: context.appleColors.blue.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LiqMaterialIcons.add,
                                    size: 30,
                                    color: context.appleColors.blue,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Add New Card',
                                  style: context.textStyles.headline.copyWith(
                                    fontWeight: LiqAppleTypography.semibold,
                                    color: context.appleColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: PaymentCardWidget(
                      card: cards[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          LiqPageRoute(
                            builder: (context) => const CardsScreen(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cards.length + 1,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedCardIndex == index
                        ? context.appleColors.blue
                        : context.appleColors.tertiaryLabel,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: QuickActionsGrid(),
            ),
            const SizedBox(height: 32),
            
            // Recent transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: context.textStyles.title2.copyWith(
                      fontWeight: LiqAppleTypography.bold,
                    ),
                  ),
                  LiqButton(
                    label: 'See All',
                    style: LiqButtonStyle.borderless,
                    onPressed: () {
                      Navigator.push(
                        context,
                        LiqPageRoute<void>(
                          builder: (context) => const TransactionsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Transactions list
            ...recentTransactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TransactionListItem(transaction: transaction),
              );
            }),
            
            const SizedBox(height: 32),
            
            // Quick links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quick Links',
                style: context.textStyles.title2.copyWith(
                  fontWeight: LiqAppleTypography.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick link cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickLinkCard(
                      icon: LiqMaterialIcons.receipt,
                      title: 'Bills',
                      subtitle: '3 pending',
                      color: context.appleColors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          LiqPageRoute(
                            builder: (context) => const BillsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickLinkCard(
                      icon: LiqMaterialIcons.savings,
                      title: 'Savings',
                      subtitle: '75% goal',
                      color: context.appleColors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          LiqPageRoute(
                            builder: (context) => const SavingsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: context.textStyles.headline.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: context.textStyles.caption1.copyWith(
              color: color,
              fontWeight: LiqAppleTypography.medium,
            ),
          ),
        ],
      ),
    );
  }
}