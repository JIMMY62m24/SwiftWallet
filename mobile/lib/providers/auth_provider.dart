import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  String? _phoneNumber;
  String? _name;
  String? _userId;
  final _storage = const FlutterSecureStorage();

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get phoneNumber => _phoneNumber;
  String? get name => _name;
  String? get userId => _userId;

  // Initialize the auth state
  Future<void> init() async {
    _token = await _storage.read(key: 'token');
    _phoneNumber = await _storage.read(key: 'phone_number');
    _name = await _storage.read(key: 'name');
    _userId = await _storage.read(key: 'user_id');
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  // Register
  Future<bool> register(
      String name, String phoneNumber, String password) async {
    try {
      // TODO: Implement actual API call
      // For now, we'll simulate a successful registration
      await Future.delayed(const Duration(seconds: 1));

      // Generate a unique user ID
      final userId = const Uuid().v4();

      // Store the user data
      await _storage.write(key: 'token', value: 'dummy_token');
      await _storage.write(key: 'phone_number', value: phoneNumber);
      await _storage.write(key: 'name', value: name);
      await _storage.write(key: 'user_id', value: userId);

      _token = 'dummy_token';
      _phoneNumber = phoneNumber;
      _name = name;
      _userId = userId;
      _isAuthenticated = true;

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Login
  Future<bool> login(String phoneNumber, String password) async {
    try {
      // TODO: Implement actual API call
      // For now, we'll simulate a successful login
      await Future.delayed(const Duration(seconds: 1));

      // Generate a unique user ID if not exists
      final userId = const Uuid().v4();

      // Store the user data
      await _storage.write(key: 'token', value: 'dummy_token');
      await _storage.write(key: 'phone_number', value: phoneNumber);
      await _storage.write(key: 'user_id', value: userId);

      _token = 'dummy_token';
      _phoneNumber = phoneNumber;
      _userId = userId;
      _isAuthenticated = true;

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.deleteAll();
    _token = null;
    _phoneNumber = null;
    _name = null;
    _userId = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check if user is logged in
  Future<bool> checkAuth() async {
    _token = await _storage.read(key: 'token');
    return _token != null;
  }
}
