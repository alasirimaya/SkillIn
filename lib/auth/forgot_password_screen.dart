import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _loading = false;
  String? _message;

  Future<void> _submit() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _message = "Please enter your email.";
      });
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
    });

    final result = await AuthService.forgotPassword(email: email);

    setState(() {
      _loading = false;
      _message = result["ok"] == true
          ? "A password reset email has been sent to your email."
          : (result["msg"] ?? "Forgot password request failed.");
    });
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

                /// Background
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),

                /// Back arrow
                Positioned(
                  top: 20,
                  left: 15,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                /// Bottom container
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

                /// SkillIn logo
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

                /// Title
                const Positioned(
                  top: 255,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Forgot your password ?",
                      style: TextStyle(
                        fontSize: 29.88,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF04103D),
                      ),
                    ),
                  ),
                ),

                /// Instruction text
                Positioned(
                  top: 310,
                  left: 60,
                  right: 60,
                  child: Text(
                    "Enter your email and wait to receive a link",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF06061C).withOpacity(0.39),
                    ),
                  ),
                ),

                /// Email field
                Positioned(
                  top: 380,
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

                /// Next button image
                Positioned(
                  top: 470,
                  left: 72,
                  child: GestureDetector(
                    onTap: _loading ? null : _submit,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: 285,
                        height: 52,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/next_button.png',
                              fit: BoxFit.cover,
                            ),

                            if (_loading)
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

                /// Message
                if (_message != null)
                  Positioned(
                    top: 540,
                    left: 40,
                    right: 40,
                    child: Text(
                      _message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
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