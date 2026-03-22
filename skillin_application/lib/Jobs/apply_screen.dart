import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'job_model.dart';
import 'success_screen.dart';

class ApplyScreen extends StatefulWidget {
  final Job job;

  const ApplyScreen({super.key, required this.job});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  String? selectedFile;
  final TextEditingController infoController = TextEditingController();

  void pickFile() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf,.doc,.docx';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      setState(() {
        selectedFile = file.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(widget.job.title),
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
                    Text(widget.job.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(widget.job.company,
                        style: const TextStyle(color: Colors.grey)),
                    Text(widget.job.location,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 35),

            // Upload CV Section
            const Text(
              "Upload CV",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Add your CV/Resume to apply for a job",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upload_file, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      selectedFile ?? "Upload CV/Resume",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Information Section
            const Text(
              "Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: infoController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Explain why you are the right person for this job",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedFile == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuccessScreen(
                              job: widget.job,
                              fileName: selectedFile!,
                            ),
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





