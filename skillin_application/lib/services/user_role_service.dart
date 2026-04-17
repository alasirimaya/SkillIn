import 'package:shared_preferences/shared_preferences.dart';

class UserRoleService {
  static const String _currentRoleKey = "current_user_role";

  static Future<void> saveRoleForEmail(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role_$email", role);
  }

  static Future<String> getRoleForEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role_$email") ?? "personal";
  }

  static Future<void> setCurrentRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentRoleKey, role);
  }

  static Future<String> getCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentRoleKey) ?? "personal";
  }

  static Future<void> clearCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentRoleKey);
  }
}