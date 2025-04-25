import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/transfer/screens/send_money_screen.dart';
import '../../features/transfer/screens/receive_money_screen.dart';

class AppRouter {
  static late final AuthProvider authProvider;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    authProvider = AuthProvider(prefs);
  }

  static final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: authProvider,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final bool isAuthenticated = authProvider.isAuthenticated;
      final bool isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'send',
            builder: (context, state) => const SendMoneyScreen(),
          ),
          GoRoute(
            path: 'receive',
            builder: (context, state) => const ReceiveMoneyScreen(),
          ),
        ],
      ),
    ],
  );
}
