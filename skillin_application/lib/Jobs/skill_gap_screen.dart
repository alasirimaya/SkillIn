import 'package:flutter/material.dart';
import '../Jobs/job_model.dart';
import '../services/profile_local_service.dart';
import '../services/auth_service.dart';
import '../services/jobs_service.dart';

class SkillGapScreen extends StatefulWidget {
  final JobModel job;
  final double matchPercent;

  const SkillGapScreen({
    super.key,
    required this.job,
    required this.matchPercent,
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

  double _toPercent(double value) {
    if (value <= 0) return 0;
    if (value <= 1) return value * 100;
    return value;
  }

  Future<double> _getRealSimilarityFromRecommendations() async {
    final me = await AuthService.getMe();

    if (me["ok"] != true || me["data"] == null) {
      return 0;
    }

    final int userId = me["data"]["id"];

    final response = await JobsService.getRecommendations(userId);

    if (response["ok"] != true || response["data"] == null) {
      return 0;
    }

    final data = Map<String, dynamic>.from(response["data"] as Map);
    final List recommendations = data["recommendations"] ?? [];

    for (final rec in recommendations) {
      final map = Map<String, dynamic>.from(rec as Map);

      final int recJobId = map["job_id"] ?? map["id"] ?? 0;

      if (recJobId == widget.job.id) {
        final rawSimilarity = ((map["similarity"] ?? 0) as num).toDouble();
        return _toPercent(rawSimilarity);
      }
    }

    return 0;
  }

  Future<void> _loadSkillGap() async {
    double realMatch = _toPercent(widget.matchPercent);

    if (realMatch == 0) {
      realMatch = await _getRealSimilarityFromRecommendations();
    }

    final me = await AuthService.getMe();

    if (me["ok"] != true || me["data"] == null) {
      setState(() {
        _matchPercent = realMatch.round();
        _loading = false;
      });
      return;
    }

    final int userId = me["data"]["id"];

    final userSkills = await ProfileLocalService.getSkills(userId);

    final List<String> normalizedUserSkills = userSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toList();

    final List<String> jobSkills = widget.job.skills
        .split(',')
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toList();

    final missing = jobSkills
        .where((skill) => !normalizedUserSkills.contains(skill))
        .toList();

    setState(() {
      _matchPercent = realMatch.round();
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
        centerTitle: true,
        title: const Text(
          "Skill Gap Analysis",
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: darkBlue,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Skill Match Score is",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: darkBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 170,
                              height: 170,
                              child: CircularProgressIndicator(
                                value: (_matchPercent / 100).clamp(0.0, 1.0),
                                strokeWidth: 16,
                                backgroundColor: Color(0xFFE5E9F2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  darkBlue,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "%$_matchPercent",
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _missingSkills.isEmpty
                              ? "You already have the main required skills for this job."
                              : "You’re missing some required skills for this job.",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Missing Skills",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _missingSkills.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text(
                            "No missing skills 🎉",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: darkBlue,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _missingSkills.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      fontSize: 16,
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