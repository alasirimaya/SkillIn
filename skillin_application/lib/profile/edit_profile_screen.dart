import 'package:flutter/material.dart';
import '../services/profile_local_service.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

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

  int? _userId;
  String _fullName = "User";

  String _educationLevel = "";
  String _yearsOfExperience = "";

  final List<String> _educationOptions = [
    "High School",
    "Diploma",
    "Bachelor",
    "Master",
    "PhD",
  ];

  final List<String> _experienceOptions = [
    "0-1 years",
    "1-3 years",
    "3-5 years",
    "5+ years",
  ];

  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _certificatesController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final meResult = await AuthService.getMe();

    if (meResult["ok"] != true) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final data = Map<String, dynamic>.from(meResult["data"] as Map);
    _userId = data["id"];
    _fullName = (data["full_name"] ?? "User").toString();

    _aboutController.text = await ProfileLocalService.getAbout(_userId!);
    _experienceController.text =
        await ProfileLocalService.getExperience(_userId!);
    _educationController.text =
        await ProfileLocalService.getEducation(_userId!);

    _educationLevel = await ProfileLocalService.getEducationLevel(_userId!);
    _yearsOfExperience =
        await ProfileLocalService.getYearsOfExperience(_userId!);

    _skillsController.text =
        (await ProfileLocalService.getSkills(_userId!)).join(', ');
    _languagesController.text =
        (await ProfileLocalService.getLanguages(_userId!)).join(', ');
    _certificatesController.text =
        (await ProfileLocalService.getCertificates(_userId!)).join(', ');

    _cityController.text = await ProfileLocalService.getCity(_userId!);
    _countryController.text = await ProfileLocalService.getCountry(_userId!);

    if (mounted) setState(() => _loading = false);
  }

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _saveProfile() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not find current user.")),
      );
      return;
    }

    setState(() => _saving = true);

    final skillsList = _splitList(_skillsController.text);
    final languagesList = _splitList(_languagesController.text);
    final certificatesList = _splitList(_certificatesController.text);

    final city = _cityController.text.trim();
    final country = _countryController.text.trim();
    final locationText = [city, country].where((e) => e.isNotEmpty).join(", ");

    try {
      await ProfileLocalService.saveAll(
        userId: _userId!,
        about: _aboutController.text.trim(),
        experience: _experienceController.text.trim(),
        education: _educationController.text.trim(),
        educationLevel: _educationLevel,
        yearsOfExperience: _yearsOfExperience,
        skills: skillsList,
        languages: languagesList,
        certificates: certificatesList,
        city: city,
        country: country,
      );

      final token = await AuthService.getToken();

      await ApiClient(baseUrl: "http://127.0.0.1:8000").postJson(
        "/api/v1/profile/save",
        token: token,
        body: {
          "user_id": _userId!,
          "full_name": _fullName,
          "about": _aboutController.text.trim(),
          "experience": _experienceController.text.trim(),
          "education": _educationController.text.trim(),
          "education_level": _educationLevel,
          "years_of_experience": _yearsOfExperience,
          "skills": skillsList,
          "languages": languagesList,
          "certificates": certificatesList,
          "location": locationText,
        },
      );

      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _languagesController.dispose();
    _certificatesController.dispose();
    _cityController.dispose();
    _countryController.dispose();
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

  Widget _buildDropdown({
    required String value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: _fieldDecoration(hint),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
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
                title: "Years of experience",
                child: _buildDropdown(
                  value: _yearsOfExperience,
                  hint: "Select years of experience",
                  items: _experienceOptions,
                  onChanged: (value) {
                    setState(() {
                      _yearsOfExperience = value ?? "";
                    });
                  },
                ),
              ),

              _buildSectionCard(
                icon: Icons.work_outline,
                title: "Work experience",
                child: _buildTextField(
                  controller: _experienceController,
                  hint: "Example: Marketing Intern at Unilever (2023 - 2024)",
                  maxLines: 3,
                ),
              ),

              _buildSectionCard(
                icon: Icons.school_outlined,
                title: "Education level",
                child: _buildDropdown(
                  value: _educationLevel,
                  hint: "Select education level",
                  items: _educationOptions,
                  onChanged: (value) {
                    setState(() {
                      _educationLevel = value ?? "";
                    });
                  },
                ),
              ),

              _buildSectionCard(
                icon: Icons.school_outlined,
                title: "Education",
                child: _buildTextField(
                  controller: _educationController,
                  hint: "Example: Bachelor of Marketing",
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
                      "Example: Digital Marketing, SEO, Branding, Analytics",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                icon: Icons.verified_outlined,
                title: "Certificates",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _certificatesController,
                      hint: "Enter certificates separated by commas",
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Example: Google Ads, HubSpot Marketing, Meta Blueprint",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              _buildSectionCard(
                icon: Icons.location_city_outlined,
                title: "City",
                child: _buildTextField(
                  controller: _cityController,
                  hint: "Enter your city",
                ),
              ),

              _buildSectionCard(
                icon: Icons.public_outlined,
                title: "Country",
                child: _buildTextField(
                  controller: _countryController,
                  hint: "Enter your country",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}