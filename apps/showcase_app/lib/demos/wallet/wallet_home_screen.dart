import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class WalletHomeScreen extends StatelessWidget {
  const WalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('My Wallet')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Total Balance', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              r'$2,456.78',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Main Card'),
            Text('Default'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Send'),
                Text('Receive'),
                Text('Pay Bills'),
                Text('Top Up'),
              ],
            ),
            SizedBox(height: 20),
            Text('Recent Transactions'),
            Text('View All'),
            SizedBox(height: 10),
            Text('Income'),
            Text('Expenses'),
            SizedBox(height: 20),
            Text('Transactions'),
            Text('Cards'),
            Text('Bills'),
            Text('Savings'),
          ],
        ),
      ),
    );
  }
}
