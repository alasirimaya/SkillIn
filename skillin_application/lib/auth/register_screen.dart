import 'package:flutter/material.dart';
import 'package:skillin_application/auth/auth_gate.dart';
import 'package:skillin_application/auth/login_screen.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/services/user_role_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? selectedRole;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() {
      if (selectedRole == role) {
        selectedRole = null;
      } else {
        selectedRole = role;
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    FocusScope.of(context).unfocus();

    if (selectedRole == null) {
      setState(() {
        _errorMessage = "Please choose your role.";
      });
      return;
    }

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill all fields.";
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = "Please enter a valid email.";
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        _errorMessage = "Password must be at least 8 characters.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.register(
      fullName: name,
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result["ok"] == true) {
       await UserRoleService.saveRoleForEmail(email, selectedRole!);
       await UserRoleService.setCurrentRole(selectedRole!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    } else {
      setState(() {
        _errorMessage = (result["msg"] ?? "Registration failed.").toString();
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF04103D),
        fontWeight: FontWeight.w500,
      ),
      decoration: _fieldDecoration(label),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String imagePath,
  }) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () => _selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isSelected ? const Color(0xFF3866FA) : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(35, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: AspectRatio(
            aspectRatio: 150 / 153,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
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
                              'Welcome !',
                              style: TextStyle(
                                color: Color(0xFF04103D),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Who are you? Choose your role to continue.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9E9EA7),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'personal',
                                  imagePath:
                                      'assets/images/personal_button.png',
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'business',
                                  imagePath:
                                      'assets/images/business_button.png',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          _buildInputField(
                            label: 'Name',
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 18),

                          _buildInputField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 18),

                          _buildInputField(
                            label: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (!_isLoading) _handleRegister();
                            },
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

                          const SizedBox(height: 24),

                          _buildPrimaryButton(
                            text: 'Sign up',
                            isLoading: _isLoading,
                            onTap: _isLoading ? null : _handleRegister,
                          ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Already have an account? ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF9E9EA7),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF3866FA),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
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