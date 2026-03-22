import 'package:flutter/material.dart';
import 'job_model.dart';
import 'job_details_screen.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  String selectedType = "Full time";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Find Jobs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for a job",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Location
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Riyadh, KSA",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                filterChip("Full time"),
                filterChip("Part time"),
                filterChip("Remote"),
              ],
            ),

            const SizedBox(height: 20),

            // Job List
            Expanded(
              child: ListView(
                children: [
                  jobCard(
                    Job(
                      title: "IT Coordinator",
                      company: "Google Inc.",
                      location: "Riyadh, KSA",
                      jobType: "Full time",
                      salary: "\$15K/Mo",
                      description: "Senior IT Engineer",
                      skills: ["Networking", "Security", "Cloud"],
                    ),
                  ),
                  jobCard(
                    Job(
                      title: "Lead Designer",
                      company: "Dribbble Inc.",
                      location: "Dammam, KSA",
                      jobType: "Full time",
                      salary: "\$20K/Mo",
                      description: "Senior Designer",
                      skills: ["UI/UX", "Figma", "Branding"],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Chip Widget
  Widget filterChip(String label) {
    final bool isSelected = selectedType == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Job Card Widget
  Widget jobCard(Job job) {
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




