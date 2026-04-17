// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileLocalService {
//   static const String _aboutKey = 'profile_about';
//   static const String _experienceKey = 'profile_experience';
//   static const String _educationKey = 'profile_education';
//   static const String _skillsKey = 'profile_skills';
//   static const String _languagesKey = 'profile_languages';
//   static const String _resumeNameKey = 'profile_resume_name';

//   static Future<void> saveAbout(String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_aboutKey, value);
//   }

//   static Future<String> getAbout() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_aboutKey) ?? '';
//   }

//   static Future<void> saveExperience(String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_experienceKey, value);
//   }

//   static Future<String> getExperience() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_experienceKey) ?? '';
//   }

//   static Future<void> saveEducation(String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_educationKey, value);
//   }

//   static Future<String> getEducation() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_educationKey) ?? '';
//   }

//   static Future<void> saveSkills(List<String> skills) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_skillsKey, jsonEncode(skills));
//   }

//   static Future<List<String>> getSkills() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getString(_skillsKey);
//     if (raw == null || raw.isEmpty) return [];
//     final decoded = jsonDecode(raw);
//     return List<String>.from(decoded);
//   }

//   static Future<void> saveLanguages(List<String> languages) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_languagesKey, jsonEncode(languages));
//   }

//   static Future<List<String>> getLanguages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getString(_languagesKey);
//     if (raw == null || raw.isEmpty) return [];
//     final decoded = jsonDecode(raw);
//     return List<String>.from(decoded);
//   }

//   static Future<void> saveResumeName(String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_resumeNameKey, value);
//   }

//   static Future<String> getResumeName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_resumeNameKey) ?? '';
//   }

//   static Future<void> saveAll({
//     required String about,
//     required String experience,
//     required String education,
//     required List<String> skills,
//     required List<String> languages,
//     required String resumeName,
//   }) async {
//     await saveAbout(about);
//     await saveExperience(experience);
//     await saveEducation(education);
//     await saveSkills(skills);
//     await saveLanguages(languages);
//     await saveResumeName(resumeName);
//   }
// }