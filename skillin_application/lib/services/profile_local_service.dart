import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLocalService {
  static const String _aboutKey = 'profile_about';
  static const String _experienceKey = 'profile_experience';
  static const String _educationKey = 'profile_education';
  static const String _educationLevelKey = 'profile_education_level';
  static const String _yearsOfExperienceKey = 'profile_years_of_experience';
  static const String _skillsKey = 'profile_skills';
  static const String _languagesKey = 'profile_languages';
  static const String _certificatesKey = 'profile_certificates';
  static const String _cityKey = 'profile_city';
  static const String _countryKey = 'profile_country';

  static String _key(String baseKey, int userId) => '${baseKey}_$userId';

  static Future<String> _getStringWithMigration(
    String baseKey,
    int userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _key(baseKey, userId);

    final userValue = prefs.getString(userKey);
    if (userValue != null) return userValue;

    final oldValue = prefs.getString(baseKey);
    if (oldValue != null) {
      await prefs.setString(userKey, oldValue);
      return oldValue;
    }

    return '';
  }

  static Future<List<String>> _getListWithMigration(
    String baseKey,
    int userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _key(baseKey, userId);

    final userValue = prefs.getString(userKey);
    if (userValue != null && userValue.isNotEmpty) {
      return List<String>.from(jsonDecode(userValue));
    }

    final oldValue = prefs.getString(baseKey);
    if (oldValue != null && oldValue.isNotEmpty) {
      await prefs.setString(userKey, oldValue);
      return List<String>.from(jsonDecode(oldValue));
    }

    return [];
  }

  static Future<void> saveAbout(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_aboutKey, userId), value);
  }

  static Future<String> getAbout(int userId) async {
    return _getStringWithMigration(_aboutKey, userId);
  }

  static Future<void> saveExperience(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_experienceKey, userId), value);
  }

  static Future<String> getExperience(int userId) async {
    return _getStringWithMigration(_experienceKey, userId);
  }

  static Future<void> saveEducation(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_educationKey, userId), value);
  }

  static Future<String> getEducation(int userId) async {
    return _getStringWithMigration(_educationKey, userId);
  }

  static Future<void> saveEducationLevel(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_educationLevelKey, userId), value);
  }

  static Future<String> getEducationLevel(int userId) async {
    return _getStringWithMigration(_educationLevelKey, userId);
  }

  static Future<void> saveYearsOfExperience(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_yearsOfExperienceKey, userId), value);
  }

  static Future<String> getYearsOfExperience(int userId) async {
    return _getStringWithMigration(_yearsOfExperienceKey, userId);
  }

  static Future<void> saveSkills(int userId, List<String> skills) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_skillsKey, userId), jsonEncode(skills));
  }

  static Future<List<String>> getSkills(int userId) async {
    return _getListWithMigration(_skillsKey, userId);
  }

  static Future<void> saveLanguages(int userId, List<String> languages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_languagesKey, userId), jsonEncode(languages));
  }

  static Future<List<String>> getLanguages(int userId) async {
    return _getListWithMigration(_languagesKey, userId);
  }

  static Future<void> saveCertificates(
    int userId,
    List<String> certificates,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(_certificatesKey, userId),
      jsonEncode(certificates),
    );
  }

  static Future<List<String>> getCertificates(int userId) async {
    return _getListWithMigration(_certificatesKey, userId);
  }

  static Future<void> saveCity(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_cityKey, userId), value);
  }

  static Future<String> getCity(int userId) async {
    return _getStringWithMigration(_cityKey, userId);
  }

  static Future<void> saveCountry(int userId, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_countryKey, userId), value);
  }

  static Future<String> getCountry(int userId) async {
    return _getStringWithMigration(_countryKey, userId);
  }

  static Future<void> saveAll({
    required int userId,
    required String about,
    required String experience,
    required String education,
    required String educationLevel,
    required String yearsOfExperience,
    required List<String> skills,
    required List<String> languages,
    required List<String> certificates,
    String? city,
    String? country,
  }) async {
    await saveAbout(userId, about);
    await saveExperience(userId, experience);
    await saveEducation(userId, education);
    await saveEducationLevel(userId, educationLevel);
    await saveYearsOfExperience(userId, yearsOfExperience);
    await saveSkills(userId, skills);
    await saveLanguages(userId, languages);
    await saveCertificates(userId, certificates);

    if (city != null) {
      await saveCity(userId, city);
    }

    if (country != null) {
      await saveCountry(userId, country);
    }
  }
}