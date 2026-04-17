import 'package:flutter/material.dart';
import 'package:skillin_application/services/jobs_service.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _workplaceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _employmentTypeController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _handlePostJob() async {
    final title = _positionController.text.trim();
    final workplace = _workplaceController.text.trim();
    final location = _locationController.text.trim();
    final company = _companyController.text.trim();
    final employmentType = _employmentTypeController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty ||
        workplace.isEmpty ||
        location.isEmpty ||
        company.isEmpty ||
        employmentType.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await JobsService.createJob(
      title: title,
      company: company,
      workplace: workplace,
      location: location,
      employmentType: employmentType,
      description: description,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result["ok"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((result["msg"] ?? "Failed to post job.").toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _workplaceController.dispose();
    _locationController.dispose();
    _companyController.dispose();
    _employmentTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _field(String title, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: _fieldDecoration(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FB),
        elevation: 0,
        foregroundColor: const Color(0xFF150B3D),
        title: const Text("Add a job"),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handlePostJob,
            child: Text(
              _isLoading ? "Posting..." : "Post",
              style: const TextStyle(
                color: Color(0xFFFF9228),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field("Job position*", _positionController),
              _field("Type of workplace", _workplaceController),
              _field("Job location", _locationController),
              _field("Company", _companyController),
              _field("Employment type", _employmentTypeController),
              _field("Description", _descriptionController, maxLines: 5),
            ],
          ),
        ),
      ),
    );
  }
}