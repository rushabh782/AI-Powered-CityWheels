import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  // Replace with your actual API endpoint
  static const String _baseUrl = 'YOUR_API_ENDPOINT';

  Future<String> getResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          // Add any required headers (e.g., API key)
        },
        body: jsonEncode({
          'message': message,
          // Add any other required parameters
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response']; // Adjust based on your API response structure
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
