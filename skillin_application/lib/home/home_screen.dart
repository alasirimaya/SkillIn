import 'package:flutter/material.dart';
import 'package:skillin_application/auth/auth_gate.dart';
import 'package:skillin_application/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthService.logout();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const AuthGate()),
              (route) => false,
            );
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}