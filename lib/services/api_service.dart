// lib/services/api_service.dart (in Collector App)
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.11:5000";

  
  Future<Map<String, dynamic>> sendOtp({
    required String name,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Send OTP Error: $e");
      return {"success": false, "message": "Cannot connect to server"};
    }
  }

  Future<Map<String, dynamic>> verifyOtpAndRegister({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "password": password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Verify OTP Error: $e");
      return {"success": false, "message": "Cannot connect to server"};
    }
  }

  // Login (already exists)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Cannot connect to server"};
    }
  }
    // ===================== COLLECTOR APIS =====================

  // Get Available Requests for Collector
  Future<List<dynamic>> getAvailableRequests() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/collector/available-requests"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['requests'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error fetching available requests: $e");
      return [];
    }
  }

  // Get My Tasks (Assigned to Collector)
  Future<List<dynamic>> getMyTasks() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/collector/my-tasks"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['tasks'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error fetching my tasks: $e");
      return [];
    }
  }

  // Accept a Pickup Request
  Future<Map<String, dynamic>> acceptPickup(String requestId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/collector/requests/$requestId/accept"),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Cannot connect to server"};
    }
  }

  // Update Pickup Status
  Future<Map<String, dynamic>> updatePickupStatus(String requestId, String status) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/api/collector/requests/$requestId/status"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Cannot connect to server"};
    }
  }
}