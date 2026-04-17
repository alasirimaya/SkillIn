// import 'api_client.dart';
// import 'app_error.dart';

// class JobsService {
//   static const String _baseUrl = "http://127.0.0.1:8000";
//   static final ApiClient _api = ApiClient(baseUrl: _baseUrl);

//   static Future<Map<String, dynamic>> getJobs() async {
//     try {
//       final data = await _api.getJson<List<dynamic>>(
//         "/api/v1/jobs/",
//         parser: (json) => (json as List).cast<dynamic>(),
//       );

//       return {"ok": true, "data": data};
//     } catch (e) {
//       final msg = e is AppError ? e.message : "Failed to load jobs.";
//       final status = e is AppError ? e.statusCode : null;
//       return {"ok": false, "msg": msg, "status": status};
//     }
//   }

//   static Future<Map<String, dynamic>> getJobById(int id) async {
//     try {
//       final data = await _api.getJson<Map<String, dynamic>>(
//         "/api/v1/jobs/$id",
//         parser: (json) => (json as Map).cast<String, dynamic>(),
//       );

//       return {"ok": true, "data": data};
//     } catch (e) {
//       final msg = e is AppError ? e.message : "Failed to load job.";
//       final status = e is AppError ? e.statusCode : null;
//       return {"ok": false, "msg": msg, "status": status};
//     }
//   }
// }