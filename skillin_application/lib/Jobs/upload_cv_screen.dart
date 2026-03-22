import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'job_model.dart';
import 'success_screen.dart';

class UploadCVScreen extends StatefulWidget {
  final Job job;

  const UploadCVScreen({super.key, required this.job});

  @override
  State<UploadCVScreen> createState() => _UploadCVScreenState();
}

class _UploadCVScreenState extends State<UploadCVScreen> {
  String? selectedFile;

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
      appBar: AppBar(title: const Text("Upload CV")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    const Icon(Icons.upload_file),
                    const SizedBox(width: 10),
                    Text(selectedFile ?? "Tap to select CV file"),
                  ],
                ),
              ),
            ),

            const Spacer(),

            ElevatedButton(
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
              child: const Text("Submit Application"),
            ),
          ],
        ),
      ),
    );
  }
}






