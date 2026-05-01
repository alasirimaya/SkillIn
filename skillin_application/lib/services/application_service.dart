/*import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:skillin_application/models/application_model.dart';

class ApplicationService {
static const String baseUrl =
"http://localhost:8000/api/v1";

  static Future<List<ApplicationModel>> fetchApplications() async {

    final response = await http.get(
      Uri.parse("$baseUrl/applications"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data
          .map((json) => ApplicationModel.fromJson(json))
          .toList();

    } else {

      throw Exception("Failed to load applications");

    }

  }

}
*/
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/application_model.dart';

class ApplicationService {
  static const String baseUrl = "http://127.0.0.1:8000/api/v1";

  static final List<ApplicationModel> _localApplications = [];

  static Future<List<ApplicationModel>> fetchApplicationsByUser(
    int userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/applications/user/$userId"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        final apiApplications = data
            .map((json) => ApplicationModel.fromJson(json))
            .toList();

        return [..._localApplications, ...apiApplications];
      } else {
        return [..._localApplications];
      }
    } catch (e) {
      print("FETCH APPLICATIONS ERROR: $e");
      return [..._localApplications];
    }
  }

  static Future<Map<String, dynamic>> applyToJob({
    required int jobId,
    required int userId,
    required String info,
    required String cvPath,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/applications/apply"),
      );

      request.fields["job_id"] = jobId.toString();
      request.fields["user_id"] = userId.toString();
      request.fields["info"] = info;

      request.files.add(
        await http.MultipartFile.fromPath(
          "cv",
          cvPath,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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
        "msg": "Failed to submit application: $e",
      };
    }
  }

  static Future<Map<String, dynamic>> updateApplicationStatus({
    required int applicationId,
    required String status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(
          "$baseUrl/applications/$applicationId/status?status=$status",
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

  static void addLocalApplication(ApplicationModel application) {
    _localApplications.insert(0, application);
  }
}