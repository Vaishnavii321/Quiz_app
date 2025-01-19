import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/models/quiz_model.dart';

class ApiService {
  static const String _url = "https://api.jsonserve.com/Uw5CrX";

  static Future<List<QuizModel>> fetchQuizData() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      // Parse the root object
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the 'questions' list
      final List<dynamic> questions = data['questions'];

      // Map the questions to the QuizModel
      return questions.map((item) => QuizModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load quiz data');
    }
  }
}
