import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

class User {
  final String phoneNumber;
  final String name;
  final double balance;

  User({
    required this.phoneNumber,
    required this.name,
    this.balance = 0.0,
  });
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _token;
  String? _phoneNumber;
  String? _name;
  double _balance = 0.0;
  bool _isAuthenticated = false;
  User? _user;
  final SharedPreferences _prefs;

  AuthStatus get status => _status;
  String? get token => _token;
  String? get phoneNumber => _phoneNumber;
  String? get name => _name;
  double get balance => _balance;
  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  AuthProvider(this._prefs) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    _isAuthenticated = _prefs.getBool('is_authenticated') ?? false;
    if (_isAuthenticated) {
      _user = User(
        phoneNumber: _prefs.getString('user_phone') ?? '',
        name: _prefs.getString('user_name') ?? '',
        balance: _prefs.getDouble('user_balance') ?? 0.0,
      );
      _balance = _user!.balance;
    }
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // TODO: Implement actual API call to backend
      // For now, we'll simulate a successful registration
      await Future.delayed(const Duration(seconds: 2));

      // Validate password
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      final prefs = await SharedPreferences.getInstance();
      const mockToken = 'mock_token_12345';

      await prefs.setString('auth_token', mockToken);
      await prefs.setString('phone_number', phone);
      await prefs.setString('name', name);

      _token = mockToken;
      _phoneNumber = phone;
      _name = name;
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      throw e.toString();
    }
  }

  Future<void> loginWithPhone(String phone, String password) async {
    try {
      // TODO: Implement actual API call to backend
      // For now, we'll simulate a successful login
      await Future.delayed(const Duration(seconds: 2));

      // Validate credentials (mock validation)
      if (password.length < 6) {
        throw 'Invalid password';
      }

      // Save authentication state
      await _prefs.setBool('is_authenticated', true);
      await _prefs.setString('user_phone', phone);
      await _prefs.setString('user_name', 'Test User');
      await _prefs.setDouble('user_balance', 1000.0); // Mock balance

      // Update state
      _isAuthenticated = true;
      _balance = 1000.0; // Mock balance
      _user = User(
        phoneNumber: phone,
        name: 'Test User',
        balance: _balance,
      );

      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      _balance = 0.0;
      await _prefs.setBool('is_authenticated', false);
      notifyListeners();
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _prefs.clear();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      throw 'Failed to logout: ${e.toString()}';
    }
  }
}
