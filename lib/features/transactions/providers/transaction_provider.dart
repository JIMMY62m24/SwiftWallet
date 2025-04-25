import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  TransactionType? _selectedFilter;
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TransactionType? get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // For demo purposes, we'll use mock data
  Future<void> fetchTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data with more varied transactions
      _transactions = [
        Transaction(
          id: '1',
          title: 'Request from Diop',
          amount: 20.00,
          date: DateTime.now().subtract(const Duration(hours: 2)),
          type: TransactionType.receive,
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '2',
          title: 'Chez Diallo',
          amount: 5.00,
          date: DateTime.now().subtract(const Duration(hours: 5)),
          type: TransactionType.send,
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '3',
          title: 'Tamba',
          amount: 12.00,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.send,
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '4',
          title: 'Deposit to Wallet',
          amount: 50.00,
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.deposit,
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '5',
          title: 'Withdraw to Bank',
          amount: 30.00,
          date: DateTime.now().subtract(const Duration(days: 3)),
          type: TransactionType.withdraw,
          status: TransactionStatus.pending,
        ),
        Transaction(
          id: '6',
          title: 'Market Payment',
          amount: 25.00,
          date: DateTime.now().subtract(const Duration(days: 4)),
          type: TransactionType.send,
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '7',
          title: 'Salary Deposit',
          amount: 1000.00,
          date: DateTime.now().subtract(const Duration(days: 5)),
          type: TransactionType.deposit,
          status: TransactionStatus.completed,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load transactions';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(TransactionType? type) {
    _selectedFilter = type;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  List<Transaction> get filteredTransactions {
    return _transactions.where((transaction) {
      // Apply type filter
      if (_selectedFilter != null && transaction.type != _selectedFilter) {
        return false;
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchIn = [
          transaction.title.toLowerCase(),
          transaction.description?.toLowerCase() ?? '',
          transaction.amount.toString(),
          transaction.type.toString().toLowerCase(),
          transaction.status.toString().toLowerCase(),
        ].join(' ');

        if (!searchIn.contains(_searchQuery)) {
          return false;
        }
      }

      // Apply date range filter
      if (_startDate != null) {
        if (transaction.date.isBefore(_startDate!)) {
          return false;
        }
      }

      if (_endDate != null) {
        if (transaction.date.isAfter(_endDate!.add(const Duration(days: 1)))) {
          return false;
        }
      }

      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
  }

  Future<void> refreshTransactions() async {
    await fetchTransactions();
  }

  double get totalBalance {
    return _transactions.fold(0, (sum, transaction) {
      switch (transaction.type) {
        case TransactionType.receive:
        case TransactionType.deposit:
          return sum + transaction.amount;
        case TransactionType.send:
        case TransactionType.withdraw:
          return sum - transaction.amount;
      }
    });
  }

  void clearFilters() {
    _selectedFilter = null;
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }
}
