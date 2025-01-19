import 'package:quiz_app/models/option_model.dart';

class QuizModel {
  final String question;
  final List<Option> options;
  final String correctAnswer;

  QuizModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['description'],
      options: (json['options'] as List<dynamic>)
          .map((option) => Option.fromJson(option))
          .toList(),
      correctAnswer: (json['options'] as List<dynamic>)
          .firstWhere((option) => option['is_correct'] == true)['description'],
    );
  }
}
