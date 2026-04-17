/*import 'package:flutter/material.dart';
import 'job_model.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo + Title + Location
            Row(
              children: [
                Image.asset(job.logo, height: 50),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("${job.company} • ${job.location}",
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Job Description
            const Text("Job Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "The IT Manager is responsible for overseeing the company's information "
              "technology operations, ensuring the reliability, security, and efficiency "
              "of all IT systems. This role involves managing IT staff, setting strategic "
              "technology goals, implementing new systems, and ensuring alignment with "
              "business objectives.",
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),

            const SizedBox(height: 25),

            // Requirements
            const Text("Requirements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            requirement("- Bachelor's degree in IT or related field."),
            requirement("- Minimum 5 years of experience in IT operations."),
            requirement("- At least 2 years in a managerial role."),
            requirement("- Strong knowledge of cloud services and networking."),

            const SizedBox(height: 40),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApplyScreen(job: job),
                    ),
                  );
                },
                child: const Text(
                  "APPLY NOW",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget requirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(color: Colors.grey[700], height: 1.4)),
    );
  }
}



*/
import 'package:flutter/material.dart';
import 'package:skillin_application/profile/saved_job_model.dart';
import 'package:skillin_application/profile/saved_jobs_provider.dart';
import 'apply_screen.dart';
import 'job_model.dart';
import '../services/jobs_service.dart';
import 'skill_gap_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final int jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late Future<JobModel> jobFuture;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    jobFuture = fetchJob();
    isSaved = SavedJobsProvider.isSaved(widget.jobId);
  }

  Future<JobModel> fetchJob() async {
    final result = await JobsService.getJobById(widget.jobId);

    if (result['ok'] == true) {
      return JobModel.fromJson(Map<String, dynamic>.from(result['data']));
    } else {
      throw Exception(result['msg'] ?? 'Failed to load job details');
    }
  }

  List<String> _requirementsFromSkills(String skills) {
    if (skills.trim().isEmpty) {
      return [
        "Bachelor’s degree in Information Technology, Computer Science, or a related field.",
        "Minimum 2 years of relevant experience.",
        "Good communication and teamwork skills.",
      ];
    }

    return skills
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _toggleSave(JobModel job) {
    SavedJobsProvider.toggleSaved(
      SavedJobModel(
        id: job.id,
        title: job.title,
        company: job.company,
        location: "Riyadh",
        jobType: "Full Time",
      ),
    );

    setState(() {
      isSaved = SavedJobsProvider.isSaved(job.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: FutureBuilder<JobModel>(
        future: jobFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No job details found'));
          }

          final job = snapshot.data!;
          final requirements = _requirementsFromSkills(job.skills);

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFF1B1F3B),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDDF3FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.business,
                              size: 42,
                              color: Color(0xFF4285F4),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              job.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B1F3B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Google",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1B1F3B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text("•"),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Riyadh",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1B1F3B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text("•"),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "1 day ago",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1B1F3B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF9F9FC),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(28),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Job Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  job.description.isEmpty
                                      ? 'No description available.'
                                      : job.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6A6F85),
                                    height: 1.55,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD8E3FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Read more",
                                    style: TextStyle(
                                      color: Color(0xFF4A63D3),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                const Text(
                                  "Requirements",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1B1F3B),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ...requirements.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 7),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                            color: Color(0xFF1B1F3B),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6A6F85),
                                              height: 1.5,
                                            ),
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
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleSave(job),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8FB),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: const Color(0xFFF7A541),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0F1F57),
                              elevation: 0,
                              side: const BorderSide(
                                color: Color(0xFF0F1F57),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SkillGapScreen(
                                    job: job,
                                    matchPercent: 54,
                                  ),
                                ),
                              );
                            },
                            child: const Text("View Skill Gap"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F1F57),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ApplyScreen(job: job),
                                ),
                              );
                            },
                            child: const Text(
                              "APPLY NOW",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
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
        },
      ),
    );
  }
}