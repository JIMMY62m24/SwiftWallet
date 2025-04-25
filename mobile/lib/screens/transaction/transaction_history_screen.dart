import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/transfer_service.dart';
import '../../theme/app_theme.dart';
import 'transaction_details_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

enum TransactionFilter { all, sent, received }

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransferService _transferService = TransferService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allTransactions = [];
  List<dynamic> _filteredTransactions = [];
  bool _isLoading = true;
  String? _error;
  TransactionFilter _currentFilter = TransactionFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        // Apply type filter
        if (_currentFilter != TransactionFilter.all) {
          final isSender =
              transaction['sender']['id'] == transaction['recipient']['id'];
          if (_currentFilter == TransactionFilter.sent && !isSender)
            return false;
          if (_currentFilter == TransactionFilter.received && isSender)
            return false;
        }

        // Apply search
        if (searchTerm.isEmpty) return true;

        final recipient = transaction['recipient'];
        final sender = transaction['sender'];
        final amount = transaction['amount'].toString();

        return recipient['name']?.toLowerCase().contains(searchTerm) ||
            recipient['phoneNumber'].toLowerCase().contains(searchTerm) ||
            sender['name']?.toLowerCase().contains(searchTerm) ||
            sender['phoneNumber'].toLowerCase().contains(searchTerm) ||
            amount.contains(searchTerm);
      }).toList();
    });
  }

  Future<void> _loadTransactions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final result = await _transferService.getTransactionHistory();

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success']) {
            _allTransactions = result['transactions'];
            _filterTransactions();
          } else {
            _error = result['message'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load transactions';
        });
      }
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE HH:mm').format(date);
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  String _formatAmount(num amount) {
    return NumberFormat.currency(
      symbol: 'XOF ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (_) => _filterTransactions(),
                ),
                const SizedBox(height: 16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'All',
                        TransactionFilter.all,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Sent',
                        TransactionFilter.sent,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Received',
                        TransactionFilter.received,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Transaction List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadTransactions,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTransactions,
                        child: _filteredTransactions.isEmpty
                            ? const Center(
                                child: Text('No transactions found'),
                              )
                            : ListView.builder(
                                itemCount: _filteredTransactions.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      _filteredTransactions[index];
                                  return _buildTransactionCard(transaction);
                                },
                              ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, TransactionFilter filter) {
    return FilterChip(
      label: Text(label),
      selected: _currentFilter == filter,
      onSelected: (selected) {
        setState(() {
          _currentFilter = filter;
          _filterTransactions();
        });
      },
      backgroundColor: Colors.white,
      selectedColor:
          Theme.of(context).colorScheme.primary.withValues(alpha: 26),
      checkmarkColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: _currentFilter == filter
            ? Theme.of(context).colorScheme.primary
            : Colors.black,
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isSender =
        transaction['sender']['id'] == transaction['recipient']['id'];
    final amount = transaction['amount'].toDouble();
    final otherParty =
        isSender ? transaction['recipient'] : transaction['sender'];

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                transaction: transaction,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                isSender ? Colors.red.shade100 : Colors.green.shade100,
            child: Icon(
              _getTransactionIcon(transaction['type']),
              color: isSender ? Colors.red : Colors.green,
            ),
          ),
          title: Text(
            otherParty['name'] ?? otherParty['phoneNumber'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _formatDate(transaction['createdAt']),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isSender ? '-' : '+'} ${_formatAmount(amount)}',
                style: TextStyle(
                  color: isSender ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transaction['fee'] != null)
                Text(
                  'Fee: ${_formatAmount(transaction['fee'])}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    if (type == 'sent') {
      return Icons.arrow_upward;
    } else if (type == 'received') {
      return Icons.arrow_downward;
    } else {
      return Icons.help;
    }
  }
}
