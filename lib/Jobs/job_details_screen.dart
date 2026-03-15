import 'package:flutter/material.dart';
import 'job_model.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(job.company,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 4),
              Text(job.location,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 12),
              Row(
                children: [
                  Chip(label: Text(job.jobType)),
                  SizedBox(width: 8),
                  Chip(label: Text(job.salary)),
                ],
              ),
              SizedBox(height: 16),
              Text("Job Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(job.description),
              SizedBox(height: 16),
              Text("Required Skills",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: job.skills
                    .map((skill) => Chip(label: Text(skill)))
                    .toList(),
              ),
              SizedBox(height: 24),
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
                  child: Text("Apply Now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
