import 'package:flutter/material.dart';
import 'job_model.dart';
import 'upload_cv_screen.dart';

class ApplyScreen extends StatelessWidget {
  final Job job;

  const ApplyScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for ${job.title}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(job.company,
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 16),
            Text(
              "To apply for this job, please upload your CV and confirm your application.",
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UploadCVScreen(job: job),
                    ),
                  );
                },
                child: Text("Upload CV"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
