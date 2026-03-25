import 'package:flutter/material.dart';
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




