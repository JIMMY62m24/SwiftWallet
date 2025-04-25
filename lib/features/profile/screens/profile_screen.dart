import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  // Mock user data
  final Map<String, String> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8900',
    'address': '123 Main St, New York, NY 10001',
    'occupation': 'Software Engineer',
  };

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _userData.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {
              if (_isEditing) {
                // Discard changes
                _userData.forEach((key, value) {
                  _controllers[key]?.text = value;
                });
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
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
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPurple.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(_userData['name'] ?? ''),
                            style: AppTypography.headlineLarge.copyWith(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          right: 0,
                          bottom: 0,
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
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Full Name',
                          icon: Icons.person_outline_rounded,
                          controller: _controllers['name']!,
                          enabled: _isEditing,
                        ),
                        _buildTextField(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          controller: _controllers['email']!,
                          enabled: _isEditing,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          label: 'Phone',
                          icon: Icons.phone_outlined,
                          controller: _controllers['phone']!,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          label: 'Address',
                          icon: Icons.location_on_outlined,
                          controller: _controllers['address']!,
                          enabled: _isEditing,
                        ),
                        _buildTextField(
                          label: 'Occupation',
                          icon: Icons.work_outline_rounded,
                          controller: _controllers['occupation']!,
                          enabled: _isEditing,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isEditing)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            if (!_isEditing) ...[
              _buildActionCard(
                icon: Icons.security_rounded,
                title: 'Security Settings',
                subtitle: 'Manage your account security preferences',
                onTap: () {
                  // TODO: Navigate to security settings
                },
              ),
              _buildActionCard(
                icon: Icons.notifications_outlined,
                title: 'Notification Settings',
                subtitle: 'Customize your notification preferences',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              _buildActionCard(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'Change your preferred language',
                onTap: () {
                  // TODO: Navigate to language settings
                },
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(
            icon,
            color: enabled ? AppColors.primaryPurple : Colors.grey[600],
            size: 24,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryPurple,
              width: 2,
            ),
          ),
          filled: !enabled,
          fillColor: enabled ? Colors.transparent : Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
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
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey[600],
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update user data
      _userData.forEach((key, _) {
        _userData[key] = _controllers[key]?.text ?? '';
      });

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
