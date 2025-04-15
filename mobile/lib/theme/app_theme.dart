import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF6C3BAA);

  // Background Colors
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardGrey = Color(0xFFE0E0E0);

  // Text Colors
  static const Color textDark = Color(0xFF444444);
  static const Color textGrey = Color(0xFF666666);
  static const Color placeholderGrey = Color(0xFF999999);

  // Utility Colors
  static const Color white = Colors.white;
  static const Color dividerGrey = Color(0xFFDCDCDC);

  // Text Styles
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: primaryPurple,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primaryPurple,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textDark,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textDark,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: textGrey,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: textGrey,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: white,
    ),
  );

  // Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
      );

  // Secondary Button Style
  static ButtonStyle get secondaryButtonStyle => TextButton.styleFrom(
        foregroundColor: textGrey,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  // Input Decoration
  static InputDecoration getInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: placeholderGrey,
          fontSize: 16,
        ),
        filled: true,
        fillColor: white,
        prefixIcon: Icon(
          prefixIcon,
          color: placeholderGrey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryPurple, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      );

  // App Bar Theme
  static AppBarTheme get appBarTheme => const AppBarTheme(
        backgroundColor: primaryPurple,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get bottomNavTheme =>
      const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: placeholderGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );
}
