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
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
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

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onTap,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.7 : 1,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF3B55C1),
                Color(0xFF031760),
              ],
              stops: [0.02, 1.0],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(35, 3, 23, 96),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTopBackground(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF4A63D8),
            Color(0xFF36353C),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -130,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -110,
            right: -30,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: 20,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -30,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final topSectionHeight = size.height * 0.29;
    final formTopOverlap = 175.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBackground(topSectionHeight),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 20),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Center(
                    child: SizedBox(
                      width: size.width * 0.34,
                      child: Image.asset(
                        'assets/images/SkillIn_Logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: topSectionHeight - 130),

                Transform.translate(
                  offset: Offset(0, -formTopOverlap),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        topRight: Radius.circular(70),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),

                          const Center(
                            child: Text(
                              "Welcome !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF04103D),
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _fieldDecoration("Email"),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (!_isLoading) _handleLogin();
                            },
                            decoration: _fieldDecoration("Password"),
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3866FA),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          _buildPrimaryButton(
                            text: "Login",
                            isLoading: _isLoading,
                            onTap: _isLoading ? null : _handleLogin,
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 34),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "Don’t have an account? ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF06061C)
                                        .withOpacity(0.39),
                                  ),
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3866FA),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}