import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'job_model.dart';
import 'success_screen.dart';

class UploadCVScreen extends StatefulWidget {
  final Job job;

  const UploadCVScreen({super.key, required this.job});

  @override
  State<UploadCVScreen> createState() => _UploadCVScreenState();
}

class _UploadCVScreenState extends State<UploadCVScreen> {
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload CV")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Job: ${widget.job.title}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text("Upload your CV to complete the application."),
            SizedBox(height: 24),

            // زر اختيار الملف
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedFile == null
                            ? "Tap to select CV file"
                            : selectedFile!.name,
                        style: TextStyle(
                          color: selectedFile == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // زر الإرسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedFile == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuccessScreen(job: widget.job),
                          ),
                        );
                      },
                child: Text("Submit Application"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
