import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'transaction_details_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _animationController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchTransactions();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: _startDate ?? DateTime.now().subtract(const Duration(days: 7)),
      end: _endDate ?? DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });
      context.read<TransactionProvider>().setDateRange(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_startDate != null && _endDate != null) _buildDateRangeChip(),
          _buildFilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryPurple),
                    ),
                  );
                }

                if (provider.error != null) {
                  return _buildErrorState(provider);
                }

                if (provider.filteredTransactions.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildTransactionList(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.textDark,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Transaction History',
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          color: AppColors.textDark,
          onPressed: () => _selectDateRange(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_off),
          color: AppColors.textDark,
          onPressed: _clearAllFilters,
        ),
      ],
    );
  }

  Widget _buildDateRangeChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.date_range, size: 16, color: AppColors.primaryPurple),
            const SizedBox(width: 8),
            Text(
              '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              color: AppColors.primaryPurple,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _clearDateFilter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(null, 'All'),
          const SizedBox(width: 8),
          _buildFilterChip(TransactionType.send),
          const SizedBox(width: 8),
          _buildFilterChip(TransactionType.receive),
          const SizedBox(width: 8),
          _buildFilterChip(TransactionType.deposit),
          const SizedBox(width: 8),
          _buildFilterChip(TransactionType.withdraw),
        ],
      ),
    );
  }

  Widget _buildFilterChip(TransactionType? type, [String? label]) {
    final isSelected =
        context.watch<TransactionProvider>().selectedFilter == type;
    final chipLabel = label ?? type.toString().split('.').last.toUpperCase();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        label: Text(
          chipLabel,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          context.read<TransactionProvider>().setFilter(selected ? type : null);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryPurple,
        checkmarkColor: Colors.white,
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          prefixIcon: Icon(Icons.search, color: AppColors.primaryPurple),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearchQuery,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryPurple),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          context.read<TransactionProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildTransactionList(TransactionProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.refreshTransactions,
      color: AppColors.primaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = provider.filteredTransactions[index];
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.1,
                1.0,
                curve: Curves.easeOut,
              ),
            )),
            child: _buildTransactionCard(transaction),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TransactionDetailsScreen(transaction: transaction),
        ),
      ),
      child: Hero(
        tag: 'transaction-${transaction.id}',
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildTransactionIcon(transaction),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm')
                            .format(transaction.date),
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${transaction.type == TransactionType.send || transaction.type == TransactionType.withdraw ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                      style: AppTypography.titleMedium.copyWith(
                        color: _getAmountColor(transaction.type),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusChip(transaction.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionIcon(Transaction transaction) {
    final IconData icon;
    final Color color;

    switch (transaction.type) {
      case TransactionType.send:
        icon = Icons.arrow_upward;
        color = Colors.red;
        break;
      case TransactionType.receive:
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      case TransactionType.deposit:
        icon = Icons.add;
        color = Colors.green;
        break;
      case TransactionType.withdraw:
        icon = Icons.remove;
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusChip(TransactionStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toString().split('.').last.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: AppTypography.titleMedium.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(TransactionProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            provider.error!,
            style: AppTypography.titleMedium.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: provider.refreshTransactions,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearSearchQuery() {
    _searchController.clear();
    context.read<TransactionProvider>().setSearchQuery('');
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    context.read<TransactionProvider>().setDateRange(null, null);
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _startDate = null;
      _endDate = null;
    });
    context.read<TransactionProvider>().clearFilters();
  }

  Color _getAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.send:
      case TransactionType.withdraw:
        return Colors.red;
      case TransactionType.receive:
      case TransactionType.deposit:
        return Colors.green;
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.cancelled:
        return Colors.grey;
    }
  }
}
