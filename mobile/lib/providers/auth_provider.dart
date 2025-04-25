import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:5000/api/auth';
  bool _isAuthenticated = false;
  String? _token;
  String? _phoneNumber;
  String? _name;
  String? _userId;
  User? _user;
  final _storage = const FlutterSecureStorage();

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get phoneNumber => _phoneNumber;
  String? get name => _name;
  String? get userId => _userId;
  bool get isLoggedIn => _user != null;

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
      debugPrint('Login attempt with: $phoneNumber');
      // Simulate API delay
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

  Future<void> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = User(
          id: data['id'],
          phoneNumber: data['phoneNumber'],
          name: data['name'],
          balance: data['balance'],
          isMerchant: data['isMerchant'],
        );
        notifyListeners();
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (e) {
      debugPrint('Error getting user data: $e');
      rethrow;
    }
  }
}

/// Represents a user in the application.
@immutable
class User {
  /// The unique identifier of the user.
  final int id;

  /// The phone number of the user.
  final String phoneNumber;

  /// The display name of the user.
  final String name;

  /// The current balance of the user's account.
  final double balance;

  /// Whether the user is a merchant or not.
  final bool isMerchant;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.balance,
    required this.isMerchant,
  });
}
