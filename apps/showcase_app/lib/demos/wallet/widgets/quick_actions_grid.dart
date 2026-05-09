import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_models.dart';
import '../screens/bills_screen.dart';
import '../screens/receive_screen.dart';
import '../screens/send_screen.dart';
import '../screens/topup_screen.dart';

class QuickActionsGrid extends ConsumerWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickActions = WalletSampleData.generateQuickActions();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return _QuickActionItem(
          action: action,
          onTap: () {
            final route = switch (action.id) {
              'send' => LiqPageRoute<void>(
                  builder: (_) => const SendScreen()),
              'receive' => LiqPageRoute<void>(
                  builder: (_) => const ReceiveScreen()),
              'pay' =>
                LiqPageRoute<void>(builder: (_) => const BillsScreen()),
              'topup' => LiqPageRoute<void>(
                  builder: (_) => const TopUpScreen()),
              _ => null,
            };
            if (route != null) Navigator.of(context).push(route);
          },
        );
      },
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final QuickAction action;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Whole tile (icon + label) lives inside the LiqCard, not just the icon.
    // This matches Apple Control-Center pills where both elements are part
    // of the same glass surface.
    return LiqCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              action.icon,
              color: action.color,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.title,
            style: context.textStyles.caption1.copyWith(
              fontWeight: LiqAppleTypography.medium,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
