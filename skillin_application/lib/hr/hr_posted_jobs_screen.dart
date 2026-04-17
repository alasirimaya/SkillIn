import 'package:flutter/material.dart';
import 'package:skillin_application/services/jobs_service.dart';

class HrPostedJobsScreen extends StatefulWidget {
  const HrPostedJobsScreen({super.key});

  @override
  State<HrPostedJobsScreen> createState() => _HrPostedJobsScreenState();
}

class _HrPostedJobsScreenState extends State<HrPostedJobsScreen> {
  bool isLoading = true;
  List jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final response = await JobsService.getJobs();

    if (!mounted) return;

    if (response["ok"] == true) {
      setState(() {
        jobs = response["data"] as List;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
          style: TextStyle(color: Color(0xFF1B1F3B)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(child: Text("No posted jobs yet."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = Map<String, dynamic>.from(jobs[index]);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          const SizedBox(height: 8),
                          Text(
                            job["description"]?.toString() ?? "",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6A6F85),
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