import 'package:flutter/material.dart';
import 'job_model.dart';

class SuccessScreen extends StatelessWidget {
  final Job job;

  const SuccessScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text(
                "Application Submitted!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "You have successfully applied for ${job.title} at ${job.company}.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text("Back to Home"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
