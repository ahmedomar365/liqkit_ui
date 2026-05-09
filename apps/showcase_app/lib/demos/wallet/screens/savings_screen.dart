import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/wallet_models.dart';
import '../models/wallet_providers.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingsGoals = ref.watch(savingsGoalsProvider);
    final totalSaved =
        ref.watch(savingsGoalsProvider.notifier).getTotalSaved();
    final totalTarget =
        ref.watch(savingsGoalsProvider.notifier).getTotalTarget();
    final overallProgress = totalTarget > 0 ? totalSaved / totalTarget : 0.0;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Savings',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(
            icon: LiqMaterialIcons.add,
            onPressed: () {},
            semanticLabel: 'Add savings goal',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: savingsGoals.isEmpty
          ? Center(
              child: LiqEmptyState(
                icon: Icon(
                  LiqMaterialIcons.savings,
                  size: 48,
                  color: context.appleColors.gray,
                ),
                iconBackground: true,
                title: 'No Savings Goals',
                description: 'Start saving for your dreams',
                cta: LiqEmptyStateCta(
                  label: 'Create Goal',
                  onPressed: () {},
                ),
              ),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            context.appleColors.green.withValues(alpha: 0.2),
                            context.appleColors.teal.withValues(alpha: 0.1),
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
                                  'Total Savings',
                                  style: context.textStyles.headline.secondary,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.appleColors.green
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${(overallProgress * 100).toInt()}%',
                                    style: context.textStyles.caption1
                                        .copyWith(
                                      color: context.appleColors.green,
                                      fontWeight: LiqAppleTypography.semibold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              r'$' + totalSaved.toStringAsFixed(2),
                              style: context.textStyles.largeTitle.copyWith(
                                fontSize: 36,
                                fontWeight: LiqAppleTypography.bold,
                              ),
                            ),
                            Text(
                              'of \$${totalTarget.toStringAsFixed(2)} goal',
                              style: context.textStyles.subheadline.secondary,
                            ),
                            const SizedBox(height: 16),
                            LiqProgressBar(
                              value: overallProgress,
                              height: 12,
                              backgroundColor: context.appleColors.gray
                                  .withValues(alpha: 0.2),
                              progressColor: context.appleColors.green,
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
                        final goal = savingsGoals[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SavingsGoalItem(
                            goal: goal,
                            onAddMoney: () => _AddMoneyDialog.show(
                              context: context,
                              goal: goal,
                              onAdd: (amount) {
                                ref
                                    .read(savingsGoalsProvider.notifier)
                                    .updateProgress(goal.id, amount);
                              },
                            ),
                          ),
                        );
                      },
                      childCount: savingsGoals.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }
}

class _SavingsGoalItem extends StatelessWidget {
  const _SavingsGoalItem({required this.goal, required this.onAddMoney});

  final SavingsGoal goal;
  final VoidCallback onAddMoney;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    final daysUntilTarget = goal.targetDate.difference(DateTime.now()).inDays;
    final progressPercentage = (goal.progress * 100).toInt();

    return LiqCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    goal.icon,
                    color: goal.color,
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
                      goal.name,
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    Text(
                      goal.description,
                      style: context.textStyles.subheadline.secondary,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$progressPercentage%',
                  style: context.textStyles.caption1.copyWith(
                    color: goal.color,
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LiqProgressBar(
            value: goal.progress,
            height: 8,
            backgroundColor: context.appleColors.gray.withValues(alpha: 0.2),
            progressColor: goal.color,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    r'$' + goal.currentAmount.toStringAsFixed(2),
                    style: context.textStyles.title3.copyWith(
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                  Text('Saved', style: context.textStyles.caption1.secondary),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    r'$' + goal.remaining.toStringAsFixed(2),
                    style: context.textStyles.title3.copyWith(
                      fontWeight: LiqAppleTypography.medium,
                      color: context.appleColors.secondaryLabel,
                    ),
                  ),
                  Text(
                    'Remaining',
                    style: context.textStyles.caption1.secondary,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    dateFormat.format(goal.targetDate),
                    style: context.textStyles.caption1.copyWith(
                      fontWeight: LiqAppleTypography.medium,
                    ),
                  ),
                  Text(
                    '$daysUntilTarget days left',
                    style: context.textStyles.caption2.secondary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LiqButton(
            label: 'Add Money',
            fullWidth: true,
            onPressed: onAddMoney,
          ),
        ],
      ),
    );
  }
}

class _AddMoneyDialog extends StatefulWidget {
  const _AddMoneyDialog({required this.goal, required this.onAdd});

  final SavingsGoal goal;
  final void Function(double) onAdd;

  static Future<void> show({
    required BuildContext context,
    required SavingsGoal goal,
    required void Function(double) onAdd,
  }) {
    final controller = TextEditingController();
    var amount = 0.0;
    return LiqAlert.show<void>(
      context: context,
      title: 'Add to ${goal.name}',
      content: StatefulBuilder(
        builder: (ctx, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LiqTextField(
              controller: controller,
              placeholder: r'$ Amount',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: <int>[10, 25, 50, 100].map((preset) {
                return LiqChip(
                  label: '\$$preset',
                  onPressed: () {
                    setState(() {
                      amount = preset.toDouble();
                      controller.text = preset.toString();
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        LiqAlertAction(
          label: 'Add',
          style: LiqAlertActionStyle.filled,
          onPressed: amount > 0
              ? () {
                  onAdd(amount);
                  Navigator.pop(context);
                }
              : null,
        ),
      ],
    );
  }

  @override
  State<_AddMoneyDialog> createState() => _AddMoneyDialogState();
}

class _AddMoneyDialogState extends State<_AddMoneyDialog> {
  // Stub: real dialog now lives in _AddMoneyDialog.show() above. This
  // state class is kept only because StatefulWidget requires it; the
  // widget is never inserted into the tree (only show() is called).
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
