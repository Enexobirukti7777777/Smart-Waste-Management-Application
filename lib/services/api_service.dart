// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.13:5000";
  static const String _tokenKey = "collector_token";

  // ─────────────────────────────────────────────────────────────────────────
  // TOKEN MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRIVATE HTTP HELPERS
  // Every request goes through these — auth header is added automatically.
  // ─────────────────────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// GET request — returns decoded body or throws on non-2xx
  Future<dynamic> _get(String path) async {
    final response = await http
        .get(Uri.parse("$baseUrl$path"), headers: await _authHeaders())
        .timeout(const Duration(seconds: 15));
    return _handleResponse(response);
  }

  /// POST request
  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    final response = await http
        .post(
          Uri.parse("$baseUrl$path"),
          headers: await _authHeaders(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
    return _handleResponse(response);
  }

  /// PUT request
  Future<dynamic> _put(String path, Map<String, dynamic> body) async {
    final response = await http
        .put(
          Uri.parse("$baseUrl$path"),
          headers: await _authHeaders(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
    return _handleResponse(response);
  }

  /// Multipart POST — for photo uploads
  Future<dynamic> _postMultipart(String path, File file, String fieldName) async {
    final token = await getToken();
    final request = http.MultipartRequest('POST', Uri.parse("$baseUrl$path"));

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    final streamed = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  /// Central response handler — consistent for all methods
  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    // Non-2xx: return the error body so the UI can show server messages
    if (decoded is Map<String, dynamic>) {
      return {
        "success": false,
        "message": decoded['message'] ?? "Something went wrong",
        "statusCode": response.statusCode,
      };
    }

    return {
      "success": false,
      "message": "Server error (${response.statusCode})",
      "statusCode": response.statusCode,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /api/auth/send-otp
  Future<Map<String, dynamic>> sendOtp({
    required String name,
    required String email,
  }) async {
    try {
      return await _post('/api/auth/send-otp', {"name": name, "email": email});
    } catch (e) {
      return _connectionError(e);
    }
  }

  /// POST /api/auth/verify-otp
  Future<Map<String, dynamic>> verifyOtpAndRegister({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      return await _post('/api/auth/verify-otp', {
        "email": email,
        "otp": otp,
        "password": password,
      });
    } catch (e) {
      return _connectionError(e);
    }
  }

  /// POST /api/auth/login
  /// Saves the token automatically on success.
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await _post('/api/auth/login', {
        "email": email,
        "password": password,
      });
      if (result['success'] == true && result['token'] != null) {
        await saveToken(result['token']);
      }
      return result;
    } catch (e) {
      return _connectionError(e);
    }
  }

  /// POST /api/auth/logout  (also clears local token)
  Future<void> logout() async {
    try {
      await _post('/api/auth/logout', {});
    } catch (_) {
      // Always clear locally even if server call fails
    } finally {
      await clearToken();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — STATUS
  // ─────────────────────────────────────────────────────────────────────────

  /// PUT /api/collector/status
  /// Body: { "isOnline": true/false }
  Future<Map<String, dynamic>> updateCollectorStatus(bool isOnline) async {
    try {
      return await _put('/api/collector/status', {"isOnline": isOnline});
    } catch (e) {
      return _connectionError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — DASHBOARD
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /api/collector/stats
  /// Returns today's summary: assignedToday, completedToday, earningsToday,
  /// rating, recentActivity[]
  Future<Map<String, dynamic>> getCollectorStats() async {
    try {
      return await _get('/api/collector/stats');
    } catch (e) {
      return _connectionError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — PROFILE
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /api/collector/profile
  Future<Map<String, dynamic>> getCollectorProfile() async {
    try {
      return await _get('/api/collector/profile');
    } catch (e) {
      return _connectionError(e);
    }
  }

  /// PUT /api/collector/profile
  Future<Map<String, dynamic>> updateCollectorProfile(
      Map<String, dynamic> data) async {
    try {
      return await _put('/api/collector/profile', data);
    } catch (e) {
      return _connectionError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — AVAILABLE REQUESTS
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /api/collector/available-requests
  /// Returns a List of request objects
  Future<List<dynamic>> getAvailableRequests() async {
    try {
      final data = await _get('/api/collector/available-requests');
      return (data as Map<String, dynamic>)['requests'] ?? [];
    } catch (e) {
      return [];
    }
  }

  /// POST /api/collector/requests/:id/accept
  Future<Map<String, dynamic>> acceptPickup(String requestId) async {
    try {
      return await _post('/api/collector/requests/$requestId/accept', {});
    } catch (e) {
      return _connectionError(e);
    }
  }

  /// POST /api/collector/requests/:id/reject
  Future<Map<String, dynamic>> rejectPickup(String requestId) async {
    try {
      return await _post('/api/collector/requests/$requestId/reject', {});
    } catch (e) {
      return _connectionError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — MY TASKS
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /api/collector/my-tasks
  /// Returns a List of active/pending task objects
  Future<List<dynamic>> getMyTasks() async {
    try {
      final data = await _get('/api/collector/my-tasks');
      return (data as Map<String, dynamic>)['tasks'] ?? [];
    } catch (e) {
      return [];
    }
  }

  /// PUT /api/collector/requests/:id/status
  /// Body: { "status": "on_the_way" | "arrived" | "collecting" | "completed" | "cancelled" }
  Future<Map<String, dynamic>> updatePickupStatus(
      String requestId, String status) async {
    try {
      return await _put(
          '/api/collector/requests/$requestId/status', {"status": status});
    } catch (e) {
      return _connectionError(e);
    }
  }

  /// POST /api/collector/requests/:id/photo  (multipart)
  Future<Map<String, dynamic>> uploadPickupPhoto(
      String requestId, File photo) async {
    try {
      return await _postMultipart(
          '/api/collector/requests/$requestId/photo', photo, 'photo');
    } catch (e) {
      return _connectionError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — JOB HISTORY
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /api/collector/job-history?page=1&limit=20
  Future<List<dynamic>> getJobHistory({int page = 1}) async {
    try {
      final data =
          await _get('/api/collector/job-history?page=$page&limit=20');
      return (data as Map<String, dynamic>)['jobs'] ?? [];
    } catch (e) {
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COLLECTOR — REGISTRATION
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /api/collector/register
  /// Body: name, phone, email, password, idNumber, experience, vehicle, workingArea
  Future<Map<String, dynamic>> registerCollector({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String idNumber,
    required String experience,
    required String vehicle,
    required String workingArea,
  }) async {
    try {
      return await _post('/api/collector/register', {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "idNumber": idNumber,
        "experience": experience,
        "vehicle": vehicle,
        "workingArea": workingArea,
      });
    } catch (e) {
      return _connectionError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRIVATE UTILITY
  // ─────────────────────────────────────────────────────────────────────────

  /// Consistent error map for catch blocks
  Map<String, dynamic> _connectionError(Object e) {
    // Distinguish timeout from no-network
    if (e.toString().contains('TimeoutException')) {
      return {"success": false, "message": "Request timed out. Please retry."};
    }
    return {"success": false, "message": "Cannot connect to server"};
  }
}