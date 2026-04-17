/*import 'package:flutter/material.dart';
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


*/
/*
import 'package:skillin_application/models/application_model.dart';
import 'package:skillin_application/services/application_service.dart';
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
            Text(
              widget.job.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.job.company,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            const Text(
              "Upload CV",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add your CV/Resume to apply for a job",
              style: TextStyle(color: Colors.grey),
            ),
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
            const Text(
              "Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Explain why you are the right person for the job",
              style: TextStyle(color: Colors.grey),
            ),
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
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
*/
import 'package:skillin_application/models/application_model.dart';
import 'package:skillin_application/services/application_service.dart';
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

  void submitApplication() {
    ApplicationService.addLocalApplication(
      
    ApplicationModel(
      jobTitle: widget.job.title,
        company: widget.job.company,
      status: "Under Review",
     ),
       
);
    

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          job: widget.job,
          fileName: uploadedFileName ?? "CV.pdf",
        ),
      ),
    );
  }

  @override
  void dispose() {
    infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF1B1F3B),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.more_vert,
                              color: Color(0xFF1B1F3B),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDF3FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business,
                          size: 42,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.job.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B1F3B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Google",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1B1F3B),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("•"),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Riyadh",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1B1F3B),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("•"),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "1 day ago",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1B1F3B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9F9FC),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Upload CV",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B1F3B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Add your CV/Resume to apply for a job",
                              style: TextStyle(
                                color: Color(0xFF6A6F85),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: pickCV,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 26,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFD7D8E2),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.upload_file_outlined,
                                      color: Color(0xFF6A6F85),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        uploadedFileName ?? "Upload CV/Resume",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF1B1F3B),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              "Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B1F3B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: TextField(
                                controller: infoController,
                                maxLines: 8,
                                decoration: const InputDecoration(
                                  hintText:
                                      "Explain why you are the right person for this job",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB0B3C7),
                                  ),
                                  contentPadding: EdgeInsets.all(18),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F1F57),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: submitApplication,
                  child: const Text(
                    "APPLY NOW",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}