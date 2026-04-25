import 'package:flutter/material.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/auth/login_screen.dart';

class HrHomeScreen extends StatefulWidget {
  const HrHomeScreen({super.key});

  @override
  State<HrHomeScreen> createState() => _HrHomeScreenState();
}

class _HrHomeScreenState extends State<HrHomeScreen> {
  String userName = "HR";

  List<dynamic> candidates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();

    // ❗ Temporarily disabled candidates loading
    // بسبب error من السيرفر (GET CANDIDATES ERROR)
    // _loadCandidates();

    isLoading = false;
  }

  Future<void> _loadUser() async {
    final me = await AuthService.getMe();

    if (me["ok"] == true && mounted) {
      final data = me["data"];
      setState(() {
        userName = (data["full_name"] ?? "HR").toString();
      });
    }
  }

  Future<void> _loadCandidates() async {
    final result = await AuthService.getCandidates();

    if (mounted) {
      setState(() {
        candidates = result;
        isLoading = false;
      });
    }
  }

  Widget _candidateCard({
    required String name,
    required String subtitle,
    required List<String> tags,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1F3B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6A6F85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(tag),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HR"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/BackgroundSearch.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $userName",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Looking for the perfect\ncandidate!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Talent Opportunities",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1F3B),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const Center(
                        child: Text("Candidates temporarily disabled"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}