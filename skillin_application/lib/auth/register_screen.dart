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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: 340,
      height: 62,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF04103D),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF04103D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: Color(0xFF10246A),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: Color(0xFF10246A),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String role,
    required String imagePath,
    required double left,
    required double top,
  }) {
    final bool isSelected = selectedRole == role;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => _selectRole(role),
        child: Stack(
          children: [
            Container(
              width: 150,
              height: 153,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 150,
                height: 153,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF3866FA),
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

 Future<void> _handleRegister() async {
  print("REGISTER PRESSED");
  final name = _nameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please choose your role.")),
    );
    return;
  }

  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields.")),
    );
    return;
  }

  if (password.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password must be at least 8 characters.")),
    );
    return;
  }

  setState(() => _isLoading = true);

  final result = await AuthService.register(
    fullName: name,
    email: email,
    password: password,
  );

  print("REGISTER RESULT: $result");

  if (!mounted) return;
  setState(() => _isLoading = false);

  if (result["ok"] == true) {
    await UserRoleService.saveRoleForEmail(email, selectedRole!);
    await UserRoleService.setCurrentRole(selectedRole!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  } else {
    final msg = (result["msg"] ?? "Registration failed.").toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
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
                  top: 225,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Welcome !',
                      style: TextStyle(
                        color: Color(0xFF04103D),
                        fontSize: 29.88,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Positioned(
                  top: 285,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Who are you? Choose your role to continue.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9E9EA7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                _buildRoleButton(
                  role: 'personal',
                  imagePath: 'assets/images/personal_button.png',
                  left: 65,
                  top: 330,
                ),

                _buildRoleButton(
                  role: 'business',
                  imagePath: 'assets/images/business_button.png',
                  left: 230,
                  top: 330,
                ),

                Positioned(
                  top: 515,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildInputField(
                      label: 'Name',
                      controller: _nameController,
                    ),
                  ),
                ),

                Positioned(
                  top: 588,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildInputField(
                      label: 'Email',
                      controller: _emailController,
                    ),
                  ),
                ),

                Positioned(
                  top: 661,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildInputField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                  ),
                ),

                Positioned(
                  top: 748,
                  left: 72,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleRegister,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: _isLoading ? 0.7 : 1,
                        child: Image.asset(
                          'assets/images/Sign_up_button.png',
                          width: 286,
                          height: 61,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 820,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xFF9E9EA7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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