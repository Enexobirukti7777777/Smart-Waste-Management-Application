import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // TODO: Put your Gemini API Key here
  static const String _apiKey = "YOUR_GEMINI_API_KEY_HERE";
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl?key=$_apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """
You are a helpful assistant for Smart Waste Collector app in Ethiopia.
Help users with waste management, pickup requests, recycling tips, and environmental advice.
Keep responses short, friendly, and useful.
User message: $userMessage
"""
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 300,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        return reply;
      } else {
        return "Sorry, I'm having trouble connecting right now. Please try again.";
      }
    } catch (e) {
      return "Connection error. Please check your internet and try again.";
    }
  }
}