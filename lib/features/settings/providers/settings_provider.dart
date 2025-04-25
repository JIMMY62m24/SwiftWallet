import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/currency.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  Currency _selectedCurrency = Currency.XOF;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  Currency get selectedCurrency => _selectedCurrency;

  Future<void> _loadSettings() async {
    final currencyCode = _prefs.getString('selected_currency') ?? 'XOF';
    _selectedCurrency = Currency.all.firstWhere(
      (c) => c.code == currencyCode,
      orElse: () => Currency.XOF,
    );
    notifyListeners();
  }

  Future<void> setCurrency(Currency currency) async {
    await _prefs.setString('selected_currency', currency.code);
    _selectedCurrency = currency;
    notifyListeners();
  }

  String formatAmount(double amount) {
    return _selectedCurrency.format(amount);
  }

  double convertToXOF(double amount) {
    return _selectedCurrency.convertToXOF(amount);
  }

  double convertFromXOF(double amount) {
    return _selectedCurrency.convertFromXOF(amount);
  }
}
