import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_providers.dart';
import '../widgets/transaction_list_item.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionFilterProvider);
    final transactions = ref.watch(filteredTransactionsProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlySpending = ref.watch(monthlySpendingProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Transactions',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(
            icon: LiqMaterialIcons.filterList,
            onPressed: () {},
            semanticLabel: 'Filter',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LiqCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _SummaryItem(
                        title: 'Income',
                        amount: monthlyIncome,
                        color: context.appleColors.green,
                        icon: LiqMaterialIcons.arrowDownward,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: context.appleColors.separator,
                    ),
                    Expanded(
                      child: _SummaryItem(
                        title: 'Expenses',
                        amount: monthlySpending,
                        color: context.appleColors.red,
                        icon: LiqMaterialIcons.arrowUpward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LiqSegmentedControl<TransactionFilter>(
                segments: const <({TransactionFilter value, String label})>[
                  (value: TransactionFilter.all, label: 'All'),
                  (value: TransactionFilter.income, label: 'Income'),
                  (value: TransactionFilter.expense, label: 'Expenses'),
                ],
                value: filter,
                onChanged: (value) {
                  ref.read(transactionFilterProvider.notifier).state = value;
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = transactions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TransactionListItem(
                      transaction: transaction,
                      onTap: () {},
                    ),
                  );
                },
                childCount: transactions.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Text(title, style: context.textStyles.headline.secondary),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          r'$' + amount.toStringAsFixed(2),
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.semibold,
            color: color,
          ),
        ),
      ],
    );
  }
}
