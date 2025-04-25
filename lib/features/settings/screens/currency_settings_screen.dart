import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/currency.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class CurrencySettingsScreen extends StatelessWidget {
  const CurrencySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final selectedCurrency = settingsProvider.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Settings'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: Currency.all.length,
        itemBuilder: (context, index) {
          final currency = Currency.all[index];
          final isSelected = currency.code == selectedCurrency.code;

          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  currency.symbol,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ),
            title: Text(
              currency.name,
              style: AppTypography.titleMedium,
            ),
            subtitle: Text(
              currency.code,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: AppColors.primaryPurple,
                  )
                : null,
            onTap: () {
              settingsProvider.setCurrency(currency);
            },
          );
        },
      ),
    );
  }
}
