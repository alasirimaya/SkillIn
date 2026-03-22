import 'package:flutter/material.dart';
import 'job_model.dart';

class SuccessScreen extends StatelessWidget {
  final Job job;
  final String fileName;

  const SuccessScreen({
    super.key,
    required this.job,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Application Sent!",
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Text("Job: ${job.title}"),
            Text("Company: ${job.company}"),
            Text("Location: ${job.location}"),

            const SizedBox(height: 20),

            Text("Uploaded File: $fileName"),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName("/home"));
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}





