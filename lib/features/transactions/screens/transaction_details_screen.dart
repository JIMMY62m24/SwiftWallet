import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../models/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMMM dd, yyyy HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textDark,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transaction Details',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAmountCard(),
            const SizedBox(height: 24),
            _buildDetailsCard(formatter),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTransactionIcon(),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: AppTypography.displayLarge.copyWith(
              color: Colors.white,
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
              color: _getStatusColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              transaction.status.toString().split('.').last.toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(DateFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            title: 'Transaction ID',
            value: transaction.id,
            copyable: true,
          ),
          const Divider(height: 32),
          _buildDetailRow(
            title: 'Type',
            value: transaction.type.toString().split('.').last.toUpperCase(),
          ),
          const Divider(height: 32),
          _buildDetailRow(
            title: 'Date & Time',
            value: formatter.format(transaction.date),
          ),
          const Divider(height: 32),
          _buildDetailRow(
            title: 'Status',
            value: transaction.status.toString().split('.').last.toUpperCase(),
            valueColor: _getStatusColor(),
          ),
          if (transaction.description != null) ...[
            const Divider(height: 32),
            _buildDetailRow(
              title: 'Description',
              value: transaction.description!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    Color? valueColor,
    bool copyable = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (copyable) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () {
              // TODO: Implement copy functionality
            },
            color: AppColors.primaryPurple,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ],
    );
  }

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.send:
        return Icons.arrow_upward;
      case TransactionType.receive:
        return Icons.arrow_downward;
      case TransactionType.deposit:
        return Icons.add;
      case TransactionType.withdraw:
        return Icons.remove;
    }
  }

  Color _getStatusColor() {
    switch (transaction.status) {
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
