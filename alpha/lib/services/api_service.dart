// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

static const String baseUrl = "http://192.168.1.11:5000"; // Real device

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

      print("Send OTP Status: ${response.statusCode}"); // For debugging
      return jsonDecode(response.body);
    } catch (e) {
      print("Connection Error: $e");
      return {"success": false, "message": "Cannot connect to server. Backend not running or wrong IP."};
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
      return {"success": false, "message": "Cannot connect to server"};
    }
  }

  Future<Map<String, dynamic>> registerCompany({
  required String companyName,
  required String email,
  required String password,
}) async {
  try {
    // Step 1: Send OTP
    final otpResponse = await http.post(
      Uri.parse("$baseUrl/api/auth/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": companyName,
        "email": email,
      }),
    );

    final otpData = jsonDecode(otpResponse.body);

    if (otpData["success"] != true) {
      return otpData;
    }

    // ⚠️ For now (testing), use OTP from backend console
    String otp = "123456"; // replace with real OTP printed in backend

    // Step 2: Verify OTP + register
    final verifyResponse = await http.post(
      Uri.parse("$baseUrl/api/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
        "password": password,
      }),
    );

    return jsonDecode(verifyResponse.body);
  } catch (e) {
    return {"success": false, "message": "Cannot connect to server"};
  }
}

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

  // === Save Role ===
  Future<Map<String, dynamic>> saveUserType(String userType) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/onboard"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userType": userType}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Cannot connect to server"};
    }
  }
  // Add this inside ApiService class
// Add this inside ApiService class

  // ===================== FETCH MY PICKUPS =====================
  Future<List<dynamic>> getMyPickups() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/requests"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['requests'] ?? data; // Adjust based on your backend response
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching pickups: $e");
      return [];
    }
  }

  // ===================== SUBMIT PICKUP =====================
  Future<Map<String, dynamic>> submitPickup({
    required double kg,
    required String userEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/requests"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "kg": kg,
          "userEmail": userEmail,
        }),
      );

      print("Submit Status: ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (e) {
      print("Submit Error: $e");
      return {"success": false, "message": "Cannot connect to server"};
    }
  }
}