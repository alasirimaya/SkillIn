import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skillin_application/services/jobs_service.dart';

class HrPostedJobsScreen extends StatefulWidget {
  const HrPostedJobsScreen({super.key});

  @override
  State<HrPostedJobsScreen> createState() => _HrPostedJobsScreenState();
}

class _HrPostedJobsScreenState extends State<HrPostedJobsScreen> {
  bool isLoading = true;

  List jobs = [];
  Map<int, List<dynamic>> applicantsByJob = {};
  Set<int> expandedJobs = {};

  static const String baseUrl = "http://127.0.0.1:8000/api/v1";

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      isLoading = true;
    });

    final response = await JobsService.getJobs();

    if (!mounted) return;

    if (response["ok"] == true) {
      jobs = response["data"] as List;
      applicantsByJob.clear();

      for (final item in jobs) {
        final job = Map<String, dynamic>.from(item);
        final int jobId = job["id"] ?? job["job_id"] ?? 0;

        if (jobId != 0) {
          final applicantsResponse =
              await JobsService.getApplicantsByJobId(jobId);

          if (applicantsResponse["ok"] == true) {
            applicantsByJob[jobId] =
                applicantsResponse["data"] as List<dynamic>;
          } else {
            applicantsByJob[jobId] = [];
          }
        }
      }
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleApplicants(int jobId) async {
    setState(() {
      if (expandedJobs.contains(jobId)) {
        expandedJobs.remove(jobId);
      } else {
        expandedJobs.add(jobId);
      }
    });
  }

  Future<void> _downloadCv(int applicationId) async {
    final url = Uri.parse("$baseUrl/applications/$applicationId/cv");

    final opened = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open CV.")),
      );
    }
  }

  Future<void> _updateStatus({
    required int applicationId,
    required int jobId,
    required String status,
  }) async {
    final response = await JobsService.updateApplicationStatus(
      applicationId: applicationId,
      status: status,
    );

    if (!mounted) return;

    if (response["ok"] == true) {
      final applicantsResponse = await JobsService.getApplicantsByJobId(jobId);

      if (!mounted) return;

      if (applicantsResponse["ok"] == true) {
        setState(() {
          applicantsByJob[jobId] =
              applicantsResponse["data"] as List<dynamic>;
        });
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application marked as $status")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (response["msg"] ?? "Failed to update status.").toString(),
          ),
        ),
      );
    }
  }

  void _openApplicantProfile({
    required Map<String, dynamic> applicant,
    required int jobId,
  }) {
    final int applicationId = applicant["id"] ?? 0;

    final String name =
        applicant["applicant_name"]?.toString() ?? "Unknown Applicant";
    final String email = applicant["applicant_email"]?.toString() ?? "No Email";
    final String status = applicant["status"]?.toString() ?? "Under Review";
    final String cvFilename = applicant["cv_filename"]?.toString() ?? "";
    final bool hasCv = cvFilename.trim().isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.86,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6FB),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6D9E6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2A2F6D),
                          Color(0xFF4A63D3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 42,
                            color: Color(0xFF4A63D3),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _profileInfoCard(
                    icon: Icons.work_outline,
                    title: "Applied Job",
                    value: applicant["job_title"]?.toString() ?? "",
                  ),
                
                  _profileInfoCard(
                    icon: Icons.location_on_outlined,
                    title: "Location",
                    value: applicant["location"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.badge_outlined,
                    title: "Specialization",
                    value: applicant["specialization"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.schedule_outlined,
                    title: "Years of Experience",
                    value: applicant["years_of_experience"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.school_outlined,
                    title: "Education Level",
                    value: applicant["education_level"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.menu_book_outlined,
                    title: "Education",
                    value: applicant["education"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.work_history_outlined,
                    title: "Work Experience",
                    value: applicant["experience"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.person_outline,
                    title: "About",
                    value: applicant["about"]?.toString() ?? "",
                  ),
                  _chipsCard(
                    title: "Skills",
                    icon: Icons.hub_outlined,
                    value: applicant["skills"]?.toString() ?? "",
                  ),
                  _chipsCard(
                    title: "Languages",
                    icon: Icons.language_outlined,
                    value: applicant["languages"]?.toString() ?? "",
                  ),
                  _profileInfoCard(
                    icon: Icons.info_outline,
                    title: "Application Message",
                    value: applicant["info"]?.toString() ?? "",
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Color(0xFFFF9228),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "CV File",
                              style: TextStyle(
                                color: Color(0xFF150B3D),
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          hasCv ? cvFilename : "No CV uploaded",
                          style: const TextStyle(
                            color: Color(0xFF6A6F85),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: applicationId == 0 || !hasCv
                                ? null
                                : () => _downloadCv(applicationId),
                            icon: const Icon(Icons.download_rounded),
                            label: const Text("Download CV"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3866FA),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color(0xFFD8DCE8),
                              disabledForegroundColor:
                                  const Color(0xFF8A90A3),
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (status == "Under Review") ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: applicationId == 0
                                ? null
                                : () => _updateStatus(
                                      applicationId: applicationId,
                                      jobId: jobId,
                                      status: "Accepted",
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF63AD57),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Accept",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: applicationId == 0
                                ? null
                                : () => _updateStatus(
                                      applicationId: applicationId,
                                      jobId: jobId,
                                      status: "Rejected",
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE74C3C),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Reject",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _profileInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFF9228)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF150B3D),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cleanValue,
                  style: const TextStyle(
                    color: Color(0xFF6A6F85),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipsCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final items = value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFF9228)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF150B3D),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFF1B1F3B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _applicantCard({
    required Map<String, dynamic> applicant,
    required int jobId,
  }) {
    final int applicationId = applicant["id"] ?? 0;

    final String name =
        applicant["applicant_name"]?.toString() ?? "Unknown Applicant";

    final String email = applicant["applicant_email"]?.toString() ?? "No Email";

    final String status = applicant["status"]?.toString() ?? "Under Review";

    return GestureDetector(
      onTap: () => _openApplicantProfile(
        applicant: applicant,
        jobId: jobId,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4FA),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFD8E3FF),
              child: Icon(
                Icons.person,
                color: Color(0xFF3866FA),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1F3B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Color(0xFF6A6F85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBgColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF6A6F85),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobCard(Map<String, dynamic> job) {
    final int jobId = job["id"] ?? job["job_id"] ?? 0;
    final bool isExpanded = expandedJobs.contains(jobId);
    final List applicants = applicantsByJob[jobId] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job["title"]?.toString() ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1F3B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            job["company"]?.toString() ?? "",
            style: const TextStyle(
              color: Color(0xFF6A6F85),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            job["description"]?.toString() ?? "",
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6A6F85),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: jobId == 0 ? null : () => _toggleApplicants(jobId),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8E3FF),
              foregroundColor: const Color(0xFF3866FA),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              isExpanded
                  ? "Hide Applicants"
                  : "View Applicants (${applicants.length})",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 14),
            if (applicants.isEmpty)
              const Text(
                "No applicants yet.",
                style: TextStyle(
                  color: Color(0xFF6A6F85),
                ),
              )
            else
              Column(
                children: applicants.map((item) {
                  return _applicantCard(
                    applicant: Map<String, dynamic>.from(item),
                    jobId: jobId,
                  );
                }).toList(),
              ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == "Accepted") return Colors.green;
    if (status == "Rejected") return Colors.red;
    return Colors.orange;
  }

  Color _statusBgColor(String status) {
    if (status == "Accepted") return Colors.green.withOpacity(0.12);
    if (status == "Rejected") return Colors.red.withOpacity(0.12);
    return Colors.orange.withOpacity(0.12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FB),
        elevation: 0,
        title: const Text(
          "Posted Jobs",
          style: TextStyle(
            color: Color(0xFF1B1F3B),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(child: Text("No posted jobs yet."))
              : RefreshIndicator(
                  onRefresh: _loadJobs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = Map<String, dynamic>.from(jobs[index]);
                      return _jobCard(job);
                    },
                  ),
                ),
    );
  }
}