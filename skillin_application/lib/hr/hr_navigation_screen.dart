import 'package:flutter/material.dart';
import 'package:skillin_application/hr/hr_home_screen.dart';
import 'package:skillin_application/hr/add_job_screen.dart';
import 'package:skillin_application/hr/hr_posted_jobs_screen.dart';
import 'package:skillin_application/hr/hr_profile_screen.dart';

class HrNavigationScreen extends StatefulWidget {
  const HrNavigationScreen({super.key});

  @override
  State<HrNavigationScreen> createState() => _HrNavigationScreenState();
}

class _HrNavigationScreenState extends State<HrNavigationScreen> {
  int currentIndex = 0;

  List<Widget> get screens => const [
        HrHomeScreen(),
        HrPostedJobsScreen(),
        HrProfileScreen(),
      ];

  Future<void> _openAddJob() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddJobScreen()),
    );
    setState(() {});
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const darkBlue = Color(0xFF0F1F57);
    const activeBg = Color(0xFFEAF0FF);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: selected ? darkBlue : darkBlue.withOpacity(0.55),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? darkBlue : darkBlue.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 84,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x220F1F57),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              _navItem(
                icon: Icons.home_outlined,
                label: "Home",
                selected: currentIndex == 0,
                onTap: () => setState(() => currentIndex = 0),
              ),
              _navItem(
                icon: Icons.work_outline,
                label: "Jobs",
                selected: currentIndex == 1,
                onTap: () => setState(() => currentIndex = 1),
              ),
              _navItem(
                icon: Icons.add_circle_outline,
                label: "Post",
                selected: false,
                onTap: _openAddJob,
              ),
              _navItem(
                icon: Icons.person_outline,
                label: "Profile",
                selected: currentIndex == 2,
                onTap: () => setState(() => currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}