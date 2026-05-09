import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/ecommerce_home_screen.dart';

class EcommerceDemo extends StatelessWidget {
  const EcommerceDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: EcommerceHomeScreen(),
    );
  }
}