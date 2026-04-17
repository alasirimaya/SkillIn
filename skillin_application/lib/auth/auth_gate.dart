import 'package:flutter/material.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/auth/login_screen.dart';
import 'package:skillin_application/main_navigation_screen.dart';
import 'package:skillin_application/hr/hr_navigation_screen.dart';
import 'package:skillin_application/services/user_role_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        AuthService.isLoggedIn(),
        UserRoleService.getCurrentRole(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final loggedIn = snapshot.data?[0] == true;
        final role = (snapshot.data?[1] ?? "personal").toString();

        if (!loggedIn) {
          return const LoginScreen();
        }

        if (role == "business") {
          return const HrNavigationScreen();
        }

        return const MainNavigationScreen();
      },
    );
  }
}