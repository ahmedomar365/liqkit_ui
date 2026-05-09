import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wallet_models.dart';

// Cards provider
final cardsProvider = StateNotifierProvider<CardsNotifier, List<PaymentCard>>((ref) {
  return CardsNotifier();
});

class CardsNotifier extends StateNotifier<List<PaymentCard>> {
  CardsNotifier() : super(WalletSampleData.generateCards());

  void toggleLock(String cardId) {
    state = state.map((card) {
      if (card.id == cardId) {
        return card.copyWith(isLocked: !card.isLocked);
      }
      return card;
    }).toList();
  }

  void setDefaultCard(String cardId) {
    state = state.map((card) {
      return card.copyWith(isDefault: card.id == cardId);
    }).toList();
  }

  void addCard(PaymentCard card) {
    state = [...state, card];
  }

  void removeCard(String cardId) {
    state = state.where((card) => card.id != cardId).toList();
  }
}

// Transactions provider
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<Transaction>>((ref) {
  return TransactionsNotifier();
});

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier() : super(WalletSampleData.generateTransactions());

  void addTransaction(Transaction transaction) {
    state = [transaction, ...state];
  }

  List<Transaction> getRecentTransactions({int limit = 5}) {
    return state.take(limit).toList();
  }

  List<Transaction> getTransactionsByType(TransactionType type) {
    return state.where((t) => t.type == type).toList();
  }

  List<Transaction> getTransactionsByCategory(TransactionCategory category) {
    return state.where((t) => t.category == category).toList();
  }

  double getTotalByType(TransactionType type) {
    return state
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }
}

// Bills provider
final billsProvider = StateNotifierProvider<BillsNotifier, List<Bill>>((ref) {
  return BillsNotifier();
});

class BillsNotifier extends StateNotifier<List<Bill>> {
  BillsNotifier() : super(WalletSampleData.generateBills());

  void payBill(String billId) {
    state = state.map((bill) {
      if (bill.id == billId) {
        return Bill(
          id: bill.id,
          name: bill.name,
          provider: bill.provider,
          amount: bill.amount,
          dueDate: bill.dueDate,
          status: BillStatus.paid,
          logo: bill.logo,
        );
      }
      return bill;
    }).toList();
  }

  List<Bill> getPendingBills() {
    return state.where((bill) => bill.status != BillStatus.paid).toList();
  }

  double getTotalPendingAmount() {
    return getPendingBills().fold(0.0, (sum, bill) => sum + bill.amount);
  }
}

// Savings goals provider
final savingsGoalsProvider = StateNotifierProvider<SavingsGoalsNotifier, List<SavingsGoal>>((ref) {
  return SavingsGoalsNotifier();
});

class SavingsGoalsNotifier extends StateNotifier<List<SavingsGoal>> {
  SavingsGoalsNotifier() : super(WalletSampleData.generateSavingsGoals());

  void updateProgress(String goalId, double amount) {
    state = state.map((goal) {
      if (goal.id == goalId) {
        return SavingsGoal(
          id: goal.id,
          name: goal.name,
          description: goal.description,
          targetAmount: goal.targetAmount,
          currentAmount: goal.currentAmount + amount,
          targetDate: goal.targetDate,
          icon: goal.icon,
          color: goal.color,
        );
      }
      return goal;
    }).toList();
  }

  double getTotalSaved() {
    return state.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  double getTotalTarget() {
    return state.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  }
}

// Statistics provider
final statisticsProvider = Provider<Map<String, dynamic>>((ref) {
  return WalletSampleData.getStatistics();
});

// Total balance provider
final totalBalanceProvider = Provider<double>((ref) {
  final cards = ref.watch(cardsProvider);
  return cards.fold(0.0, (sum, card) => sum + card.balance);
});

// Recent transactions provider
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.take(5).toList();
});

// Selected card provider
final selectedCardIndexProvider = StateProvider<int>((ref) => 0);

// Transaction filter provider
final transactionFilterProvider = StateProvider<TransactionFilter>((ref) => TransactionFilter.all);

enum TransactionFilter { all, income, expense }

// Filtered transactions provider
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final filter = ref.watch(transactionFilterProvider);

  switch (filter) {
    case TransactionFilter.all:
      return transactions;
    case TransactionFilter.income:
      return transactions.where((t) => t.type == TransactionType.income).toList();
    case TransactionFilter.expense:
      return transactions.where((t) => t.type == TransactionType.expense).toList();
  }
});

// Monthly spending provider
final monthlySpendingProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final now = DateTime.now();
  
  return transactions
      .where((t) => 
          t.type == TransactionType.expense &&
          t.timestamp.year == now.year &&
          t.timestamp.month == now.month)
      .fold(0.0, (sum, t) => sum + t.amount.abs());
});

// Monthly income provider
final monthlyIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final now = DateTime.now();
  
  return transactions
      .where((t) => 
          t.type == TransactionType.income &&
          t.timestamp.year == now.year &&
          t.timestamp.month == now.month)
      .fold(0.0, (sum, t) => sum + t.amount);
});