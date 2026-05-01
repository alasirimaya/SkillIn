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

  Widget _applicantCard({
    required Map<String, dynamic> applicant,
    required int jobId,
  }) {
    final int applicationId = applicant["id"] ?? 0;

    final String name =
        applicant["applicant_name"]?.toString() ?? "Unknown Applicant";

    final String email =
        applicant["applicant_email"]?.toString() ?? "No Email";

    final String cvFilename =
        applicant["cv_filename"]?.toString() ?? "";

    final String status =
        applicant["status"]?.toString() ?? "Under Review";

    final bool hasCv = cvFilename.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4FA),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE5D8FF),
                child: Icon(
                  Icons.person,
                  color: Color(0xFF5F3DC4),
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
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Applicant CV",
                  style: TextStyle(
                    color: Color(0xFF1B1F3B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasCv ? cvFilename : "No CV uploaded",
                  style: const TextStyle(
                    color: Color(0xFF6A6F85),
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
                      disabledBackgroundColor: const Color(0xFFD8DCE8),
                      disabledForegroundColor: const Color(0xFF8A90A3),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: _statusBgColor(status),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _statusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (status == "Under Review") ...[
            const SizedBox(height: 14),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Accept"),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ],
        ],
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