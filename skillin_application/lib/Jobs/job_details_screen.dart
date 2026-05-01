import 'package:flutter/material.dart';
import '../profile/saved_job_model.dart';
import '../profile/saved_jobs_provider.dart';
import 'apply_screen.dart';
import 'job_model.dart';
import '../services/jobs_service.dart';
import 'skill_gap_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final int jobId;
  final double similarity;

  const JobDetailsScreen({
    super.key,
    required this.jobId,
    this.similarity = 0,
  });

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

  List<String> _buildRequirements(JobModel job) {
    final List<String> requirements = [];

    if (job.skills.trim().isNotEmpty) {
      requirements.add("Skills: ${job.skills}");
    }

    if (job.educationRequirement.trim().isNotEmpty) {
      requirements.add("Education: ${job.educationRequirement}");
    }

    if (job.experienceRequirement.trim().isNotEmpty) {
      requirements.add("Experience: ${job.experienceRequirement}");
    }

    if (job.languages.trim().isNotEmpty) {
      requirements.add("Languages: ${job.languages}");
    }

    if (requirements.isEmpty) {
      requirements.add("No specific requirements provided.");
    }

    return requirements;
  }

  void _toggleSave(JobModel job) {
    SavedJobsProvider.toggleSaved(
      SavedJobModel(
        id: job.id,
        title: job.title,
        company: job.company,
        location: job.location,
        jobType: job.type,
      ),
    );

    setState(() {
      isSaved = SavedJobsProvider.isSaved(job.id);
    });
  }

  double _getCorrectSimilarity(JobModel job) {
    if (widget.similarity > 0) {
      return widget.similarity;
    }

    return job.similarity;
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
          final requirements = _buildRequirements(job);
          final correctSimilarity = _getCorrectSimilarity(job);

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

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    job.company.isEmpty
                                        ? "Company"
                                        : job.company,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1B1F3B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text("•"),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    job.location.isEmpty
                                        ? "Location"
                                        : job.location,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1B1F3B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text("•"),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    job.timeAgo.isEmpty
                                        ? "1 day ago"
                                        : job.timeAgo,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
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
                                    matchPercent: correctSimilarity,
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