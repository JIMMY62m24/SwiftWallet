import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM d, y HH:mm').format(date);
  }

  String _formatAmount(num amount) {
    return NumberFormat.currency(
      symbol: 'XOF ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final isSender =
        transaction['sender']['id'] == transaction['recipient']['id'];
    final amount = transaction['amount'].toDouble();
    final fee = transaction['fee']?.toDouble() ?? 0.0;
    final receiveAmount = amount - fee;
    final otherParty =
        isSender ? transaction['recipient'] : transaction['sender'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: isSender
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                      child: Icon(
                        isSender ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isSender ? Colors.red : Colors.green,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatAmount(amount),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        transaction['status'] ?? 'SUCCESS',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Transaction Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Type',
                      isSender ? 'Sent' : 'Received',
                    ),
                    _buildDetailRow(
                      'Date',
                      _formatDate(transaction['createdAt']),
                    ),
                    _buildDetailRow(
                      'Transaction ID',
                      transaction['id'],
                    ),
                    if (transaction['description'] != null)
                      _buildDetailRow(
                        'Description',
                        transaction['description'],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Amount Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Amount',
                      _formatAmount(amount),
                    ),
                    _buildDetailRow(
                      'Fee',
                      _formatAmount(fee),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      isSender ? 'Amount Sent' : 'Amount Received',
                      _formatAmount(isSender ? amount : receiveAmount),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Recipient/Sender Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSender ? 'Recipient Details' : 'Sender Details',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Name',
                      otherParty['name'] ?? 'N/A',
                    ),
                    _buildDetailRow(
                      'Phone Number',
                      otherParty['phoneNumber'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
