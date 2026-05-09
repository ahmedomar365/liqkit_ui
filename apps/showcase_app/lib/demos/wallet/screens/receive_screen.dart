import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

import '../models/wallet_providers.dart';

class ReceiveScreen extends ConsumerWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsProvider);
    final selectedIndex = ref.watch(selectedCardIndexProvider);
    final card = cards.isNotEmpty
        ? cards[selectedIndex.clamp(0, cards.length - 1)]
        : null;
    final accountId =
        card == null ? '@ahmedomar' : '@${card.cardHolderName.toLowerCase().replaceAll(' ', '')}';

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Receive',
          style: context.textStyles.title2.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // QR placeholder using nested glass surfaces
            Center(
              child: LiqCard(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: LiqColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.appleColors.gray.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      LiqMaterialIcons.qrCodeScanner,
                      size: 180,
                      color: LiqColors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(accountId,
                style: context.textStyles.title2.copyWith(
                    fontWeight: LiqAppleTypography.bold)),
            const SizedBox(height: 8),
            Text(
              'Share this code or your @handle to receive money.',
              style: context.textStyles.subheadline.secondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: LiqButton(
                    label: 'Copy',
                    style: LiqButtonStyle.borderedSecondary,
                    fullWidth: true,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LiqButton(
                    label: 'Share',
                    fullWidth: true,
                    onPressed: () {},
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
