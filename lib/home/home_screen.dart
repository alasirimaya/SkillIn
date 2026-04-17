// import 'package:flutter/material.dart';
// import '../profile/profile_screen.dart';
// import '../auth/auth_gate.dart';
// import '../Jobs/job_details_screen.dart';
// import '../Jobs/job_model.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ProfileScreen()),
//                 );
//               },
//               child: const Text("Go to Profile"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const AuthGate()),
//                 );
//               },
//               child: const Text("Logout"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 JobModel testJob = JobModel(
//                   id: 1,
//                   title: "Test Job",
//                   company: "Test Company",
//                   location: "Riyadh",
//                   category: "IT",
//                   type: "Full Time",
//                   position: "Software Engineer",
//                   salary: "10,000 SAR",
//                   timeAgo: "1 day ago",
//                   logo: "assets/google.png",
//                   description: "This is a test job description.",
//                   skills: "Skill 1, Skill 2",
//                 );

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => JobDetailsScreen(jobId: testJob.id),
//                   ),
//                 );
//               },
//               child: const Text("Job Details"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }