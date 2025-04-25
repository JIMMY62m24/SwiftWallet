import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransferService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/transfer';

  Future<Map<String, dynamic>> sendMoney({
    required String recipientPhoneNumber,
    required double amount,
    String? description,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'recipientPhoneNumber': recipientPhoneNumber,
          'amount': amount,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'transaction': data['transaction'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send money',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getTransactionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'transactions': data['transactions'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch transactions',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
