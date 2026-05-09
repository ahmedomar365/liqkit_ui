import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/travel_home_screen.dart';

class TravelDemo extends StatelessWidget {
  const TravelDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: TravelHomeScreen(),
    );
  }
}