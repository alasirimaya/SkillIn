// import 'package:flutter/material.dart';
// import 'package:skillin_application/profile/edit_profile_screen.dart';
// import '../services/auth_service.dart';
// import '../services/profile_local_service.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _loading = true;

//   String name = "";
//   String email = "";
//   String about = "";
//   String experience = "";
//   String education = "";
//   List<String> skills = [];
//   List<String> languages = [];
//   String resume = "";

//   bool showAbout = false;
//   bool showExperience = false;
//   bool showEducation = false;
//   bool showSkills = false;
//   bool showLanguages = false;
//   bool showResume = false;

//   static const orange = Color(0xFFFF9228);
//   static const blueText = Color(0xFF150B3D);
//   static const plusBg = Color(0xFFD9E3F8);
//   static const plusIcon = Color(0xFF180F40);
//   static const pageBg = Color(0xFFF5F6FA);
//   static const lineColor = Color(0xFFE8E8EF);

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     final me = await AuthService.getMe();

//     if (me["ok"] == true) {
//       final data = me["data"];
//       name = data["full_name"] ?? "";
//       email = data["email"] ?? "";
//     }

//     about = await ProfileLocalService.getAbout();
//     experience = await ProfileLocalService.getExperience();
//     education = await ProfileLocalService.getEducation();
//     skills = await ProfileLocalService.getSkills();
//     languages = await ProfileLocalService.getLanguages();
//     resume = await ProfileLocalService.getResumeName();

//     if (mounted) {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _openEditProfile() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const EditProfileScreen(),
//       ),
//     );

//     await _loadProfile();
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(
//         20,
//         MediaQuery.of(context).padding.top + 24,
//         20,
//         20,
//       ),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF49508E), Color(0xFF4660D6)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           const CircleAvatar(
//             radius: 35,
//             backgroundColor: Colors.white,
//             child: Icon(Icons.person, size: 35),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             name.isEmpty ? "User" : name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             email.isEmpty ? "No email" : email,
//             style: const TextStyle(color: Colors.white70),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.black,
//             ),
//             onPressed: _openEditProfile,
//             child: const Text("Edit Profile"),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF2F2F6),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.black87),
//       ),
//     );
//   }

//   Widget _buildSectionCard({
//     required String title,
//     required IconData icon,
//     required bool expanded,
//     required VoidCallback onPlusTap,
//     required Widget content,
//     bool showEdit = true,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: orange),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     color: blueText,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               if (showEdit)
//                 GestureDetector(
//                   onTap: _openEditProfile,
//                   child: const Icon(
//                     Icons.edit_outlined,
//                     color: Color(0xFF0E397B),
//                   ),
//                 ),
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: onPlusTap,
//                 child: Container(
//                   width: 34,
//                   height: 34,
//                   decoration: const BoxDecoration(
//                     color: plusBg,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     expanded ? Icons.remove : Icons.add,
//                     color: plusIcon,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (expanded) ...[
//             const SizedBox(height: 14),
//             const Divider(color: lineColor),
//             const SizedBox(height: 12),
//             content,
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _emptyText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         color: Colors.grey,
//         fontSize: 14,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         backgroundColor: pageBg,
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: pageBg,
//       body: SafeArea(
//         top: false,
//         child: Column(
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 12),
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildSectionCard(
//                     title: "About me",
//                     icon: Icons.person_outline,
//                     expanded: showAbout,
//                     onPlusTap: () {
//                       setState(() {
//                         showAbout = !showAbout;
//                       });
//                     },
//                     content: Align(
//                       alignment: Alignment.centerLeft,
//                       child: about.isEmpty
//                           ? _emptyText("No information added yet.")
//                           : Text(
//                               about,
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 15,
//                                 height: 1.5,
//                               ),
//                             ),
//                     ),
//                   ),
//                   _buildSectionCard(
//                     title: "Work experience",
//                     icon: Icons.work_outline,
//                     expanded: showExperience,
//                     onPlusTap: () {
//                       setState(() {
//                         showExperience = !showExperience;
//                       });
//                     },
//                     content: Align(
//                       alignment: Alignment.centerLeft,
//                       child: experience.isEmpty
//                           ? _emptyText("No work experience added yet.")
//                           : Text(
//                               experience,
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 15,
//                                 height: 1.5,
//                               ),
//                             ),
//                     ),
//                   ),
//                   _buildSectionCard(
//                     title: "Education",
//                     icon: Icons.school_outlined,
//                     expanded: showEducation,
//                     onPlusTap: () {
//                       setState(() {
//                         showEducation = !showEducation;
//                       });
//                     },
//                     content: Align(
//                       alignment: Alignment.centerLeft,
//                       child: education.isEmpty
//                           ? _emptyText("No education added yet.")
//                           : Text(
//                               education,
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 15,
//                                 height: 1.5,
//                               ),
//                             ),
//                     ),
//                   ),
//                   _buildSectionCard(
//                     title: "Skill",
//                     icon: Icons.hub_outlined,
//                     expanded: showSkills,
//                     onPlusTap: () {
//                       setState(() {
//                         showSkills = !showSkills;
//                       });
//                     },
//                     content: skills.isEmpty
//                         ? _emptyText("No skills added yet.")
//                         : Wrap(
//                             spacing: 10,
//                             runSpacing: 10,
//                             children: skills.map(_buildChip).toList(),
//                           ),
//                   ),
//                   _buildSectionCard(
//                     title: "Language",
//                     icon: Icons.workspace_premium_outlined,
//                     expanded: showLanguages,
//                     onPlusTap: () {
//                       setState(() {
//                         showLanguages = !showLanguages;
//                       });
//                     },
//                     content: languages.isEmpty
//                         ? _emptyText("No languages added yet.")
//                         : Wrap(
//                             spacing: 10,
//                             runSpacing: 10,
//                             children: languages.map(_buildChip).toList(),
//                           ),
//                   ),
//                   _buildSectionCard(
//                     title: "Resume",
//                     icon: Icons.description_outlined,
//                     expanded: showResume,
//                     onPlusTap: () {
//                       setState(() {
//                         showResume = !showResume;
//                       });
//                     },
//                     content: resume.isEmpty
//                         ? _emptyText("No resume added yet.")
//                         : Row(
//                             children: [
//                               Container(
//                                 width: 44,
//                                 height: 52,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF5F5F),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   "PDF",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 14),
//                               Expanded(
//                                 child: Text(
//                                   resume,
//                                   style: const TextStyle(
//                                     color: blueText,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }