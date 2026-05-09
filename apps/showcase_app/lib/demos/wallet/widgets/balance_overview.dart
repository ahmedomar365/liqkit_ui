import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_providers.dart';

class BalanceOverview extends ConsumerWidget {
  const BalanceOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlySpending = ref.watch(monthlySpendingProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: LiqCard(
        padding: const EdgeInsets.all(24),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total Balance',
                    style: context.textStyles.headline.secondary,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          context.appleColors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          LiqMaterialIcons.trendingUp,
                          size: 16,
                          color: context.appleColors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+12.5%',
                          style: context.textStyles.caption1.copyWith(
                            color: context.appleColors.green,
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                r'$' + totalBalance.toStringAsFixed(2),
                style: context.textStyles.largeTitle.copyWith(
                  fontSize: 42,
                  fontWeight: LiqAppleTypography.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatItem(
                      icon: LiqMaterialIcons.arrowDownward,
                      iconColor: context.appleColors.green,
                      title: 'Income',
                      subtitle: 'This month',
                      value: r'$' + monthlyIncome.toStringAsFixed(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatItem(
                      icon: LiqMaterialIcons.arrowUpward,
                      iconColor: context.appleColors.red,
                      title: 'Spending',
                      subtitle: 'This month',
                      value: r'$' + monthlySpending.toStringAsFixed(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: context.textStyles.caption1.secondary,
                ),
                Text(
                  subtitle,
                  style: context.textStyles.caption2.secondary,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.semibold,
          ),
        ),
      ],
    );
  }
}
