import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GiminiService {
  final String _apikey = dotenv.env['GEMINI_API_KEY'] ?? '';

  GiminiService() {
    if (_apikey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set in .env file');
    }
  }

  Future<String> getGiminiResponse(String userMessage) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apikey',
    );

    // Combine system instruction and user input
    final prompt =
        "You are a helpful. Answer like a professional educator with brief and accurate responses.\n\nUser: $userMessage";

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return reply != null && reply.trim().isNotEmpty
          ? reply
          : "⚠️ Sorry, I didn’t catch that. Please try again.";
    } else if (response.statusCode == 403) {
      return "❌ Access denied. Check your Gemini API key.";
    } else if (response.statusCode == 400) {
      return "⚠️ Invalid input. Please try again.";
    } else {
      return "❌ Gemini Error: ${response.statusCode}. Try again.";
    }
  }
}
