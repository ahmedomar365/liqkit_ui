import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_providers.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingDetails = ref.watch(bookingDetailsProvider);
    final destination = bookingDetails.selectedDestination;
    final isDark = LiqTheme.of(context).brightness == Brightness.dark;

    if (destination == null) {
      return const LiqScaffold(
        body: Center(child: Text('No destination selected')),
      );
    }

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Book Your Stay',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LiqCard(
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      destination.images.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          destination.name,
                          style: context.textStyles.headline.copyWith(
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(
                              LiqMaterialIcons.locationOn,
                              size: 14,
                              color: context.appleColors.tertiaryLabel,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              destination.country,
                              style:
                                  context.textStyles.subheadline.secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Travel Dates',
              style: context.textStyles.title3.copyWith(
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _DateSelector(
                    label: 'Check-in',
                    date: bookingDetails.checkIn,
                    onTap: () async {
                      final date = await LiqDatePickerModal.show(
                        context: context,
                        initialDate:
                            bookingDetails.checkIn ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        ref
                            .read(bookingDetailsProvider.notifier)
                            .updateCheckIn(date);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DateSelector(
                    label: 'Check-out',
                    date: bookingDetails.checkOut,
                    onTap: () async {
                      final date = await LiqDatePickerModal.show(
                        context: context,
                        initialDate: bookingDetails.checkOut ??
                            DateTime.now().add(const Duration(days: 1)),
                        firstDate: bookingDetails.checkIn ?? DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        ref
                            .read(bookingDetailsProvider.notifier)
                            .updateCheckOut(date);
                      }
                    },
                  ),
                ),
              ],
            ),
            if (bookingDetails.nights > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${bookingDetails.nights} nights',
                  style: context.textStyles.caption1.copyWith(
                    color: context.appleColors.blue,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Guests',
              style: context.textStyles.title3.copyWith(
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _GuestCounter(
                    label: 'Adults',
                    count: bookingDetails.adults,
                    onIncrement: () {
                      ref
                          .read(bookingDetailsProvider.notifier)
                          .updateAdults(bookingDetails.adults + 1);
                    },
                    onDecrement: () {
                      if (bookingDetails.adults > 1) {
                        ref
                            .read(bookingDetailsProvider.notifier)
                            .updateAdults(bookingDetails.adults - 1);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GuestCounter(
                    label: 'Children',
                    count: bookingDetails.children,
                    onIncrement: () {
                      ref
                          .read(bookingDetailsProvider.notifier)
                          .updateChildren(bookingDetails.children + 1);
                    },
                    onDecrement: () {
                      if (bookingDetails.children > 0) {
                        ref
                            .read(bookingDetailsProvider.notifier)
                            .updateChildren(bookingDetails.children - 1);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (bookingDetails.nights > 0) ...<Widget>[
              Text(
                'Price Details',
                style: context.textStyles.title3.copyWith(
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
              const SizedBox(height: 12),
              LiqCard(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '\$${destination.pricePerNight.toInt()} x ${bookingDetails.nights} nights',
                          style: context.textStyles.body,
                        ),
                        Text(
                          r'$' +
                              (destination.pricePerNight *
                                      bookingDetails.nights)
                                  .toInt()
                                  .toString(),
                          style: context.textStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Service fee', style: context.textStyles.body),
                        Text(
                          r'$' +
                              (bookingDetails.totalPrice * 0.1)
                                  .toInt()
                                  .toString(),
                          style: context.textStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24, child: Center(child: LiqDivider())),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: context.textStyles.headline.copyWith(
                            fontWeight: LiqAppleTypography.bold,
                          ),
                        ),
                        Text(
                          r'$' +
                              (bookingDetails.totalPrice * 1.1)
                                  .toInt()
                                  .toString(),
                          style: context.textStyles.headline.copyWith(
                            fontWeight: LiqAppleTypography.bold,
                            color: context.appleColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(
              color: LiqColors.grey.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: LiqButton(
            label: 'Confirm Booking',
            fullWidth: true,
            onPressed: bookingDetails.checkIn != null &&
                    bookingDetails.checkOut != null
                ? () {
                    LiqAlert.show<void>(
                      context: context,
                      title: 'Booking Confirmed!',
                      description:
                          'Your stay at ${destination.name} has been booked for '
                          '${bookingDetails.nights} nights.',
                      actions: [
                        LiqAlertAction(
                          label: 'OK',
                          style: LiqAlertActionStyle.filled,
                          onPressed: () {
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                          },
                        ),
                      ],
                    );
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: context.textStyles.caption1.secondary),
          const SizedBox(height: 4),
          Text(
            date != null
                ? '${date!.day}/${date!.month}/${date!.year}'
                : 'Select date',
            style: context.textStyles.body.copyWith(
              fontWeight: date != null ? LiqAppleTypography.semibold : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestCounter extends StatelessWidget {
  const _GuestCounter({
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: context.textStyles.caption1.secondary),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LiqIconButton(icon: LiqMaterialIcons.removeCircleOutline,
                onPressed: onDecrement,
                iconSize: 28,
              ),
              Text(
                count.toString(),
                style: context.textStyles.title3.copyWith(
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
              LiqIconButton(icon: LiqMaterialIcons.addCircleOutline,
                onPressed: onIncrement,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
