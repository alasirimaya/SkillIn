import 'package:flutter/material.dart';
import '../services/jobs_service.dart';

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

  final TextEditingController _educationRequirementController =
      TextEditingController();

  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  String _experienceRequirement = "";

  final List<String> _experienceOptions = [
    "0-1 years",
    "1-3 years",
    "3-5 years",
    "5+ years",
  ];

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

  Widget _dropdownField({
    required String hint,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: _fieldDecoration(hint),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _handlePostJob() async {
    final title = _positionController.text.trim();
    final workplace = _workplaceController.text.trim();
    final location = _locationController.text.trim();
    final company = _companyController.text.trim();
    final employmentType = _employmentTypeController.text.trim();

    final educationRequirement = _educationRequirementController.text.trim();
    final experienceRequirement = _experienceRequirement.trim();
    final languages = _languagesController.text.trim();
    final skills = _skillsController.text.trim();
    final certifications = _certificationsController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || location.isEmpty || company.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill Job position, Job location, and Company."),
        ),
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
      educationRequirement: educationRequirement,
      experienceRequirement: experienceRequirement,
      languages: languages,
      skills: skills,
      description: '''
Education Requirement: $educationRequirement
Experience Requirement: $experienceRequirement
Preferred Languages: $languages
Preferred Certifications: $certifications

$description
''',
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
    _educationRequirementController.dispose();
    _languagesController.dispose();
    _skillsController.dispose();
    _certificationsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _field(
    String title,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
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
              _field("Job location*", _locationController),
              _field("Company*", _companyController),
              _field("Employment type", _employmentTypeController),
              _field("Education requirement", _educationRequirementController),
              _dropdownField(
                hint: "Experience requirement",
                value: _experienceRequirement,
                items: _experienceOptions,
                onChanged: (value) {
                  setState(() {
                    _experienceRequirement = value ?? "";
                  });
                },
              ),
              _field("Languages", _languagesController),
              _field("Preferred Certifications", _certificationsController),
              _field("Required skills", _skillsController),
              _field("Description", _descriptionController, maxLines: 5),
            ],
          ),
        ),
      ),
    );
  }
}