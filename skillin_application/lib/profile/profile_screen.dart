import 'package:flutter/material.dart';
import 'package:skillin_application/profile/edit_profile_screen.dart';
import '../services/auth_service.dart';
import '../services/profile_local_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  int? userId;

  String name = "";
  String email = "";
  String about = "";
  String experience = "";
  String education = "";
  String educationLevel = "";
  String yearsOfExperience = "";
  List<String> skills = [];
  List<String> languages = [];
  List<String> certificates = [];

  bool showAbout = false;
  bool showYearsOfExperience = false;
  bool showExperience = false;
  bool showEducationLevel = false;
  bool showEducation = false;
  bool showSkills = false;
  bool showCertificates = false;
  bool showLanguages = false;

  static const orange = Color(0xFFFF9228);
  static const blueText = Color(0xFF150B3D);
  static const plusBg = Color(0xFFD9E3F8);
  static const plusIcon = Color(0xFF180F40);
  static const pageBg = Color(0xFFF5F6FA);
  static const lineColor = Color(0xFFE8E8EF);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final me = await AuthService.getMe();

    if (me["ok"] == true) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(me["data"] as Map);

      userId = data["id"];
      name = data["full_name"] ?? "";
      email = data["email"] ?? "";

      about = await ProfileLocalService.getAbout(userId!);
      experience = await ProfileLocalService.getExperience(userId!);
      education = await ProfileLocalService.getEducation(userId!);
      educationLevel = await ProfileLocalService.getEducationLevel(userId!);
      yearsOfExperience =
          await ProfileLocalService.getYearsOfExperience(userId!);
      skills = await ProfileLocalService.getSkills(userId!);
      certificates = await ProfileLocalService.getCertificates(userId!);
      languages = await ProfileLocalService.getLanguages(userId!);
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );

    await _loadProfile();
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 24,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF49508E), Color(0xFF4660D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 35),
          ),
          const SizedBox(height: 10),
          Text(
            name.isEmpty ? "User" : name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email.isEmpty ? "No email" : email,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: _openEditProfile,
            child: const Text("Edit Profile"),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black87)),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onPlusTap,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: orange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: blueText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _openEditProfile,
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF0E397B),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onPlusTap,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: plusBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    expanded ? Icons.remove : Icons.add,
                    color: plusIcon,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 14),
            const Divider(color: lineColor),
            const SizedBox(height: 12),
            content,
          ],
        ],
      ),
    );
  }

  Widget _emptyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }

  Widget _plainTextSection(String value, String emptyMessage) {
    return Align(
      alignment: Alignment.centerLeft,
      child: value.isEmpty
          ? _emptyText(emptyMessage)
          : Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.5,
              ),
            ),
    );
  }

  Widget _chipSection(List<String> items, String emptyMessage) {
    return items.isEmpty
        ? _emptyText(emptyMessage)
        : Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map(_buildChip).toList(),
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
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionCard(
                    title: "About me",
                    icon: Icons.person_outline,
                    expanded: showAbout,
                    onPlusTap: () => setState(() => showAbout = !showAbout),
                    content: _plainTextSection(
                      about,
                      "No information added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Years of experience",
                    icon: Icons.schedule_outlined,
                    expanded: showYearsOfExperience,
                    onPlusTap: () => setState(
                      () => showYearsOfExperience = !showYearsOfExperience,
                    ),
                    content: _plainTextSection(
                      yearsOfExperience,
                      "No years of experience added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Work experience",
                    icon: Icons.work_outline,
                    expanded: showExperience,
                    onPlusTap: () =>
                        setState(() => showExperience = !showExperience),
                    content: _plainTextSection(
                      experience,
                      "No work experience added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Education level",
                    icon: Icons.school_outlined,
                    expanded: showEducationLevel,
                    onPlusTap: () => setState(
                      () => showEducationLevel = !showEducationLevel,
                    ),
                    content: _plainTextSection(
                      educationLevel,
                      "No education level added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Education",
                    icon: Icons.school_outlined,
                    expanded: showEducation,
                    onPlusTap: () =>
                        setState(() => showEducation = !showEducation),
                    content: _plainTextSection(
                      education,
                      "No education added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Skills",
                    icon: Icons.hub_outlined,
                    expanded: showSkills,
                    onPlusTap: () => setState(() => showSkills = !showSkills),
                    content: _chipSection(
                      skills,
                      "No skills added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Certificates",
                    icon: Icons.verified_outlined,
                    expanded: showCertificates,
                    onPlusTap: () => setState(
                      () => showCertificates = !showCertificates,
                    ),
                    content: _chipSection(
                      certificates,
                      "No certificates added yet.",
                    ),
                  ),
                  _buildSectionCard(
                    title: "Languages",
                    icon: Icons.workspace_premium_outlined,
                    expanded: showLanguages,
                    onPlusTap: () =>
                        setState(() => showLanguages = !showLanguages),
                    content: _chipSection(
                      languages,
                      "No languages added yet.",
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}