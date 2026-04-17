import 'package:flutter/material.dart';
import 'package:skillin_application/hr/hr_home_screen.dart';
import 'package:skillin_application/hr/add_job_screen.dart';
import 'package:skillin_application/hr/hr_posted_jobs_screen.dart';
import 'package:skillin_application/profile/profile_screen.dart';

class HrNavigationScreen extends StatefulWidget {
  const HrNavigationScreen({super.key});

  @override
  State<HrNavigationScreen> createState() => _HrNavigationScreenState();
}

class _HrNavigationScreenState extends State<HrNavigationScreen> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    const HrHomeScreen(),
    const HrPostedJobsScreen(),
    const ProfileScreen(),
  ];

  Future<void> _openAddJob() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddJobScreen(),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F1F57),
        onPressed: _openAddJob,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => setState(() => currentIndex = 0),
                icon: Icon(
                  Icons.home_outlined,
                  color: currentIndex == 0
                      ? const Color(0xFF3866FA)
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => currentIndex = 1),
                icon: Icon(
                  Icons.work_outline,
                  color: currentIndex == 1
                      ? const Color(0xFF3866FA)
                      : Colors.grey,
                ),
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () => setState(() => currentIndex = 2),
                icon: Icon(
                  Icons.person_outline,
                  color: currentIndex == 2
                      ? const Color(0xFF3866FA)
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: _openAddJob,
                icon: const Icon(
                  Icons.add_business_outlined,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}