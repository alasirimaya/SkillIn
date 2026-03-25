import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'job_model.dart';
import 'success_screen.dart';

class ApplyScreen extends StatefulWidget {
  final JobModel job;

  const ApplyScreen({super.key, required this.job});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  String? uploadedFileName;
  final TextEditingController infoController = TextEditingController();

  Future<void> pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        uploadedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title
            Text(widget.job.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            Text("${widget.job.company} • ${widget.job.location}",
                style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 30),

            // Upload CV Section
            const Text("Upload CV",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Add your CV/Resume to apply for a job",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: pickCV,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upload_file, color: Colors.blue, size: 30),
                    const SizedBox(width: 12),
                    Text(
                      uploadedFileName ?? "Upload CV/Resume",
                      style: TextStyle(
                        color: uploadedFileName == null
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Information Section
            const Text("Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Explain why you are the right person for the job",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 15),

            TextField(
              controller: infoController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write here...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 40),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuccessScreen(
                        job: widget.job,
                        fileName: uploadedFileName ?? "CV.pdf",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "APPLY NOW",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}







