import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/wallet_home_screen.dart';

class WalletDemo extends StatelessWidget {
  const WalletDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: WalletHomeScreen(),
    );
  }
}