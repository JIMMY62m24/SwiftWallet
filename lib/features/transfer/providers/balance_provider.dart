import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceProvider extends ChangeNotifier {
  double _balance = 0;
  final SharedPreferences _prefs;

  BalanceProvider(this._prefs) {
    _loadBalance();
  }

  double get balance => _balance;

  Future<void> _loadBalance() async {
    _balance = _prefs.getDouble('user_balance') ??
        1000.0; // Default balance for testing
    notifyListeners();
  }

  Future<void> _saveBalance() async {
    await _prefs.setDouble('user_balance', _balance);
  }

  Future<bool> sendMoney(double amount) async {
    if (amount <= 0) return false;
    if (amount > _balance) return false;

    _balance -= amount;
    await _saveBalance();
    notifyListeners();
    return true;
  }

  Future<void> receiveMoney(double amount) async {
    if (amount <= 0) return;

    _balance += amount;
    await _saveBalance();
    notifyListeners();
  }

  Future<void> resetBalance() async {
    _balance = 1000.0; // Reset to default balance
    await _saveBalance();
    notifyListeners();
  }
}
