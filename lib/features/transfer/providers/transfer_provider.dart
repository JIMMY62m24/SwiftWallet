import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransferProvider extends ChangeNotifier {
  final String _baseUrl = 'YOUR_API_BASE_URL';
  bool _isLoading = false;
  String? _error;
  List<Transaction> _transactions = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Transaction> get transactions => _transactions;

  Future<void> sendMoney({
    required String recipientPhone,
    required double amount,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$_baseUrl/transfer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recipient_phone': recipientPhone,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send money: ${response.body}');
      }

      await fetchTransactions(); // Refresh transactions after successful transfer
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.get(
        Uri.parse('$_baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch transactions: ${response.body}');
      }

      final List<dynamic> transactionsJson = jsonDecode(response.body);
      _transactions =
          transactionsJson.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
