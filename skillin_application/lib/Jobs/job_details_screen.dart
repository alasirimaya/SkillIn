import 'package:flutter/material.dart';
import 'job_model.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(job.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business, size: 30),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(job.company,
                        style: const TextStyle(color: Colors.grey)),
                    Text(job.location,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Job Description
            const Text(
              "Job Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              job.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 25),

            // Required Skills
            const Text(
              "Required Skills",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: job.skills
                  .map(
                    (skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            skill,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 40),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApplyScreen(job: job),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "APPLY NOW",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



