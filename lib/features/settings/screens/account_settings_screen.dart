import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Account Settings',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildProfileSection(context),
            const SizedBox(height: 24),
            _buildSecuritySection(context),
            const SizedBox(height: 24),
            _buildPreferencesSection(context),
            const SizedBox(height: 24),
            _buildNotificationsSection(context),
            const SizedBox(height: 24),
            _buildSupportSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryPurple,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://ui-avatars.com/api/?name=John+Doe&background=7158e2&color=fff&size=120',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primaryPurple,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement image picker
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+1 234 567 8900',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Verified',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.primaryPurple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Premium',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Total Balance', '\$2,459.50'),
                const VerticalDivider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                _buildStatItem('Transactions', '143'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return _buildSection(
      title: 'Profile',
      children: [
        _buildSettingTile(
          icon: Icons.person_outline,
          title: 'Personal Information',
          subtitle: 'Name, phone number, email',
          onTap: () {
            // TODO: Navigate to personal info screen
          },
        ),
        _buildSettingTile(
          icon: Icons.location_on_outlined,
          title: 'Address',
          subtitle: 'Your delivery and billing addresses',
          onTap: () {
            // TODO: Navigate to address screen
          },
        ),
        _buildSettingTile(
          icon: Icons.badge_outlined,
          title: 'ID Verification',
          subtitle: 'Verify your identity',
          onTap: () {
            // TODO: Navigate to verification screen
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSection(
      title: 'Security',
      children: [
        _buildSettingTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your password',
          onTap: () {
            // TODO: Navigate to change password screen
          },
        ),
        _buildSettingTile(
          icon: Icons.fingerprint,
          title: 'Biometric Authentication',
          subtitle: 'Enable fingerprint or face ID',
          trailing: Switch(
            value: true, // TODO: Connect to actual state
            onChanged: (value) {
              // TODO: Implement biometric toggle
            },
            activeColor: AppColors.primaryPurple,
          ),
        ),
        _buildSettingTile(
          icon: Icons.security,
          title: 'PIN Code',
          subtitle: 'Change your PIN code',
          onTap: () {
            // TODO: Navigate to PIN change screen
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return _buildSection(
      title: 'Preferences',
      children: [
        _buildSettingTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English (US)',
          onTap: () {
            // TODO: Show language picker
          },
        ),
        _buildSettingTile(
          icon: Icons.currency_exchange,
          title: 'Currency',
          subtitle: 'USD (\$)',
          onTap: () {
            // TODO: Show currency picker
          },
        ),
        _buildSettingTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'Change app appearance',
          trailing: Switch(
            value: false, // TODO: Connect to actual theme state
            onChanged: (value) {
              // TODO: Implement theme toggle
            },
            activeColor: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return _buildSection(
      title: 'Notifications',
      children: [
        _buildSettingTile(
          icon: Icons.payment,
          title: 'Payment Notifications',
          subtitle: 'Get notified about transactions',
          trailing: Switch(
            value: true, // TODO: Connect to actual state
            onChanged: (value) {
              // TODO: Implement notification toggle
            },
            activeColor: AppColors.primaryPurple,
          ),
        ),
        _buildSettingTile(
          icon: Icons.security_update_good,
          title: 'Security Alerts',
          subtitle: 'Get notified about security events',
          trailing: Switch(
            value: true, // TODO: Connect to actual state
            onChanged: (value) {
              // TODO: Implement security alerts toggle
            },
            activeColor: AppColors.primaryPurple,
          ),
        ),
        _buildSettingTile(
          icon: Icons.local_offer_outlined,
          title: 'Promotional Notifications',
          subtitle: 'Receive offers and updates',
          trailing: Switch(
            value: false, // TODO: Connect to actual state
            onChanged: (value) {
              // TODO: Implement promo toggle
            },
            activeColor: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      title: 'Support',
      children: [
        _buildSettingTile(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Get help with SwiftWallet',
          onTap: () {
            // TODO: Navigate to help center
          },
        ),
        _buildSettingTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: () {
            // TODO: Show privacy policy
          },
        ),
        _buildSettingTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          onTap: () {
            // TODO: Show terms of service
          },
        ),
        _buildSettingTile(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version 1.0.0',
          onTap: () {
            // TODO: Show about dialog
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primaryPurple,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
