import 'package:flutter/material.dart';
import 'dummy_jobs.dart';
import 'job_card.dart';
import 'job_details_screen.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Jobs"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: dummyJobs.length,
        itemBuilder: (context, index) {
          final job = dummyJobs[index];
          return JobCard(
            job: job,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailsScreen(job: job),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

