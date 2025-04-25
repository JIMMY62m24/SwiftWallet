import 'package:flutter/material.dart';
import '../../services/transfer_service.dart';
import '../../theme/app_theme.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final _transferService = TransferService();
  List<dynamic> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final result = await _transferService.getTransactionHistory();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _transactions = result['transactions'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTransactions,
              child: _transactions.isEmpty
                  ? const Center(
                      child: Text('No transactions found'),
                    )
                  : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        final isSent = transaction['sender']['id'] ==
                            transaction['recipient']['id'];
                        final amount = transaction['amount'];
                        final otherParty = isSent
                            ? transaction['recipient']
                            : transaction['sender'];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSent
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              child: Icon(
                                isSent
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: isSent ? Colors.red : Colors.green,
                              ),
                            ),
                            title: Text(
                              otherParty['name'] ?? otherParty['phoneNumber'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              transaction['description'] ?? 'No description',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isSent ? '-' : '+'} \$${amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isSent ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _formatDate(transaction['createdAt']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
}
