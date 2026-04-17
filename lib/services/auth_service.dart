// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'api_client.dart';
// import 'app_error.dart';

// class AuthService {
//   static const String _baseUrl = "http://127.0.0.1:8000";
//   static const String _tokenKey = "access_token";

//   static const FlutterSecureStorage _storage = FlutterSecureStorage();
//   static final ApiClient _api = ApiClient(baseUrl: _baseUrl);

//   static Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final data = await _api.postJson<Map<String, dynamic>>(
//         "/api/v1/auth/login",
//         body: {
//           "email": email.trim(),
//           "password": password,
//         },
//         parser: (json) => (json as Map).cast<String, dynamic>(),
//       );

//       final token = data["access_token"]?.toString();
//       if (token == null || token.isEmpty) {
//         return {"ok": false, "msg": "No token returned from server."};
//       }

//       await _storage.write(key: _tokenKey, value: token);
//       return {"ok": true, "token": token};
//     } catch (e) {
//       print("LOGIN ERROR: $e");
//       final msg = e is AppError ? e.message : "Login failed: $e";
//       final status = e is AppError ? e.statusCode : null;
//       return {"ok": false, "msg": msg, "status": status};
//     }
//   }

//   static Future<Map<String, dynamic>> register({
//     required String fullName,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await _api.postJson(
//         "/api/v1/auth/register",
//         body: {
//           "full_name": fullName.trim(),
//           "email": email.trim(),
//           "password": password,
//         },
//       );

//       return {"ok": true};
//     } catch (e) {
//       print("REGISTER ERROR: $e");
//       final msg = e is AppError ? e.message : "Registration failed: $e";
//       final status = e is AppError ? e.statusCode : null;
//       return {"ok": false, "msg": msg, "status": status};
//     }
//   }

//   static Future<Map<String, dynamic>> forgotPassword({
//     required String email,
//   }) async {
//     try {
//       final data = await _api.postJson<Map<String, dynamic>>(
//         "/api/v1/auth/forgot-password",
//         body: {
//           "email": email.trim(),
//         },
//         parser: (json) => (json as Map).cast<String, dynamic>(),
//       );

//       return {
//         "ok": true,
//         "msg": data["message"] ?? "If this email exists, a reset link has been sent."
//       };
//     } catch (e) {
//       print("FORGOT PASSWORD ERROR: $e");
//       final msg = e is AppError ? e.message : "Forgot password request failed: $e";
//       final status = e is AppError ? e.statusCode : null;
//       return {"ok": false, "msg": msg, "status": status};
//     }
//   }

//   static Future<Map<String, dynamic>> getMe() async {
//     final token = await getToken();
//     if (token == null || token.isEmpty) {
//       return {"ok": false, "msg": "No token found. Please login first."};
//     }

//     try {
//       final data = await _api.getJson<Map<String, dynamic>>(
//         "/api/v1/auth/me",
//         token: token,
//         parser: (json) => (json as Map).cast<String, dynamic>(),
//       );

//       return {"ok": true, "data": data};
//     } catch (e) {
//       if (e is AppError && e.statusCode == 401) {
//         await logout();
//       }

//       final msg = e is AppError ? e.message : "Failed to fetch user data.";
//       final status = e is AppError ? e.statusCode : null;
//       return {"ok": false, "msg": msg, "status": status};
//     }
//   }

//   static Future<String?> getToken() async {
//     return _storage.read(key: _tokenKey);
//   }

//   static Future<bool> isLoggedIn() async {
//     final t = await getToken();
//     return t != null && t.isNotEmpty;
//   }

//   static Future<void> logout() async {
//     await _storage.delete(key: _tokenKey);
//   }

//   // ⭐⭐ دالة جديدة لمسح كل التوكنات (تشغيل مرة واحدة فقط)
//   static Future<void> forceLogoutForDebug() async {
//     await _storage.deleteAll();
//   }
// }
