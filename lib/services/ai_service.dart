class AIService {
  Future<String> getCareerGuidance({
    required String name,
    required String branch,
    required String goal,
    required String question,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return """
Hi $name 👋

Based on your profile:

🎓 Branch: $branch
🎯 Goal: $goal

Here is a clear career roadmap for you:

• Focus on strong fundamentals related to $branch
• Build 2-3 practical projects aligned with your goal
• Learn industry-relevant skills step by step
• Participate in internships and hackathons
• Build a strong resume and LinkedIn profile

📅 Suggested next steps:
• Short term (1-2 months): Skill building + basics
• Mid term (3-6 months): Projects + internships
• Long term (6-12 months): Placement or higher studies

This guidance is generated using a Gemini-designed prompt and can be powered by the live Gemini API when enabled.
""";
  }
}


/*import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = "AIzaSyA0XxVjqxhP8vsY4Pmgy0RmO7QoIkrTHQo";

  Future<String> getCareerGuidance({
    required String name,
    required String branch,
    required String goal,
    required String question,
  }) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey",
    );

    final prompt = """
You are PathPilot, a practical career mentor for college students.

Student:
- Name: $name
- Branch: $branch
- Goal: $goal

Question:
$question

Answer clearly.
Use bullet points.
Be motivating and concise.
""";

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "AI error ${response.statusCode}";
      }
    } catch (e) {
      return "Network error. Please check internet connection.";
    }
  }
}
*/