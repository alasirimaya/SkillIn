import 'package:flutter/material.dart';
import '../services/profile_local_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color orangeColor = Color(0xFFFF9228);
  static const Color darkBlueText = Color(0xFF150B3D);
  static const Color pageBg = Color(0xFFF5F6FA);
  static const Color lineColor = Color(0xFFE8E8EF);
  static const Color cardColor = Colors.white;

  bool _loading = true;
  bool _saving = false;

  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final about = await ProfileLocalService.getAbout();
    final experience = await ProfileLocalService.getExperience();
    final education = await ProfileLocalService.getEducation();
    final skills = await ProfileLocalService.getSkills();
    final languages = await ProfileLocalService.getLanguages();
    final resume = await ProfileLocalService.getResumeName();

    _aboutController.text = about;
    _experienceController.text = experience;
    _educationController.text = education;
    _skillsController.text = skills.join(', ');
    _languagesController.text = languages.join(', ');
    _resumeController.text = resume;

    setState(() {
      _loading = false;
    });
  }

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);

    await ProfileLocalService.saveAll(
      about: _aboutController.text.trim(),
      experience: _experienceController.text.trim(),
      education: _educationController.text.trim(),
      skills: _splitList(_skillsController.text),
      languages: _splitList(_languagesController.text),
      resumeName: _resumeController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile information saved successfully."),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _languagesController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF49508E), Color(0xFF4660D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 30, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const Text(
            "Edit your profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Update your information and save the changes.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saving ? null : _saveProfile,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? "Saving..." : "Save Profile"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: orangeColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: darkBlueText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.edit_outlined, color: Color(0xFF0E397B)),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: lineColor),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF8F8FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _fieldDecoration(hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: pageBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        foregroundColor: darkBlueText,
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              _buildHeader(),

              _buildSectionCard(
                icon: Icons.person_outline,
                title: "About me",
                child: _buildTextField(
                  controller: _aboutController,
                  hint: "Write a short summary about yourself",
                  maxLines: 4,
                ),
              ),

              _buildSectionCard(
                icon: Icons.work_outline,
                title: "Work experience",
                child: _buildTextField(
                  controller: _experienceController,
                  hint: "Example: Manager at PWC (2021 - 2025)",
                  maxLines: 3,
                ),
              ),

              _buildSectionCard(
                icon: Icons.school_outlined,
                title: "Education",
                child: _buildTextField(
                  controller: _educationController,
                  hint: "Example: Information Technology - PNU",
                  maxLines: 3,
                ),
              ),

              _buildSectionCard(
                icon: Icons.hub_outlined,
                title: "Skill",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _skillsController,
                      hint: "Enter skills separated by commas",
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Example: Leadership, Teamwork, Communication",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                icon: Icons.workspace_premium_outlined,
                title: "Language",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _languagesController,
                      hint: "Enter languages separated by commas",
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Example: English, Arabic, Spanish",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                icon: Icons.description_outlined,
                title: "Resume",
                child: _buildTextField(
                  controller: _resumeController,
                  hint: "Enter your resume file name",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}