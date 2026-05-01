import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import 'app_error.dart';

class JobsService {
  static const String _baseUrl = "http://127.0.0.1:8000";
  static final ApiClient _api = ApiClient(baseUrl: _baseUrl);

  static Future<Map<String, dynamic>> getJobs() async {
    try {
      final data = await _api.getJson<List<dynamic>>(
        "/api/v1/jobs/",
        parser: (json) => (json as List).cast<dynamic>(),
      );

      return {"ok": true, "data": data};
    } catch (e) {
      final msg = e is AppError ? e.message : "Failed to load jobs.";
      final status = e is AppError ? e.statusCode : null;
      return {"ok": false, "msg": msg, "status": status};
    }
  }

  static Future<Map<String, dynamic>> getJobById(int id) async {
    try {
      final data = await _api.getJson<Map<String, dynamic>>(
        "/api/v1/jobs/$id",
        parser: (json) => (json as Map).cast<String, dynamic>(),
      );

      return {"ok": true, "data": data};
    } catch (e) {
      final msg = e is AppError ? e.message : "Failed to load job.";
      final status = e is AppError ? e.statusCode : null;
      return {"ok": false, "msg": msg, "status": status};
    }
  }

  static Future<Map<String, dynamic>> createJob({
    required String title,
    required String company,
    required String workplace,
    required String location,
    required String employmentType,
    required String educationRequirement,
    required String experienceRequirement,
    required String languages,
    required String skills,
    required String description,
  }) async {
    try {
      final data = await _api.postJson<Map<String, dynamic>>(
        "/api/v1/jobs/?title=${Uri.encodeComponent(title)}"
        "&company=${Uri.encodeComponent(company)}"
        "&workplace=${Uri.encodeComponent(workplace)}"
        "&location=${Uri.encodeComponent(location)}"
        "&employment_type=${Uri.encodeComponent(employmentType)}"
        "&education_requirement=${Uri.encodeComponent(educationRequirement)}"
        "&experience_requirement=${Uri.encodeComponent(experienceRequirement)}"
        "&languages=${Uri.encodeComponent(languages)}"
        "&skills=${Uri.encodeComponent(skills)}"
        "&description=${Uri.encodeComponent(description)}",
        body: {},
        parser: (json) => (json as Map).cast<String, dynamic>(),
      );

      return {"ok": true, "data": data};
    } catch (e) {
      final msg = e is AppError ? e.message : "Failed to create job.";
      final status = e is AppError ? e.statusCode : null;
      return {"ok": false, "msg": msg, "status": status};
    }
  }

  static Future<Map<String, dynamic>> getRecommendations(int userId) async {
    try {
      final data = await _api.getJson<Map<String, dynamic>>(
        "/api/v1/recommend/recommend/$userId",
        parser: (json) => (json as Map).cast<String, dynamic>(),
      );

      return {"ok": true, "data": data};
    } catch (e) {
      final msg = e is AppError ? e.message : "Failed to load recommendations.";
      final status = e is AppError ? e.statusCode : null;
      return {"ok": false, "msg": msg, "status": status};
    }
  }

  static Future<Map<String, dynamic>> getApplicantsByJobId(int jobId) async {
    try {
      final data = await _api.getJson<List<dynamic>>(
        "/api/v1/applications/job/$jobId",
        parser: (json) => (json as List).cast<dynamic>(),
      );

      return {"ok": true, "data": data};
    } catch (e) {
      final msg = e is AppError ? e.message : "Failed to load applicants.";
      final status = e is AppError ? e.statusCode : null;
      return {"ok": false, "msg": msg, "status": status};
    }
  }

  static Future<Map<String, dynamic>> updateApplicationStatus({
    required int applicationId,
    required String status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(
          "$_baseUrl/api/v1/applications/$applicationId/status?status=${Uri.encodeComponent(status)}",
        ),
      );

      if (response.statusCode == 200) {
        return {
          "ok": true,
          "data": jsonDecode(response.body),
        };
      }

      return {
        "ok": false,
        "msg": response.body,
        "status": response.statusCode,
      };
    } catch (e) {
      return {
        "ok": false,
        "msg": "Failed to update status: $e",
      };
    }
  }
}