import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_models.dart';
import '../models/wallet_providers.dart';

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider);
    final pendingBills = ref.watch(billsProvider.notifier).getPendingBills();
    final totalPending = ref
        .watch(billsProvider.notifier)
        .getTotalPendingAmount();

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Bills',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(
            icon: LiqMaterialIcons.add,
            onPressed: () {},
            semanticLabel: 'Add bill',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: bills.isEmpty
          ? Center(
              child: LiqEmptyState(
                icon: Icon(
                  LiqMaterialIcons.receiptLong,
                  size: 48,
                  color: context.appleColors.gray,
                ),
                iconBackground: true,
                title: 'No Bills',
                description: "You don't have any bills to pay",
                cta: LiqEmptyStateCta(
                  label: 'Add Bill',
                  onPressed: () {},
                ),
              ),
            )
          : CustomScrollView(
              slivers: <Widget>[
                if (pendingBills.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              context.appleColors.orange.withValues(alpha: 0.2),
                              context.appleColors.red.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: LiqCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Pending Bills',
                                    style:
                                        context.textStyles.headline.secondary,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.appleColors.orange
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${pendingBills.length} bills',
                                      style: context.textStyles.caption1
                                          .copyWith(
                                        color: context.appleColors.orange,
                                        fontWeight: LiqAppleTypography.semibold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                r'$' + totalPending.toStringAsFixed(2),
                                style: context.textStyles.largeTitle.copyWith(
                                  fontSize: 36,
                                  fontWeight: LiqAppleTypography.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total amount due',
                                style: context.textStyles.subheadline.secondary,
                              ),
                              const SizedBox(height: 20),
                              LiqButton(
                                label: 'Pay All Bills',
                                fullWidth: true,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final bill = bills[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _BillItem(
                            bill: bill,
                            onPay: () {
                              ref
                                  .read(billsProvider.notifier)
                                  .payBill(bill.id);
                            },
                          ),
                        );
                      },
                      childCount: bills.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }
}

class _BillItem extends StatelessWidget {
  const _BillItem({required this.bill, required this.onPay});

  final Bill bill;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.MMMd();
    final daysUntilDue = bill.dueDate.difference(DateTime.now()).inDays;
    final isPaid = bill.status == BillStatus.paid;
    final isOverdue = bill.status == BillStatus.overdue;

    return LiqCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _getStatusColor(bill.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                bill.logo ?? LiqMaterialIcons.receiptOutlined,
                color: _getStatusColor(bill.status),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  bill.name,
                  style: context.textStyles.headline.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bill.provider,
                  style: context.textStyles.subheadline.secondary,
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(
                      LiqMaterialIcons.calendarToday,
                      size: 14,
                      color: context.appleColors.secondaryLabel,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due ${dateFormat.format(bill.dueDate)}',
                      style: context.textStyles.caption1.secondary,
                    ),
                    if (!isPaid) ...<Widget>[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(bill.status)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isOverdue
                              ? 'Overdue'
                              : daysUntilDue == 0
                                  ? 'Due today'
                                  : '$daysUntilDue days',
                          style: context.textStyles.caption2.copyWith(
                            color: _getStatusColor(bill.status),
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                r'$' + bill.amount.toStringAsFixed(2),
                style: context.textStyles.title3.copyWith(
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
              const SizedBox(height: 4),
              if (isPaid)
                Row(
                  children: <Widget>[
                    Icon(
                      LiqMaterialIcons.checkCircle,
                      size: 16,
                      color: context.appleColors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Paid',
                      style: context.textStyles.caption1.copyWith(
                        color: context.appleColors.green,
                        fontWeight: LiqAppleTypography.medium,
                      ),
                    ),
                  ],
                )
              else
                LiqButton(
                  label: 'Pay',
                  size: LiqButtonSize.small,
                  onPressed: onPay,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return LiqColors.green;
      case BillStatus.pending:
        return LiqColors.orange;
      case BillStatus.overdue:
        return LiqColors.red;
    }
  }
}
