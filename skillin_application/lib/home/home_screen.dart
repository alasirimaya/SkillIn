import 'package:flutter/material.dart';
import 'package:skillin_application/Jobs/job_details_screen.dart';
import 'package:skillin_application/Jobs/job_model.dart';
import 'package:skillin_application/Jobs/jobs_list_screen.dart';
import 'package:skillin_application/auth/auth_gate.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/services/jobs_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  bool isLoadingJobs = true;

  List<JobModel> recentJobs = [];
  List<JobModel> allJobs = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchRecentJobs();
  }

  Future<void> _loadUser() async {
    final me = await AuthService.getMe();

    if (me["ok"] == true && mounted) {
      final data = me["data"];
      setState(() {
        userName = (data["full_name"] ?? "").toString().isEmpty
            ? "User"
            : data["full_name"].toString();
      });
    }
  }

  Future<void> _fetchRecentJobs() async {
    final response = await JobsService.getJobs();

    if (response["ok"] == true) {
      final List data = response["data"] as List;

      if (!mounted) return;

      final jobs = data
          .map((job) => JobModel.fromJson(Map<String, dynamic>.from(job)))
          .toList();

      setState(() {
        allJobs = jobs;
        recentJobs = jobs.take(3).toList();
        isLoadingJobs = false;
      });
    } else {
      if (!mounted) return;

      setState(() {
        isLoadingJobs = false;
      });
    }
  }

  int _countFullTimeJobs() {
    return allJobs.where((job) {
      final type = job.type.toLowerCase().replaceAll("-", " ").trim();
      return type == "full time";
    }).length;
  }

  int _countPartTimeJobs() {
    return allJobs.where((job) {
      final type = job.type.toLowerCase().replaceAll("-", " ").trim();
      return type == "part time";
    }).length;
  }

  int _countRemoteJobs() {
    return allJobs.where((job) {
      final workplace = job.category.toLowerCase().trim();
      final type = job.type.toLowerCase().replaceAll("-", " ").trim();
      return workplace == "remote" || type == "remote";
    }).length;
  }

  String _jobTypePlaceholder(int index) {
    final type = recentJobs[index].type.trim();
    if (type.isNotEmpty) return type;
    const types = ["Full Time", "Part Time", "Remote"];
    return types[index % types.length];
  }

  String _locationPlaceholder(int index) {
    final location = recentJobs[index].location.trim();
    if (location.isNotEmpty) return location;
    const locations = ["Riyadh, KSA", "Jeddah, KSA", "Dammam, KSA"];
    return locations[index % locations.length];
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
    required Color bgColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.work_outline,
                      size: 40,
                      color: Color(0xFF4A63D3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1F3B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6A6F85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentJobCard(JobModel job, int index) {
    final location = _locationPlaceholder(index);
    final jobType = _jobTypePlaceholder(index);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailsScreen(jobId: job.id),
          ),
        );
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7DBFF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.business_center,
                    color: Color(0xFF1B1F3B),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  "assets/images/Save.png",
                  width: 22,
                  height: 22,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.bookmark_border,
                    color: Color(0xFF6A6F85),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              job.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1F3B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${job.company}  •  $location",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6A6F85),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F1F7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    jobType,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6A6F85),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8E3FF),
                    foregroundColor: const Color(0xFF4A63D3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(jobId: job.id),
                      ),
                    );
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF23408F),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Improve your skills\nBuild your future",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7A541),
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Center(
                        child: Text(
                          "Join Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Image.asset(
              "assets/images/banner.png",
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_outlined,
                size: 80,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Hello\n$userName.",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1F3B),
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B1F3B),
          ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              "See all",
              style: TextStyle(
                color: Color(0xFF4A63D3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final remoteCount = _countRemoteJobs();
    final fullTimeCount = _countFullTimeJobs();
    final partTimeCount = _countPartTimeJobs();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildBanner(),
              const SizedBox(height: 28),
              _buildSectionTitle("Find Your Job"),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildCategoryCard(
                    title: remoteCount.toString(),
                    subtitle: "Remote Job",
                    imagePath: "assets/images/FindJob.png",
                    bgColor: const Color(0xFFD9F1FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JobsListScreen(
                            useRecommendations: true,
                            initialJobType: "Remote",
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const JobsListScreen(
                                  useRecommendations: true,
                                  initialJobType: "Full Time",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 68,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCCEFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fullTimeCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Full Time",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const JobsListScreen(
                                  useRecommendations: true,
                                  initialJobType: "Part Time",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 68,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5D9B4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  partTimeCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Part Time",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _buildSectionTitle(
                "Recent Job List",
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JobsListScreen(
                        useRecommendations: true,
                        initialJobType: "All Jobs",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              if (isLoadingJobs)
                const Center(child: CircularProgressIndicator())
              else if (recentJobs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    "No recent jobs found",
                    textAlign: TextAlign.center,
                  ),
                )
              else
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentJobs.length,
                    itemBuilder: (context, index) {
                      return _buildRecentJobCard(recentJobs[index], index);
                    },
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await AuthService.logout();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthGate()),
                      (route) => false,
                    );
                  },
                  child: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}