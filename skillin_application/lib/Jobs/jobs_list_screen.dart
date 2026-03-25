import 'package:flutter/material.dart';
import 'dummy_jobs.dart';
import 'job_card.dart';
import 'job_details_screen.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Find Your Job",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search for jobs...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Jobs List
            Expanded(
              child: ListView.builder(
                itemCount: dummyJobs.length,
                itemBuilder: (context, index) {
                  return JobCard(
                    job: dummyJobs[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              JobDetailsScreen(job: dummyJobs[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





