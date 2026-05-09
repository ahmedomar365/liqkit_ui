import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

// Payment card model
class PaymentCard {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final CardType type;
  final Color gradientStart;
  final Color gradientEnd;
  final double balance;
  final bool isDefault;
  final bool isLocked;

  const PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.type,
    required this.gradientStart,
    required this.gradientEnd,
    required this.balance,
    this.isDefault = false,
    this.isLocked = false,
  });

  String get maskedNumber {
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '•••• •••• •••• $last4';
  }

  PaymentCard copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    CardType? type,
    Color? gradientStart,
    Color? gradientEnd,
    double? balance,
    bool? isDefault,
    bool? isLocked,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      type: type ?? this.type,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      balance: balance ?? this.balance,
      isDefault: isDefault ?? this.isDefault,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

// Transaction model
class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime timestamp;
  final IconData? merchantLogo;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.timestamp,
    this.merchantLogo,
    this.status = TransactionStatus.completed,
  });
}

// Quick action model
class QuickAction {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const QuickAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

// Bill model
class Bill {
  final String id;
  final String name;
  final String provider;
  final double amount;
  final DateTime dueDate;
  final BillStatus status;
  final IconData? logo;

  const Bill({
    required this.id,
    required this.name,
    required this.provider,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.logo,
  });
}

// Savings goal model
class SavingsGoal {
  final String id;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final IconData icon;
  final Color color;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.icon,
    required this.color,
  });

  double get progress => currentAmount / targetAmount;
  double get remaining => targetAmount - currentAmount;
}

// Enums
enum CardType { visa, mastercard, amex, discover }
enum TransactionType { income, expense, transfer }
enum TransactionCategory {
  shopping,
  food,
  transport,
  entertainment,
  bills,
  healthcare,
  education,
  other,
  salary,
  investment,
  gift
}
enum TransactionStatus { pending, completed, failed }
enum BillStatus { paid, pending, overdue }

// Sample data
class WalletSampleData {
  static List<PaymentCard> generateCards() {
    return [
      PaymentCard(
        id: '1',
        cardNumber: '4532123456789012',
        cardHolderName: 'JOHN DOE',
        expiryDate: '12/25',
        type: CardType.visa,
        gradientStart: const Color(0xFF1E3C72),
        gradientEnd: const Color(0xFF2A5298),
        balance: 5420.50,
        isDefault: true,
      ),
      PaymentCard(
        id: '2',
        cardNumber: '5412345678901234',
        cardHolderName: 'JOHN DOE',
        expiryDate: '08/24',
        type: CardType.mastercard,
        gradientStart: const Color(0xFFEB3349),
        gradientEnd: const Color(0xFFF45C43),
        balance: 3200.00,
      ),
      PaymentCard(
        id: '3',
        cardNumber: '371234567890123',
        cardHolderName: 'JOHN DOE',
        expiryDate: '03/26',
        type: CardType.amex,
        gradientStart: const Color(0xFF11998E),
        gradientEnd: const Color(0xFF38EF7D),
        balance: 8750.75,
      ),
    ];
  }

