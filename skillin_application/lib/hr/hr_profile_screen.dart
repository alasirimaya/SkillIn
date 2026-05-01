import 'package:flutter/material.dart';
import 'edit_hr_profile_screen.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/services/api_client.dart';

class HrProfileScreen extends StatefulWidget {
  const HrProfileScreen({super.key});

  @override
  State<HrProfileScreen> createState() => _HrProfileScreenState();
}

class _HrProfileScreenState extends State<HrProfileScreen> {
  bool loading = true;

  String fullName = "";
  String jobTitle = "";
  String workEmail = "";
  String phoneNumber = "";
  String officeLocation = "";
  String bio = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final token = await AuthService.getToken();

    final data = await ApiClient(
      baseUrl: "http://127.0.0.1:8000",
    ).getJson<Map<String, dynamic>>(
      "/api/v1/hr-profile/me",
      token: token,
      parser: (json) => (json as Map).cast<String, dynamic>(),
    );

    setState(() {
      fullName = data["full_name"] ?? "";
      jobTitle = data["job_title"] ?? "";
      workEmail = data["work_email"] ?? "";
      phoneNumber = data["phone_number"] ?? "";
      officeLocation = data["office_location"] ?? "";
      bio = data["bio"] ?? "";
      loading = false;
    });
  }

  Future<void> openEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditHrProfileScreen(),
      ),
    );

    loadProfile();
  }

  Widget buildItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        title: const Text("HR Profile"),
        actions: [
          IconButton(
            onPressed: openEdit,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            buildItem("Full Name", fullName),
            buildItem("Job Title", jobTitle),
            buildItem("Work Email", workEmail),
            buildItem("Phone Number", phoneNumber),
            buildItem("Office Location", officeLocation),
            buildItem("Bio", bio),
          ],
        ),
      ),
    );
  }
}