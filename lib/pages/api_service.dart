import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<String?> sendQuestionToApi(String question) async {
    try {
      final url = Uri.parse('http://192.168.3.104:5000/get_answer'); // or your computer IP for physical device
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'];  // Extract the 'answer' from the JSON response
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return 'Error: ${response.statusCode}, ${response.body}';
      }
    } catch (e) {
      print('Error sending question: $e');
      return 'Error sending question: $e';
    }
  }
}
