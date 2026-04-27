import 'package:flutter/material.dart';
import 'package:skillin_application/auth/register_screen.dart';
import 'package:skillin_application/auth/auth_gate.dart';
import 'package:skillin_application/auth/forgot_password_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> _handleLogin() async {
  print("LOGIN PRESSED");

  final email = _emailController.text.trim();
  final password = _passwordController.text;

  FocusScope.of(context).unfocus();

  if (email.isEmpty || password.isEmpty) {
    setState(() {
      _errorMessage = "Please fill in all fields.";
    });
    return;
  }

  if (!_isValidEmail(email)) {
    setState(() {
      _errorMessage = "Please enter a valid email.";
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  final result = await AuthService.login(
    email: email,
    password: password,
  );

  print("LOGIN RESULT: $result");

  if (!mounted) return;

  setState(() {
    _isLoading = false;
  });

  if (result["ok"] == true) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthGate(),
      ),
    );
  } else {
    setState(() {
      _errorMessage = (result["msg"] ?? "Login failed.").toString();
    });
  }
}
  

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(
          color: Color(0xFF0F1F57),
          width: 1.6,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(
          color: Color(0xFF0F1F57),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.6,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF0F1F57),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 430,
            height: 874,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  top: 182,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(85),
                        topRight: Radius.circular(85),
                      ),
                    ),
                  ),
                ),

                // logo moved higher
                Positioned(
                  top: 42,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 165,
                      child: Image.asset(
                        'assets/images/SkillIn_Logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const Positioned(
                  top: 255,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Welcome !",
                      style: TextStyle(
                        fontSize: 29.88,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF04103D),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 365,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 340,
                      height: 62,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _fieldDecoration("Email"),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 450,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 340,
                      height: 62,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _fieldDecoration("Password"),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 532,
                  right: 45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3866FA),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 610,
                  left: 72,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleLogin,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: 285,
                        height: 52,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/login_button.png',
                              width: 285,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                            if (_isLoading)
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (_errorMessage != null)
                  Positioned(
                    top: 676,
                    left: 35,
                    right: 35,
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                Positioned(
                  top: 760,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF06061C).withOpacity(0.39),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3866FA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}