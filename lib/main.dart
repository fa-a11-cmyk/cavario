import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CavarioApp());
}

class CavarioApp extends StatelessWidget {
  const CavarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Cavario - Equestrian Club Management',
        theme: AppTheme.theme,
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            return auth.isAuthenticated ? const DashboardScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}