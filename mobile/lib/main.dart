import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/login_screen.dart';
import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'SwiftWallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppTheme.backgroundGrey,
          textTheme: AppTheme.textTheme,
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: AppTheme.primaryPurple,
            onPrimary: AppTheme.white,
            secondary: AppTheme.primaryPurple,
            background: AppTheme.backgroundGrey,
            surface: AppTheme.white,
            onSurface: AppTheme.textDark,
          ),
          appBarTheme: AppTheme.appBarTheme,
          bottomNavigationBarTheme: AppTheme.bottomNavTheme,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppTheme.primaryButtonStyle,
          ),
          textButtonTheme: TextButtonThemeData(
            style: AppTheme.secondaryButtonStyle,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppTheme.white,
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
              borderSide: BorderSide(color: AppTheme.primaryPurple),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: AppTheme.primaryPurple,
            ),
            const SizedBox(height: 20),
            Text(
              'SwiftWallet',
              style: AppTheme.textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
