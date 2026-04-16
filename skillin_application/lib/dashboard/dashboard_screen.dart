import 'package:flutter/material.dart';
import 'package:skillin_application/models/application_model.dart';
import 'package:skillin_application/services/application_service.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/services/profile_local_service.dart';
import 'package:skillin_application/profile/edit_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<ApplicationModel>> futureApplications;

  String userName = "User";
  String userEmail = "";
  String city = "";
  String country = "";

  @override
  void initState() {
    super.initState();
    futureApplications = ApplicationService.fetchApplications();
    _loadUser();
  }

  Future<void> _loadUser() async {
  final me = await AuthService.getMe();

  if (me["ok"] == true) {
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(me["data"] as Map);

    final int userId = data["id"];

    final savedCity = await ProfileLocalService.getCity(userId);
    final savedCountry = await ProfileLocalService.getCountry(userId);

    if (mounted) {
      setState(() {
        userName = (data["full_name"] ?? "").toString().isEmpty
            ? "User"
            : data["full_name"];
        userEmail = (data["email"] ?? "").toString();
        city = savedCity;
        country = savedCountry;
      });
    }
  }
}

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );

    await _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: FutureBuilder<List<ApplicationModel>>(
          future: futureApplications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading applications"),
              );
            }

            final applications = snapshot.data ?? [];

            final applied = applications.length;
            final accepted =
                applications.where((e) => e.status == "Accepted").length;
            final rejected =
                applications.where((e) => e.status == "Rejected").length;
            final reviewing =
                applications.where((e) => e.status == "Under Review").length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 24),

                  const Text(
                    "Application Tracker",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B1F3B),
                    ),
                  ),
                  const SizedBox(height: 14),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                    children: [
                      _TrackerCard(
                        title: "Applied Jobs",
                        value: applied.toString(),
                        icon: Icons.bar_chart_rounded,
                        isPrimary: true,
                      ),
                      _TrackerCard(
                        title: "Accepted",
                        value: accepted.toString(),icon: Icons.work_outline_rounded,
                      ),
                      _TrackerCard(
                        title: "Rejected",
                        value: rejected.toString(),
                        icon: Icons.person_outline_rounded,
                      ),
                      _TrackerCard(
                        title: "Under Review",
                        value: reviewing.toString(),
                        icon: Icons.hourglass_empty_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Your Applications",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B1F3B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (applications.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          "No applications yet",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  else
                    ...applications.map(
                      (app) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            app.jobTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(app.company),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor(app.status),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              app.status,
                              style: TextStyle(
                                color: statusColor(app.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    String locationText = "";

    if (city.isNotEmpty && country.isNotEmpty) {
      locationText = "$city, $country";
    } else if (city.isNotEmpty) {
      locationText = city;
    } else if (country.isNotEmpty) {
      locationText = country;
    }

    return Container(width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2A2F6D),
            Color(0xFF4A63D3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.ios_share_outlined, color: Colors.white),
              ),
              IconButton(
                onPressed: _openEditProfile,
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            userEmail.isEmpty ? "No email" : userEmail,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          if (locationText.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              locationText,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 18),
          
          Row(
            children: [
              const _SmallActionButton("Dashboard"),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _openEditProfile,
                child: const _SmallActionButton("Edit Profile"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isPrimary;

  const _TrackerCard({
    required this.title,
    required this.value,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [
                  Color(0xFF2A2F6D),
                  Color(0xFF4A63D3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary ? null : const Color(0xFFE7EBFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isPrimary
            ? const [
                BoxShadow(
                  color: Color(0x334A63D3),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                )
              ]
            : null,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isPrimary ? Colors.amberAccent : const Color(0xFFFF9F43),
            size: 22,
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: isPrimary ? Colors.white : const Color(0xFF1B1F3B),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: isPrimary ? Colors.white70 : const Color(0xFF6A6F85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String text;

  const _SmallActionButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color statusColor(String status) {
  if (status == "Accepted") return Colors.green;
  if (status == "Rejected") return Colors.red;
  return Colors.orange;
}

Color statusBgColor(String status) {
  if (status == "Accepted") return Colors.green.withOpacity(0.12);
  if (status == "Rejected") return Colors.red.withOpacity(0.12);
  return Colors.orange.withOpacity(0.12);
}