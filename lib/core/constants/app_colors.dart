import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFFC8B6FF); // Main purple color
  static const Color secondaryPurple = Color(0xFFE6E6FA); // Lighter purple

  // Background Colors
  static const Color background = Color(0xFFEEEEF2); // Light gray
  static const Color cardDark = Color(0xFF3F3F45); // Dark gray for QR container

  // Quick Action Colors
  static const Color actionButtonPrimary = primaryPurple;
  static const Color actionButtonSecondary =
      Color(0xFFB4A5FF); // More visible secondary purple
  static const Color actionButtonTertiary =
      Color(0xFFD4CCFF); // Lightest but still visible purple

  // Text Colors
  static const Color textDark = Color(0xFF1A1F24);
  static const Color textLight = Colors.white;

  // Transaction Colors
  static const Color positive =
      Color(0xFF00C566); // Green for positive transactions
  static const Color negative =
      Color(0xFF1A1F24); // Dark for negative transactions

  // Additional Colors
  static const Color divider = Color(0xFFF1F4F8); // Light grey for dividers
  static const Color inactive = Color(0xFF95A1AC); // Inactive/disabled state
}
