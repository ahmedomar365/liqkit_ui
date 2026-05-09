import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/wallet_models.dart';

class PaymentCardWidget extends StatelessWidget {
  final PaymentCard card;
  final VoidCallback? onTap;

  const PaymentCardWidget({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[card.gradientStart, card.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          // Solid-color card (Apple Wallet style) — gradient IS the card's
          // identity. Do NOT overlay LiqGlassSurface here: the glass tint
          // would mute the brand colors and make the white text unreadable.
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _getCardTypeLogo(card.type),
                        if (card.isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: LiqColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  LiqIcons.lock,
                                  size: 14,
                                  color: LiqColors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Locked',
                                  style: context.textStyles.caption1.copyWith(
                                    color: LiqColors.white,
                                    fontWeight: LiqAppleTypography.semibold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          card.maskedNumber,
                          style: context.textStyles.title2.copyWith(
                            color: LiqColors.white,
                            fontWeight: LiqAppleTypography.medium,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Card Number',
                          style: context.textStyles.caption1.copyWith(
                            color: LiqColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              card.cardHolderName,
                              style: context.textStyles.headline.copyWith(
                                color: LiqColors.white,
                                fontWeight: LiqAppleTypography.semibold,
                              ),
                            ),
                            Text(
                              'Card Holder',
                              style: context.textStyles.caption1.copyWith(
                                color: LiqColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              card.expiryDate,
                              style: context.textStyles.headline.copyWith(
                                color: LiqColors.white,
                                fontWeight: LiqAppleTypography.semibold,
                              ),
                            ),
                            Text(
                              'Expires',
                              style: context.textStyles.caption1.copyWith(
                                color: LiqColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: LiqColors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    r'$' + card.balance.toStringAsFixed(2),
                    style: context.textStyles.body.copyWith(
                      color: LiqColors.white,
                      fontWeight: LiqAppleTypography.semibold,
                    ),
                  ),
                ),
              ),
              if (card.isDefault)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          context.appleColors.green.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          LiqMaterialIcons.checkCircle,
                          size: 14,
                          color: LiqColors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Default',
                          style: context.textStyles.caption1.copyWith(
                            color: LiqColors.white,
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCardTypeLogo(CardType type) {
    String logo;
    switch (type) {
      case CardType.visa:
        logo = 'VISA';
        break;
      case CardType.mastercard:
        logo = 'MC';
        break;
      case CardType.amex:
        logo = 'AMEX';
        break;
      case CardType.discover:
        logo = 'DISC';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: LiqColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        logo,
        style: const TextStyle(
          color: LiqColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
