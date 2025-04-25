import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/transfer/providers/balance_provider.dart';
import 'features/transfer/providers/transfer_provider.dart';
import 'features/settings/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authProvider = AuthProvider(prefs);
  final balanceProvider = BalanceProvider(prefs);
  final transferProvider = TransferProvider();
  final settingsProvider = SettingsProvider(prefs);

  runApp(MyApp(
    authProvider: authProvider,
    balanceProvider: balanceProvider,
    transferProvider: transferProvider,
    settingsProvider: settingsProvider,
  ));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final BalanceProvider balanceProvider;
  final TransferProvider transferProvider;
  final SettingsProvider settingsProvider;

  const MyApp({
    super.key,
    required this.authProvider,
    required this.balanceProvider,
    required this.transferProvider,
    required this.settingsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: balanceProvider),
        ChangeNotifierProvider.value(value: transferProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: MaterialApp(
        title: 'SwiftWallet',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Poppins',
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isAuthenticated) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
