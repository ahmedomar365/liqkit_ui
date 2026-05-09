import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_models.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.MMMd();
    final timeFormat = DateFormat.jm();
    final isExpense = transaction.type == TransactionType.expense;
    final categoryColor = _getCategoryColor(context, transaction.category);

    return LiqCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                transaction.merchantLogo ??
                    _getCategoryIcon(transaction.category),
                color: categoryColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  transaction.title,
                  style: context.textStyles.headline.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.description,
                  style: context.textStyles.subheadline.secondary,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${isExpense ? '-' : '+'}\$${transaction.amount.abs().toStringAsFixed(2)}',
                    style: context.textStyles.headline.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                      color: isExpense
                          ? context.appleColors.label
                          : context.appleColors.green,
                    ),
                  ),
                  if (transaction.status == TransactionStatus.pending) ...<Widget>[
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: context.appleColors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${dateFormat.format(transaction.timestamp)} • ${timeFormat.format(transaction.timestamp)}',
                style: context.textStyles.caption1.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.shopping:
        return LiqMaterialIcons.shoppingBag;
      case TransactionCategory.food:
        return LiqMaterialIcons.restaurant;
      case TransactionCategory.transport:
        return LiqMaterialIcons.directionsCar;
      case TransactionCategory.entertainment:
        return LiqMaterialIcons.movie;
      case TransactionCategory.bills:
        return LiqMaterialIcons.receipt;
      case TransactionCategory.healthcare:
        return LiqMaterialIcons.medicalServices;
      case TransactionCategory.education:
        return LiqMaterialIcons.school;
      case TransactionCategory.salary:
        return LiqMaterialIcons.attachMoney;
      case TransactionCategory.investment:
        return LiqMaterialIcons.trendingUp;
      case TransactionCategory.gift:
        return LiqMaterialIcons.cardGiftcard;
      case TransactionCategory.other:
        return LiqMaterialIcons.category;
    }
  }

  Color _getCategoryColor(BuildContext context, TransactionCategory category) {
    final palette = context.appleColors;
    switch (category) {
      case TransactionCategory.shopping:
        return palette.blue;
      case TransactionCategory.food:
        return palette.orange;
      case TransactionCategory.transport:
        return palette.purple;
      case TransactionCategory.entertainment:
        return palette.pink;
      case TransactionCategory.bills:
        return palette.red;
      case TransactionCategory.healthcare:
        return palette.teal;
      case TransactionCategory.education:
        return palette.indigo;
      case TransactionCategory.salary:
        return palette.green;
      case TransactionCategory.investment:
        return palette.cyan;
      case TransactionCategory.gift:
        return palette.yellow;
      case TransactionCategory.other:
        return palette.gray;
    }
  }
}