  static List<Transaction> generateTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: '1',
        title: 'Apple Store',
        description: 'MacBook Pro 16"',
        amount: -2499.00,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        timestamp: now.subtract(const Duration(hours: 2)),
        merchantLogo: LiqMaterialIcons.shoppingBagOutlined,
      ),
      Transaction(
        id: '2',
        title: 'Salary',
        description: 'Monthly Salary',
        amount: 5000.00,
        type: TransactionType.income,
        category: TransactionCategory.salary,
        timestamp: now.subtract(const Duration(days: 1)),
        merchantLogo: LiqMaterialIcons.paymentsOutlined,
      ),
      Transaction(
        id: '3',
        title: 'Starbucks',
        description: 'Coffee & Snacks',
        amount: -12.50,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        timestamp: now.subtract(const Duration(days: 1, hours: 8)),
        merchantLogo: LiqMaterialIcons.localCafeOutlined,
      ),
      Transaction(
        id: '4',
        title: 'Uber',
        description: 'Ride to Downtown',
        amount: -18.75,
        type: TransactionType.expense,
        category: TransactionCategory.transport,
        timestamp: now.subtract(const Duration(days: 2)),
        merchantLogo: LiqMaterialIcons.directionsCarOutlined,
      ),
      Transaction(
        id: '5',
        title: 'Netflix',
        description: 'Monthly Subscription',
        amount: -15.99,
        type: TransactionType.expense,
        category: TransactionCategory.entertainment,
        timestamp: now.subtract(const Duration(days: 3)),
        merchantLogo: LiqMaterialIcons.movieOutlined,
        status: TransactionStatus.pending,
      ),
    ];
  }

  static List<QuickAction> generateQuickActions() {
    return [
      QuickAction(
        id: 'send',
        title: 'Send',
        icon: LiqMaterialIcons.send,
        color: LiqColors.blue,
      ),
      QuickAction(
        id: 'receive',
        title: 'Receive',
        icon: LiqIcons.download,
        color: LiqColors.green,
      ),
      QuickAction(
        id: 'pay',
        title: 'Pay Bills',
        icon: LiqMaterialIcons.receipt,
        color: LiqColors.orange,
      ),
      QuickAction(
        id: 'topup',
        title: 'Top Up',
        icon: LiqMaterialIcons.addCard,
        color: LiqColors.purple,
      ),
    ];
  }

  static List<Bill> generateBills() {
    final now = DateTime.now();
    return [
      Bill(
        id: '1',
        name: 'Electricity',
        provider: 'City Power Co.',
        amount: 125.50,
        dueDate: now.add(const Duration(days: 5)),
        status: BillStatus.pending,
        logo: LiqMaterialIcons.boltOutlined,
      ),
      Bill(
        id: '2',
        name: 'Internet',
        provider: 'FiberNet',
        amount: 79.99,
        dueDate: now.add(const Duration(days: 10)),
        status: BillStatus.pending,
        logo: LiqIcons.wifi,
      ),
      Bill(
        id: '3',
        name: 'Water',
        provider: 'City Water',
        amount: 45.00,
        dueDate: now.subtract(const Duration(days: 2)),
        status: BillStatus.overdue,
        logo: LiqMaterialIcons.waterDropOutlined,
      ),
    ];
  }

  static List<SavingsGoal> generateSavingsGoals() {
    return [
      SavingsGoal(
        id: '1',
        name: 'New Car',
        description: 'Tesla Model 3',
        targetAmount: 45000,
        currentAmount: 12500,
        targetDate: DateTime.now().add(const Duration(days: 365)),
        icon: LiqMaterialIcons.directionsCarOutlined,
        color: LiqColors.blue,
      ),
      SavingsGoal(
        id: '2',
        name: 'Vacation',
        description: 'Trip to Japan',
        targetAmount: 5000,
        currentAmount: 3200,
        targetDate: DateTime.now().add(const Duration(days: 180)),
        icon: LiqMaterialIcons.flightOutlined,
        color: LiqColors.orange,
      ),
      SavingsGoal(
        id: '3',
        name: 'Emergency Fund',
        description: '6 months expenses',
        targetAmount: 20000,
        currentAmount: 15000,
        targetDate: DateTime.now().add(const Duration(days: 90)),
        icon: LiqMaterialIcons.accountBalanceOutlined,
        color: LiqColors.green,
      ),
    ];
  }

  static Map<String, dynamic> getStatistics() {
    return {
      'totalBalance': 17371.25,
      'monthlyIncome': 5000.00,
      'monthlyExpense': 3245.74,
      'savingsRate': 0.35,
      'spendingByCategory': {
        TransactionCategory.shopping: 2499.00,
        TransactionCategory.food: 342.50,
        TransactionCategory.transport: 189.25,
        TransactionCategory.entertainment: 89.99,
        TransactionCategory.bills: 125.00,
      },
    };
  }
}