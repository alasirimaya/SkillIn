import 'package:flutter/material.dart';
import '../Jobs/job_model.dart';
import '../services/profile_local_service.dart';
import '../services/auth_service.dart';

class SkillGapScreen extends StatefulWidget {
  final JobModel job;
  final double matchPercent; // ✅ NEW

  const SkillGapScreen({
    super.key,
    required this.job,
    required this.matchPercent, // ✅ NEW
  });

  @override
  State<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends State<SkillGapScreen> {
  int _matchPercent = 0;
  List<String> _missingSkills = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSkillGap();
  }

  Future<void> _loadSkillGap() async {
    final me = await AuthService.getMe();

    if (me["ok"] != true) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final int userId = me["data"]["id"];
    final userSkills = await ProfileLocalService.getSkills(userId);

    final List<String> normalizedUserSkills =
        userSkills.map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();

    final List<String> jobSkills = widget.job.skills
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    final missing = jobSkills.where((skill) => !normalizedUserSkills.contains(skill)).toList();

    // ✅ USE THE REAL MATCH FROM RECOMMENDATION
    final int percent = widget.matchPercent.round();

    setState(() {
      _matchPercent = percent;
      _missingSkills = missing;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0F1F57);
    const lightBg = Color(0xFFF5F6FA);
    const cardBg = Colors.white;
    const orange = Color(0xFFFF9228);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text("Skill Gap Analysis"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Skill Match Score is",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: darkBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: CircularProgressIndicator(
                                value: _matchPercent / 100,
                                strokeWidth: 14,
                                backgroundColor: const Color(0xFFE5E9F2),
                                valueColor: const AlwaysStoppedAnimation<Color>(darkBlue),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "%$_matchPercent",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _missingSkills.isEmpty
                              ? "You already have the main required skills for this job."
                              : "You’re missing some required skills for this job.",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    "Missing Skills",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _missingSkills.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "No missing skills 🎉",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: darkBlue,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _missingSkills.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.95,
                          ),
                          itemBuilder: (context, index) {
                            final skill = _missingSkills[index];

                            return Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFF1E5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_motion_outlined,
                                      color: orange,
                                      size: 34,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    skill,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}