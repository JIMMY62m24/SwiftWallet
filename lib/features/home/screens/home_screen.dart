import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/transactions/screens/transaction_history_screen.dart';
import '../../../features/settings/screens/account_settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../features/settings/providers/settings_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../features/transfer/screens/send_money_screen.dart';
import '../../../features/transfer/screens/receive_money_screen.dart';
import '../../../features/settings/screens/currency_settings_screen.dart';
import '../../../features/transfer/screens/qr_scanner_screen.dart';
import '../../../features/transfer/screens/contact_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;

  Future<void> _showLogoutConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red[700],
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Logout',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to logout?',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleLogout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    try {
      await context.read<AuthProvider>().logout();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSendPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.select((AuthProvider p) => p.balance);
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 12),
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'Account',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMenuTile(
                                            icon: Icons.account_circle_outlined,
                                            title: 'Profile',
                                            subtitle:
                                                'View and edit your profile',
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AccountSettingsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.person_add_outlined,
                                            title: 'Add Another Account',
                                            subtitle:
                                                'Manage multiple accounts',
                                            onTap: () {
                                              // TODO: Implement add account
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'Activity',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMenuTile(
                                            icon: Icons.history_rounded,
                                            title: 'Transaction History',
                                            subtitle:
                                                'View your past transactions',
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TransactionHistoryScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.description_outlined,
                                            title: 'Check Limits',
                                            subtitle:
                                                'View your transaction limits',
                                            onTap: () {
                                              // TODO: Implement limits screen
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'Share',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMenuTile(
                                            icon: Icons.share_outlined,
                                            title: 'Invite Friends',
                                            subtitle:
                                                'Share SwiftWallet with friends',
                                            onTap: () {
                                              // TODO: Implement invite
                                            },
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.card_giftcard_outlined,
                                            title: 'Redeem Promo Code',
                                            subtitle: 'Enter a promo code',
                                            onTap: () {
                                              // TODO: Implement promo code
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'Security',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMenuTile(
                                            icon: Icons.devices_outlined,
                                            title: 'Connected Devices',
                                            subtitle: 'Manage your devices',
                                            onTap: () {
                                              // TODO: Implement devices screen
                                            },
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.lock_reset_outlined,
                                            title: 'Reset Secret Code',
                                            subtitle:
                                                'Change your security code',
                                            onTap: () {
                                              // TODO: Implement reset code
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'Settings',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMenuTile(
                                            icon: Icons.currency_exchange,
                                            title: 'Currency Settings',
                                            subtitle:
                                                'Change your preferred currency',
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CurrencySettingsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.notifications_outlined,
                                            title: 'Notification Settings',
                                            subtitle:
                                                'Manage your notifications',
                                            onTap: () {
                                              // TODO: Implement notification settings
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'Support',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMenuTile(
                                            icon: Icons.help_outline_rounded,
                                            title: 'Help & Support',
                                            subtitle:
                                                'Get assistance and support',
                                            onTap: () {
                                              // TODO: Implement help & support
                                            },
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.location_on_outlined,
                                            title: 'Find Nearby Agents',
                                            subtitle:
                                                'Locate SwiftWallet agents',
                                            onTap: () {
                                              // TODO: Implement agent locator
                                            },
                                          ),
                                          const Divider(
                                            height: 32,
                                            thickness: 1,
                                          ),
                                          _buildMenuTile(
                                            icon: Icons.logout_rounded,
                                            title: 'Logout',
                                            subtitle:
                                                'Sign out from your account',
                                            isDestructive: true,
                                            onTap: () {
                                              Navigator.pop(context);
                                              _showLogoutConfirmation();
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Icon(
                          Icons.more_vert,
                          color: AppColors.primaryPurple,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBalanceCard(context, balance, settingsProvider),
                    _buildQuickActions(context),
                    _buildRecentTransactions(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    double balance,
    SettingsProvider settingsProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple,
            AppColors.primaryPurple.withOpacity(0.95),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isBalanceVisible
                      ? settingsProvider.formatAmount(balance)
                      : '••••••',
                  style: AppTypography.amountLarge.copyWith(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                  child: Icon(
                    _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildQRContainer(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReceiveMoneyScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: Icon(Icons.add, color: AppColors.primaryPurple),
                      label: Text(
                        'Deposit',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      onPressed: _onSendPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QRScannerScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: QrImageView(
                  data:
                      'swiftwallet://transfer?phone=${context.read<AuthProvider>().user?.phoneNumber ?? ""}&name=${context.read<AuthProvider>().user?.name ?? ""}',
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Scan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            icon: Icons.payment,
            label: 'Payment',
            color: AppColors.primaryPurple.withOpacity(0.8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactSelectionScreen(),
                ),
              );
            },
          ),
          _buildQuickActionButton(
            icon: Icons.account_balance,
            label: 'Bank',
            color: AppColors.primaryPurple.withOpacity(0.8),
            onTap: () {
              // TODO: Implement bank transfer screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bank transfer coming soon!'),
                ),
              );
            },
          ),
          _buildQuickActionButton(
            icon: Icons.lock,
            label: 'Vault',
            color: AppColors.primaryPurple.withOpacity(0.8),
            onTap: () {
              // TODO: Implement vault screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vault feature coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(
              height: 32,
              thickness: 1,
              color: Color(0xFFEEEEF2),
            ),
            itemBuilder: (context, index) {
              final transactions = [
                {
                  'name': 'Request from',
                  'description': 'Diop',
                  'amount': '+20.00',
                  'date': '06 Apr 2025 at 11:30',
                  'isPositive': true,
                },
                {
                  'name': 'Chez Diallo',
                  'amount': '+5.00',
                  'date': '06 Apr 2025 at 09:24',
                  'isPositive': true,
                },
                {
                  'name': 'Tamba',
                  'amount': '-12.00',
                  'date': '06 Apr 2025',
                  'isPositive': false,
                },
              ];
              return _buildTransactionItem(
                name: transactions[index]['name'] as String,
                description: transactions[index]['description'] as String?,
                amount: transactions[index]['amount'] as String,
                date: transactions[index]['date'] as String,
                isPositive: transactions[index]['isPositive'] as bool,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String name,
    String? description,
    required String amount,
    required String date,
    required bool isPositive,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                isPositive ? const Color(0xFFE8FFF3) : const Color(0xFFF3F3F3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              isPositive ? Icons.add : Icons.remove,
              size: 20,
              color: isPositive ? const Color(0xFF00C566) : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isPositive ? const Color(0xFF00C566) : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.primaryPurple;
    final backgroundColor = isDestructive
        ? Colors.red[50]
        : AppColors.primaryPurple.withOpacity(0.05);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: isDestructive ? color : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: isDestructive ? color.withOpacity(0.7) : Colors.grey[600],
            ),
          ),
          trailing: !isDestructive
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                )
              : null,
        ),
      ),
    );
  }
}
