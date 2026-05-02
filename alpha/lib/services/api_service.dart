// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.11:5000"; // ← Update if IP changes

  // ==================== SEND OTP ====================
  Future<Map<String, dynamic>> sendOtp({
    required String name,
    required String email,
  }) async {
    try {
      print("🔄 Sending OTP to: $email");
      print("🌐 URL: $baseUrl/api/auth/send-otp");

      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email}),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📦 Response: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("❌ Connection Error: $e");
      return {
        "success": false,
        "message": "Cannot connect to server.\nCheck:\n1. Backend running?\n2. Correct IP?\n3. Same WiFi?"
      };
    }
  }

  // ==================== VERIFY OTP & REGISTER ====================
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

  // ==================== REGISTER COMPANY (with OTP) ====================
  Future<Map<String, dynamic>> registerCompany({
    required String companyName,
    required String email,
    required String password,
  }) async {
    try {
      final otpResponse = await sendOtp(name: companyName, email: email);
      
      if (otpResponse["success"] != true) {
        return otpResponse;
      }

      // For testing - change later to real OTP from user input
      const String otp = "123456";

      return await verifyOtpAndRegister(
        email: email,
        otp: otp,
        password: password,
      );
    } catch (e) {
      return {"success": false, "message": "Registration failed"};
    }
  }

  // ==================== LOGIN ====================
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

  // ==================== SAVE USER ROLE ====================
  Future<Map<String, dynamic>> saveUserType(String userType) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/onboard"),   // Updated endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userType": userType}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Cannot connect to server"};
    }
  }

  // ==================== OTHER METHODS ====================
  Future<List<dynamic>> getMyPickups(String userEmail) async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/api/requests?userEmail=$userEmail"),
    );

    print("My Requests API Status: ${response.statusCode}"); // ← Add this
    print("Response Body: ${response.body}");               // ← Add this

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['requests'] ?? data ?? [];
    } else {
      return [];
    }
  } catch (e) {
    print("Error fetching my pickups: $e");
    return [];
  }
}

  Future<Map<String, dynamic>> submitPickup({
    required double kg,
    required String userEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/requests"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"kg": kg, "userEmail": userEmail}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Submit Error: $e");
      return {"success": false, "message": "Cannot connect to server"};
    }
  }

  Future<List<dynamic>> getNotifications(String userEmail) async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/api/notifications?userEmail=$userEmail"),
    );

    print("Notifications API Status: ${response.statusCode}");
    print("Notifications Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['notifications'] ?? [];
    } else {
      return [];
    }
  } catch (e) {
    print("Error fetching notifications: $e");
    return [];
  }
}

}