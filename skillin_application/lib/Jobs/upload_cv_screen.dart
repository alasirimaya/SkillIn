import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadCVScreen extends StatefulWidget {
  const UploadCVScreen({super.key});

  @override
  State<UploadCVScreen> createState() => _UploadCVScreenState();
}

class _UploadCVScreenState extends State<UploadCVScreen> {
  String? fileName;

  Future<void> pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload CV")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: pickCV,
              child: const Text("Choose File"),
            ),
            const SizedBox(height: 20),
            if (fileName != null)
              Text(
                "Selected: $fileName",
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}








