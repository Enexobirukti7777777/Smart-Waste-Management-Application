class ApiService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    // Fake login logic
    if (email == "collector@test.com" && password == "1234") {
      return {
        "success": true,
        "user": {
          "email": email,
          "name": "Collector Demo"
        }
      };
    } else {
      return {
        "success": false,
        "message": "Invalid credentials"
      };
    }
  }
}