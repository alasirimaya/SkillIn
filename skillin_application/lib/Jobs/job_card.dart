import 'package:flutter/material.dart';
import 'job_model.dart';
import 'job_details_screen.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailsScreen(job: job),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title + Company
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              job.company,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            // Location + Type
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 4),
                Text(job.location),
                const SizedBox(width: 15),
                const Icon(Icons.work, size: 18),
                const SizedBox(width: 4),
                Text(job.jobType),
              ],
            ),

            const SizedBox(height: 10),

            // Salary
            Text(
              job.salary,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Posted time
            const Text(
              "25 minutes ago",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}



