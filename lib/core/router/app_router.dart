import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/auth/presentation/view/register_screen.dart';
import '../../features/auth/presentation/view/reset_password_view.dart';
import '../../features/profile/presentation/view/profile_screen.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/spending/spending_screen.dart';
import '../../features/wallet/wallet_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordView(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final user = FirebaseAuth.instance.currentUser;

          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/login');
            });
          }

          return Scaffold(
            body: child,
            bottomNavigationBar: NavBar(
              currentIndex: _getCurrentIndex(state.uri.toString()),
              onTabSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/dashboard');
                    break;
                  case 1:
                    context.go('/spending');
                    break;
                  case 2:
                    context.go('/wallet');
                    break;
                  case 3:
                    context.go('/profile');
                    break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/spending',
            builder: (context, state) => const SpendingScreen(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );

  static int _getCurrentIndex(String? location) {
    switch (location) {
      case '/dashboard':
        return 0;
      case '/spending':
        return 1;
      case '/wallet':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }
}
